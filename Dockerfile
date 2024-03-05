#FROM node:16-bullseye
#FROM node:16-alpine
FROM node:21-bullseye-slim

COPY src/package.json .
## RUN apk add gcompat
#RUN ash -c "wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub;wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-2.35-r1.apk;apk add glibc-2.35-r1.apk"

#RUN ash -c "apk add bash unbound nginx curl grep procps file  lsof "
#RUN bash -c "rm /etc/nginx/nginx.conf|| true ;ln -s /etc/nginx.conf /etc/nginx/nginx.conf; npm install miniflare; ( npm install ;npm install workerd redis crypto wrangler) &  (cd node_modules/miniflare;npm install workerd) & wait "


RUN apt-get update && apt-get -y install bash && bash -c "(DEBIAN_FRONTEND=noninteractive apt-get install -qy tini libc++1 unbound   grep procps file lsof   curl nginx-full libc++-dev && apt-get -y clean all ) & (npm install wrangler redis crypto && npm install ) & wait "
RUN bash -c "rm /etc/nginx/nginx.conf|| true ;ln -s /etc/nginx.conf /etc/nginx/nginx.conf; adduser --system --no-create-home --shell /bin/false --group --disabled-login nginx"
ENTRYPOINT [ "/bin/bash","-c","pwd;bash init.sh" ]
#RUN npm install wranglerjs-compat-webpack-plugin webpack webpack-cli workerd -g
#
##COPY samples/helloworld .
#COPY src/package.json .
#
#RUN npm install
##RUN mkdir src
#
#COPY ctx.js config.capnp .
#COPY src/* .
##RUN bash -c 'ln -s $(pwd)/webpack.config.js  /webpack.config.js '
#
##RUN  webpack-cli --config ./webpack.config.js 
#RUN npm run build
#CMD [ "workerd", "serve", "config.capnp"]
#FROM node:lts-alpine
#RUN apk add bash grep procps file lsof 
#RUN npm install -g miniflare wrangler webpack webpack-cli workerd 

#RUN npm install && npm install wrangler && bash -c "cd /node_modules/miniflare;npm install workerd"
#RUN bash -c "(npm install && npm install wrangler ) & cd node_modules/miniflare;npm install workerd & wait"
#RUN bash -c "(npm install && npm install wrangler ) "

#npm install  miniflare workerd

#RUN ls  /node_modules/@cloudflare/workerd-linux-64/bin/workerd -lh1
#RUN ( test -e /node_modules/miniflare/node_modules/ || mkdir /node_modules/miniflare/node_modules/ ) && ln -s /node_modules/@cloudflare /node_modules/miniflare/node_modules/
#RUN ln -s /node_modules/@cloudflare/workerd-linux-64/bin/workerd /node_modules/miniflare/node_modules/@cloudflare/workerd-linux-64/bin

#RUN file /node_modules/miniflare/node_modules/@cloudflare/workerd-linux-64/bin/workerd
#RUN ls /node_modules/miniflare/node_modules/@cloudflare/workerd-linux-64/bin/workerd


#COPY miniflare.js .
#RUN mkdir src
COPY nginx.sh / 
COPY nginx.conf unbound.conf /etc/


COPY src/ ./
#COPY wrangler.toml .
#CMD [ "npx", "miniflare@2","-c","wrangler.toml"]
#CMD ["/bin/bash","-c",'cd /src;echo asd']
COPY init.sh /
#RUN npm install ioredis @miniflare/kv @miniflare/storage-redis handlebars timers 
CMD ["/bin/bash"]
