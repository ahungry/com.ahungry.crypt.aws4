#!/bin/bash

# Rewrite of python sample into bash that I did.

# ************* REQUEST VALUES *************
method='GET'
service='ec2'
host='ec2.amazonaws.com'
region='us-east-1'
endpoint='https://ec2.amazonaws.com'
request_parameters='Action=DescribeRegions&Version=2013-10-15'

# key, message
xsign () {
    echo -ne "$2" | openssl dgst -sha256 -hmac "$1" | awk '{print $2}'
}
sign () {
    echo -ne "$2" | openssl dgst -binary -sha256 -hmac "$1"
    #echo -ne "$2" | openssl dgst -sha256 -hmac "$1" | awk '{print $2}'
}

# echo $(sign '' '')
# exit

# key dateStamp regionName serviceName
getSigKey () {
    kDate=$(sign "AWS4$1" "$2")
    kRegion=$(sign "$kDate" "$3")
    kService=$(sign "$kRegion" "$4")
    kSigning=$(sign "$kService" "aws4_request")
    echo "$kSigning"
}
#amzdate=$(date -u +'%Y%m%dT%H%M%SZ')
#datestamp=$(date -u +'%Y%m%d')
amzdate='2020'
datestamp='2020'

uri=/
querystring=$(echo -ne $request_parameters)
headers=$(echo -ne "host:$host\nx-amz-date:$amzdate\n")
signed_headers="host;x-amz-date"
payload_hash=$(echo -ne "" | openssl dgst | awk '{print $2}')
request=$(echo -ne "$method\n$uri\n$querystring\n$headers\n\n$signed_headers\n$payload_hash")

algorithm='AWS4-HMAC-SHA256'
credential_scope=$(echo -ne "$datestamp/$region/$service/aws4_request")
string_to_sign=$(echo -ne "$algorithm\n$amzdate\n$credential_scope\n$(echo -ne "$request" | openssl dgst | awk '{ print $2 }' )")

signing_key=$(getSigKey "$AWS_SECRET_ACCESS_KEY" "$datestamp" "$region" "$service")
signature=$(xsign "$signing_key" "$string_to_sign")

echo $signing_key | hexdump -e '"\\\x" /1 "%02x"'
echo
echo
echo -ne "$string_to_sign"
echo
echo
echo $signature

auth_header=$(echo -ne "$algorithm Credential=$AWS_ACCESS_KEY_ID/$credential_scope, SignedHeaders=$signed_headers, Signature=$signature")

echo curl -D- -H"'Host: $host'" -H"'x-amz-date: $amzdate'" -H"'Authorization: $auth_header'" "'$endpoint?$querystring'"

curl -D- -H'Content-Type: application/json' -H"Host: $host" -H"x-amz-date: $amzdate" -H"Authorization: $auth_header" "$endpoint?$querystring" -XGET
