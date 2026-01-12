#!/bin/sh

until curl -sf http://keycloak/realms/master; do
    echo "Waiting for Keycloak..."
    sleep 5
done

java -jar /app/service-b-spring.jar
