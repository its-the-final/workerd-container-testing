FROM node:16-bullseye

RUN apt-get update && apt-get -y install libc++-dev
RUN npm install workerd -g

COPY samples/helloworld .
CMD [ "workerd", "serve", "config.capnp"]
