FROM centos:latest

RUN yum -y update
RUN yum -y install \
        curl \
        git \
        python \
        make \
        automake \
        gcc \
        gcc-c++ \
        kernel-devel \
        xorg-x11-server-Xvfb \
        git-core

RUN yum -y install epel-release yum-utils
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi
#RUN yum install -y redis

#ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
#ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
RUN yum install -y nodejs

RUN npm install -g yarn
RUN npm install -g pm2
RUN pm2 install pm2-logrotate
# RUN pm2 set pm2-logrotate:compress true

ENV LL_TAG=v2.8.2
RUN git clone https://github.com/LearningLocker/learninglocker.git /opt/learninglocker \
    && cd /opt/learninglocker \
    && git checkout $LL_TAG

WORKDIR /opt/learninglocker

COPY .env .env

RUN yarn install \
    && yarn build-all

RUN cp -r storage storage.template

RUN yarn migrate

#RUN node cli/dist/server createSiteAdmin "example@example.ru" "Example" "Qwerty123"

#ENV XAPI_SVC_TAG=v2.4.0
RUN git clone https://github.com/LearningLocker/xapi-service.git /opt/xapi-service \
    && cd /opt/xapi-service #\
    && git checkout $XAPI_SVC_TAG
COPY .env_xapi /opt/xapi-service/.env
WORKDIR /opt/xapi-service
RUN npm install
RUN npm run build

#RUN yum -y install nginx

#RUN mkdir /etc/nginx/sites-available
#RUN mkdir /etc/nginx/sites-enabled
#COPY learninglocker.conf /etc/nginx/sites-available/learninglocker.conf
#COPY nginx.conf /etc/nginx/nginx.conf
#RUN ln -s /etc/nginx/sites-available/learninglocker.conf /etc/nginx/sites-enabled/learninglocker.conf

#EXPOSE 80 8333 3000 8080 8081
EXPOSE 3000 8080 8081

#CMD ["env"]

