#!/usr/bin/env bash

RECORD_ID=""
ZONE_ID=""
AUTH_API_TOKEN=""
AUTH_EMAIL=""
DOMAIN_NAME=""
RECORD_TYPE="A"
PROXIED="true"
PRIMARY_IPV4=""
SECONDARY_IPV4=""
CURRENT_IPV4="${PRIMARY_IPV4}"
MAX_DISCONNECT_PER_MIN=10

function doFailover() {
	echo "[$(date +"%Y-%m-%d %H:%M:%S")] FATAL: Failover to ${SECONDARY_IPV4}"
	CURRENT_IPV4=${SECONDARY_IPV4}
	curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${RECORD_ID}" -H "X-Auth-Email: ${AUTH_EMAIL}" -H "X-Auth-Key: ${AUTH_API_TOKEN}" -H "Content-Type: application/json" --data '{"type":"'${RECORD_TYPE}'", "name":"'${DOMAIN_NAME}'", "content":"'${SECONDARY_IPV4}'", "ttl":3600, "proxied":'${PROXIED}'}'
}

COUNT=1
while true
do
	PING_CHECK=$(ping -c 1 -w 3 ${CURRENT_IPV4} &> /dev/null && echo ok || echo disconnect)
	if [[ ${PING_CHECK} == 'ok' ]]; then
		COUNT=1
	else
		echo "[$(date +"%Y-%m-%d %H:%M:%S")] WARN: ${CURRENT_IPV4} probably down (ping failed ${COUNT}/${MAX_DISCONNECT_PER_MIN})"
		((COUNT++))
	fi
	if [[ ${COUNT} -ge ${MAX_DISCONNECT_PER_MIN} ]]; then
		doFailover
		exit
	fi
done
