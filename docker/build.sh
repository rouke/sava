#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ -z "$1" ]
then
  echo "No version specified. Aborting."
  exit 1
fi

VERSION=$1

echo "cleaning..."

rm -Rf $DIR/target 2> /dev/null
mkdir $DIR/target

for SERVICE in 1.0_monolith 1.1_monolith 1.2_frontend 1.2_backend 1.3_frontend
do
  echo "building:" $SERVICE
  mkdir $DIR/target/$SERVICE
  cd $DIR/../$SERVICE && sbt clean assembly
  cp $DIR/../$SERVICE/target/scala-2.11/$SERVICE.jar $DIR/target/$SERVICE/.
  sed -e 's/_SERVICE_/'${SERVICE}'/g' $DIR/Dockerfile > $DIR/target/$SERVICE/Dockerfile
  docker build -t magneticio/sava-$SERVICE:$VERSION $DIR/target/$SERVICE
  docker push magneticio/sava-$SERVICE:$VERSION
done
