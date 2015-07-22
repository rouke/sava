#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ -z "$1" ]
then
  echo "No version specified. Aborting."
  exit 1
fi

VERSION=$1

echo "cleaning..."

rm -Rf ${DIR}/target 2> /dev/null
mkdir ${DIR}/target

echo "building jars..."

for SERVICE in sava_1.0 sava_1.1 sava_frontend_1.2 sava_backend_1.2 sava_frontend_1.3
do
  echo "building jar: ${SERVICE}.jar"
  mkdir ${DIR}/target/${SERVICE}
  cd ${DIR}/../${SERVICE} && sbt clean assembly
  cp ${DIR}/../${SERVICE}/target/scala-2.11/${SERVICE}.jar ${DIR}/target/${SERVICE}/.
done

function createDockerFileFor {
  sed -e 's/_SERVICE_/'${1}'/g' ${DIR}/Dockerfile > ${DIR}/target/$1/Dockerfile
}

function createRunFileFor {
  echo '#!/usr/bin/env bash' > ${DIR}/target/${1}/run.sh
  printf "\n" >> ${DIR}/target/${1}/run.sh
  echo 'java '${2}' -jar /'${1}'.jar' >> ${DIR}/target/${1}/run.sh
}

function buildDockerImageFor {
  docker build -t magneticio/${1} ${DIR}/target/${2}
}

echo "building docker images..."

echo "building docker image: sava_1.0".${VERSION}
createDockerFileFor sava_1.0
createRunFileFor sava_1.0
buildDockerImageFor sava:1.0.${VERSION} sava_1.0

echo "building docker image: sava_1.1".${VERSION}
createDockerFileFor sava_1.1
createRunFileFor sava_1.1
buildDockerImageFor sava:1.1.${VERSION} sava_1.1

echo "building docker image: sava_frontend_1.2".${VERSION}
createDockerFileFor sava_frontend_1.2
createRunFileFor sava_frontend_1.2 '-Dfrontend.backend1=$'BACKEND_1' -Dfrontend.backend2=$'BACKEND_2
buildDockerImageFor sava-frontend:1.2.${VERSION} sava_frontend_1.2

echo "building docker image: sava-backend1:1.2".${VERSION}
createDockerFileFor sava_backend_1.2
createRunFileFor sava_backend_1.2
buildDockerImageFor sava-backend1:1.2.${VERSION} sava_backend_1.2

echo "building docker image: sava-backend2:1.2".${VERSION}
createDockerFileFor sava_backend_1.2
createRunFileFor sava_backend_1.2
buildDockerImageFor sava-backend2:1.2.${VERSION} sava_backend_1.2

echo "building docker image: sava_frontend_1.3".${VERSION}
createDockerFileFor sava_frontend_1.3
createRunFileFor sava_frontend_1.3 '-Dfrontend.backend=$'BACKEND
buildDockerImageFor sava-frontend:1.3.${VERSION} sava_frontend_1.3

echo "building docker image: sava-backend:1.3".${VERSION}
createDockerFileFor sava_backend_1.2
createRunFileFor sava_backend_1.2
buildDockerImageFor sava-backend:1.3.${VERSION} sava_backend_1.2

echo "pushing docker images..."
docker push magneticio/sava:1.0.${VERSION}
docker push magneticio/sava:1.1.${VERSION}
docker push magneticio/sava-frontend:1.2.${VERSION}
docker push magneticio/sava-backend1:1.2.${VERSION}
docker push magneticio/sava-backend2:1.2.${VERSION}
docker push magneticio/sava-frontend:1.3.${VERSION}
docker push magneticio/sava-backend:1.3.${VERSION}
