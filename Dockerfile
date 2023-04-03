# Utiliser l'image MongoDB officielle comme point de départ
FROM mongo

ARG MONGO_PWD

ARG MONGO_USERNAME

RUN echo "pwd-> $MONGO_PWD"
RUN echo "username-> $MONGO_USERNAME"

RUN apt-get update && \
    apt-get install -y sudo wget

# Import MongoDB public GPG key and create MongoDB list file
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/debian bullseye/mongodb-org/5.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list

# Install MongoDB
RUN sudo apt-get update && sudo apt-get install -y mongodb-org


ENV PATH="${PATH}:/usr/bin"

# SSL
RUN mkdir -p /etc/mongodb/ssl
COPY tls/tls-mongodb.crt /etc/mongodb/ssl/
COPY tls/tls-mongodb.key /etc/mongodb/ssl/

# Créer un utilisateur administrateur
ENV MONGO_INITDB_ROOT_USERNAME=$MONGO_USERNAME
ENV MONGO_INITDB_ROOT_PASSWORD=$MONGO_PWD

ENV MONGO_INITDB_DATABASE=testdb1
ENV MONGO_INITDB_DATA_DIR=/data/db
RUN mkdir -p ${MONGO_INITDB_DATA_DIR}/testdb1
RUN mongod --dbpath ${MONGO_INITDB_DATA_DIR}/testdb1 &
#RUN mongo testdb1 --eval "db.createCollection('testDB1')"

# Copier le fichier de configuration
COPY mongod.conf /etc/mongod.conf

COPY init.js /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init.js

# Exposer le port MongoDB
EXPOSE 27017

# Démarrer MongoDB en mode sécurisé
CMD ["mongod", "--config", "/etc/mongod.conf", "--auth"]

