def postgres_service(name, service_name, db_name, password_secret_name, visibility=None):
    """Generates PostgreSQL Deployment and Service for a specific microservice."""

    static_password = "password"

    # Generate PostgreSQL Password Secret
    native.genrule(
        name = "%s_db_secret" % name,
        outs = ["%s-db-secret.yaml" % name],
        cmd = """cat > $@ <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: {password_secret_name}
stringData:
  password: {password}
EOF""".format(password_secret_name=password_secret_name, password=static_password),
    )

    # PostgreSQL PersistentVolumeClaim
    native.genrule(
        name = "%s_pvc" % name,
        outs = ["%s-pvc.yaml" % name],
        cmd = """cat > $@ <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc-{service_name}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF""".format(service_name=service_name),
    )

    # PostgreSQL Deployment with dynamic user/password
    native.genrule(
        name = "%s_deployment" % name,
        outs = ["%s-deployment.yaml" % name],
        cmd = """cat > $@ <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres-{service_name}
spec:
  replicas: 1
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: postgres-{service_name}
  template:
    metadata:
      labels:
        app: postgres-{service_name}
    spec:
      containers:
      - name: postgres
        image: docker.io/library/postgres:18
        env:
        - name: POSTGRES_DB
          value: {db_name}
        - name: POSTGRES_USER
          value: {service_name}_user
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: {password_secret_name}
              key: password
        - name: PGDATA
          value: /var/lib/postgresql/data
        volumeMounts:
        - name: postgres-data
          mountPath: /var/lib/postgresql
      volumes:
      - name: postgres-data
        persistentVolumeClaim:
          claimName: postgres-pvc-{service_name}
EOF""".format(
            service_name = service_name,
            db_name = db_name,
            password_secret_name = password_secret_name
        ),
    )

    # PostgreSQL Service
    native.genrule(
        name = "%s_service" % name,
        outs = ["%s-service.yaml" % name],
        cmd = """cat > $@ <<EOF
apiVersion: v1
kind: Service
metadata:
  name: postgres-{service_name}
  labels:
    service: {service_name}
spec:
  selector:
    app: postgres-{service_name}
  ports:
  - port: 5432
    targetPort: 5432
EOF""".format(service_name = service_name),
    )

    native.filegroup(
        name = name,
        srcs = [
            "%s_deployment" % name,
            "%s_service" % name,
            "%s_db_secret" % name,
            "%s_pvc" % name,
        ]
    )
