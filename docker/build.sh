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
  echo "building jar:" $SERVICE
  mkdir $DIR/target/$SERVICE
  cd $DIR/../$SERVICE && sbt clean assembly
  cp $DIR/../$SERVICE/target/scala-2.11/$SERVICE.jar $DIR/target/$SERVICE/.
done

for SERVICE in 1.0_monolith 1.1_monolith 1.2_backend
do
  echo "building docker image:" $SERVICE
  sed -e 's/_SERVICE_/'${SERVICE}'/g' $DIR/Dockerfile > $DIR/target/$SERVICE/Dockerfile
  echo '#!/usr/bin/env bash' > $DIR/target/$SERVICE/run.sh
  echo '' >> $DIR/target/$SERVICE/run.sh
  echo 'java -jar /'$SERVICE'.jar' >> $DIR/target/$SERVICE/run.sh
  docker build -t magneticio/sava-$SERVICE:$VERSION $DIR/target/$SERVICE
  docker push magneticio/sava-$SERVICE:$VERSION
done

SERVICE="1.2_frontend"
echo "building docker image:" $SERVICE
sed -e 's/_SERVICE_/'${SERVICE}'/g' -e "s/_CMD_/${CMD}/g" $DIR/Dockerfile > $DIR/target/$SERVICE/Dockerfile
echo '#!/usr/bin/env bash' > $DIR/target/$SERVICE/run.sh
echo '' >> $DIR/target/$SERVICE/run.sh
echo 'java -Dfrontend.backend1.host=$BACKEND_1_HOST -Dfrontend.backend1.port=$BACKEND_1_PORT -Dfrontend.backend2.host=$BACKEND_2_HOST -Dfrontend.backend2.port=$BACKEND_2_PORT -jar /'$SERVICE'.jar' >> $DIR/target/$SERVICE/run.sh
docker build -t magneticio/sava-$SERVICE:$VERSION $DIR/target/$SERVICE
docker push magneticio/sava-$SERVICE:$VERSION

SERVICE="1.3_frontend"
echo "building docker image:" $SERVICE
sed -e 's/_SERVICE_/'${SERVICE}'/g' $DIR/Dockerfile > $DIR/target/$SERVICE/Dockerfile
echo '#!/usr/bin/env bash' > $DIR/target/$SERVICE/run.sh
echo '' >> $DIR/target/$SERVICE/run.sh
echo 'java -Dfrontend.backend.host=$BACKEND_HOST -Dfrontend.backend.port=$BACKEND_PORT -jar /'$SERVICE'.jar' >> $DIR/target/$SERVICE/run.sh
docker build -t magneticio/sava-$SERVICE:$VERSION $DIR/target/$SERVICE
docker push magneticio/sava-$SERVICE:$VERSION
