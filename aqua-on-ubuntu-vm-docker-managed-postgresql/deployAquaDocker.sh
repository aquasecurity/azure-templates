#!/bin/bash

echo "step start: globals"
ADMIN_USER=$1
DOCKER_USER=$2
DOCKER_PASS=$3
DOCKER_REGISTRY=$4
AQUA_REPO=$5
AQUA_VERSION=$6
AQUA_DB_USER=$7
AQUA_DB_PASSWORD=$8
AQUA_DB_SERVER=$9
AQUA_LICENSE_TOKEN=${10}
AQUA_ADMIN_PASSWORD=${11}
echo "step end: globals"

echo "ADMIN_USER: $ADMIN_USER"
echo "AQUA_VERSION: $AQUA_VERSION"

echo "step start: install docker-ce"
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce jq
sudo groupadd docker
sudo usermod -aG docker $ADMIN_USER
sudo systemctl start docker
sudo systemctl enable docker
sleep 10
docker version
lExitCode=$?
if [ $lExitCode == "0" ];then
  echo "Docker installed successfully"
else
  echo "Failed to install docker, exit code : $lExitCode, exiting"
  exit 1
fi
echo "step end: install docker-ce"

#Docker login
echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin $DOCKER_REGISTRY
lExitCode=$?
if [ $lExitCode == "0" ];then
  echo "Sucessfully logged in to DOCKER_REGISTRY"
else
  echo "Failed to login to DOCKER_REGISTRY, exit code : $lExitCode , exiting"
  exit 1
fi

#Start Aqua Server
echo "step start: start Aqua server container"
docker run -d -p 8080:8080 -p 443:8443 \
   --name aqua-web --user=root \
   -e SCALOCK_DBUSER=${AQUA_DB_USER} \
   -e SCALOCK_DBPASSWORD=${AQUA_DB_PASSWORD} \
   -e SCALOCK_DBNAME=scalock \
   -e SCALOCK_DBHOST=${AQUA_DB_SERVER} \
   -e SCALOCK_AUDIT_DBUSER=${AQUA_DB_USER} \
   -e SCALOCK_AUDIT_DBPASSWORD=${AQUA_DB_PASSWORD} \
   -e SCALOCK_AUDIT_DBNAME=slk_audit \
   -e SCALOCK_AUDIT_DBHOST=${AQUA_DB_SERVER} \
   -e LICENSE_TOKEN=${AQUA_LICENSE_TOKEN} \
   -e ADMIN_PASSWORD=${AQUA_ADMIN_PASSWORD} \
   -v /var/run/docker.sock:/var/run/docker.sock \
$AQUA_REPO/server:$AQUA_VERSION
lExitCode=$?
if [ $lExitCode == "0" ];then
  echo "Sucessfully ran $AQUA_REPO/server:$AQUA_VERSION"
else
  echo "Failed to run $AQUA_REPO/server:$AQUA_VERSION, exit code : $lExitCode , exiting"
  exit 1
fi
echo "step end: start Aqua server container"

#Start Aqua Gateway
echo "step start: start Aqua gateway container"
docker run -d -p 3622:3622 --net=host --name aqua-gateway \
    -e SCALOCK_DBUSER=${AQUA_DB_USER} \
    -e SCALOCK_DBPASSWORD=${AQUA_DB_PASSWORD} \
    -e SCALOCK_DBNAME=scalock \
    -e SCALOCK_DBHOST=${AQUA_DB_SERVER} \
    -e SCALOCK_AUDIT_DBUSER=${AQUA_DB_USER} \
    -e SCALOCK_AUDIT_DBPASSWORD=${AQUA_DB_PASSWORD} \
    -e SCALOCK_AUDIT_DBNAME=slk_audit \
    -e SCALOCK_AUDIT_DBHOST=${AQUA_DB_SERVER} \
$AQUA_REPO/gateway:$AQUA_VERSION
lExitCode=$?
if [ $lExitCode == "0" ];then
  echo "Sucessfully ran $AQUA_REPO/gateway:$AQUA_VERSION"
else
  echo "Failed to run $AQUA_REPO/gateway:$AQUA_VERSION, exit code : $lExitCode , exiting"
  exit 1
fi
echo "step end: start Aqua gateway container"

echo "step start: monitoring server logs to validate startup"
( docker logs aqua-web -f & ) | grep -q "http server started"
echo "step end: monitoring server logs to validate startup"

echo "Finished installing docker and deploying Aqua"
