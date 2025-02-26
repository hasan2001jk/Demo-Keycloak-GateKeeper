#!/bin/sh
# This script sets up keycloak by creating the applications realm if it does not already exist


# Download wait-for-it.sh if it doesn't exist
[ -f /keycloak/wait-for-it.sh ] || curl -o /keycloak/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && chmod +x /keycloak/wait-for-it.sh

# Wait for keycloak to start
/keycloak/wait-for-it.sh keycloak:8443 -t 75

export PATH=$PATH:/opt/keycloak/bin

echo '>>> Logging into Keycloak'
kcadm.sh config credentials --server http://keycloak:8080 --realm master --user admin --password password

# This won't create another realm if one with this name exists
echo '>>> Creating applications realm'
kcadm.sh get realms/applications || kcadm.sh create realms -s realm=applications -s displayName=Applications -s enabled=true

# This won't create another user if a user with this username already exists
echo '>>> Creating user with username=user and password=password'
kcadm.sh create users -r applications -f - <<EOF
{
  "username": "user",
  "email": "user@email.com",
  "firstName": "John",
  "lastName": "Doe",
  "enabled": true,
  "emailVerified": true,
  "credentials": [{
    "type": "password",
    "value": "password",
    "temporary": false
  }]
}
EOF
