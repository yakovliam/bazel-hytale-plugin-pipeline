minikube start --driver=podman --container-runtime=cri-o \
  --insecure-registry="localhost:5001" \
  --insecure-registry="host.docker.internal:5001" \
  --insecure-registry="192.168.1.42:5001"
