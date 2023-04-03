docker container rm -f $(docker ps -a | grep 'mongo' | awk '{print $NF}')

docker build --build-arg MONGO_PWD=$MONGO_PWD --build-arg MONGO_USERNAME=$MONGO_USERNAME -t mongodb-srv1 .
