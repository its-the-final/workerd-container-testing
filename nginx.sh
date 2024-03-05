#nginx -t

(
  sleep 45
timeout 5 curl -s -6 https://www.google.com -o /dev/null && ( 
     sed 's/ipv6=off//g' -i /etc/nginx/nginx.conf
     sed 's~private-address: ::/0~#private-address: ::/0~g' /etc/unbound.conf
    unbound-control -c /etc/unbound.conf reload
     nginx -s reload
)
) &


while (true);do nginx -g "daemon off;" |grep -v /healthcheck ;sleep 3;done
#nginx -g "daemon off;" |grep -v /healthcheck 