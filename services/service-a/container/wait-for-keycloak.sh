#!/bin/sh

until curl -sf http://keycloak/realms/myrealm; do
    echo "Waiting for Keycloak..."
    sleep 5
done

java -jar /app/servicea-spring.jar
