Get DNS record identifier (for $RECORD_ID variable):

```
export ZONE_ID="924de24f9c346a3ed4ca0f02e5b91faf"
export DOMAIN_NAME="example.com"
export RECORD_TYPE="A"
export CURRENT_IPV4="192.168.123.34"
export AUTH_EMAIL="your@mail.com"
export AUTH_API_TOKEN="24021b4cf377de1cef059f04f454c3a7f7381"

curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?name=${DOMAIN_NAME}&type=${RECORD_TYPE}&content=${CURRENT_IPV4}&match=all" -H "X-Auth-Email: ${AUTH_EMAIL}" -H "X-Auth-Key: ${AUTH_API_TOKEN}" -H "Content-Type: application/json"
```
