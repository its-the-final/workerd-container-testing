#!/bin/bash

[[ -z "$PORT" ]] && export PORT=8787
[[ -z "$PORT" ]] && PORT=8787
[[ -z "$ALLOWED_ORIGIN" ]] && ALLOWED_ORIGIN="*"
INTPORT=65533
(sleep 0.1 ;echo n;echo n ;echo n)|npx wrangler dev  --test-scheduled --log-level=error --port=$INTPORT &

echo "${UPSTREAM_PROTO}"|grep -q ^$ && UPSTREAM_PROTO="https"

[[ -z "${PROXY_CACHE_VALID}" ]] || PROXY_CACHE_VALID="proxy_cache_valid ${PROXY_CACHE_VALID}"
[[ -z "${PROXY_CACHE_VALID}" ]] && PROXY_CACHE_VALID="proxy_cache_valid 3h"


#(mkdir -p  /var/run/redis/ ;chmod ugo+rwx  /var/run/redis/ ) &
#while (true);do 
#  redis-server /etc/redis.conf ;sleep 3
#done &
sed -i "s|80 default_server|"$PORT" default_server|;s|listen 80|listen "$PORT"|;s|\$MAX_SIZE|"${MAX_SIZE:-10g}"| ;s|MYUPSTREAM|127.0.0.1|g ;s|MYPORT|"${INTPORT}"|g ;s|\$GZIP|"${GZIP:-on}"| ;s|\ALLOWED_ORIGIN|"${ALLOWED_ORIGIN}"| ;s|\$PROXY_READ_TIMEOUT|"${PROXY_READ_TIMEOUT:-120s}"| ;s|\$MAX_INACTIVE|"${MAX_INACTIVE:-60m}"|;s|UPSTREAM_PROTO|"${UPSTREAM_PROTO}"|;"'s~PROXY_CACHE_VALID~'"${PROXY_CACHE_VALID}"';~g' /etc/nginx/nginx.conf


#echo "PRCV $PROXY_CACHE_VALID"
#cat /etc/unbound.conf |nl
nginx -t || nginx -T
#nginx -t || exit 1
unbound -dd -c /etc/unbound.conf &
#sleep 0.3


cd /
#npx miniflare@2 -c wrangler.toml
#ls -lh1 
echo "READY @ $PORT" &
bash /nginx.sh
nginx -T|grep listen