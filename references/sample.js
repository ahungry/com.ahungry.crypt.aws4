// Rewrite of python sample into JS that I did.
const crypto = require('crypto')
const process = require('process')

const method = 'GET'
const service = 'ec2'
const host = 'ec2.amazonaws.com'
const region = 'us-east-1'
const endpoint = 'https://ec2.amazonaws.com'
const request_parameters = 'Action=DescribeRegions&Version=2013-10-15'

function sha256 (msg) {
  return crypto.createHash('sha256').update(msg).digest('hex')
}

function hmacDigest (hex, key = '', msg = '') {
  return crypto.createHmac('sha256', key)
    .update(msg)
    .digest(hex ? 'hex' : undefined)
}
const sign = hmacDigest.bind(null, false)
const signHex = hmacDigest.bind(null, true)

// console.log(sign('foo', 'bar'))
// console.log(signHex('foo', 'bar'))
// process.exit()

function getSigKey (key, dateStamp, regionName, serviceName) {
  const kDate = sign('AWS4' + key, dateStamp)
  const kRegion = sign(kDate, regionName)
  const kService = sign(kRegion, serviceName)
  const kSigning = sign(kService, 'aws4_request')
  return kSigning
}

const access_key = process.env.AWS_ACCESS_KEY_ID
const secret_key = process.env.AWS_SECRET_ACCESS_KEY
if (!access_key || !secret_key) {
  console.error('No access key')
  process.exit()
}

async function callApi () {
  const amzdate = (new Date()).toISOString().split('.')[0].replace(/[^0-9TZ]/g, '') + 'Z'
  const datestamp = amzdate.slice(0, 8)

  const canonical_uri = '/'
  const canonical_querystring = request_parameters
  const canonical_headers = 'host:' + host + '\n' + 'x-amz-date:' + amzdate + '\n'
  const signed_headers = 'host;x-amz-date'
  const payload_hash = sha256('')

  const canonical_request = method + '\n' + canonical_uri + '\n' + canonical_querystring + '\n' + canonical_headers + '\n' + signed_headers + '\n' + payload_hash
  const algorithm = 'AWS4-HMAC-SHA256'
  const credential_scope = datestamp + '/' + region + '/' + service + '/' + 'aws4_request'
  const sts_hash = sha256(canonical_request)
  const string_to_sign = algorithm + '\n' + amzdate + '\n' + credential_scope + '\n' + sts_hash
  const signing_key = getSigKey(secret_key, datestamp, region, service)
  const signature = signHex(signing_key, string_to_sign)

  // console.log({signing_key, string_to_sign, signature})
  // process.exit()

  const authorization_header = algorithm + ' ' + 'Credential=' + access_key + '/' + credential_scope + ', ' + 'SignedHeaders=' + signed_headers + ', ' + 'Signature=' + signature

  const headers = { 'x-amz-date': amzdate, 'Authorization': authorization_header, 'Host': host }
  const request_url = endpoint + '?' + canonical_querystring

  console.log('Request data: ', { headers, request_url })

  // process.exit()

  // Could be done natively, but I'm being lazy
  const axios = require('axios')
  const client = axios.create({
    // baseURL: request_url,
    headers,
  })

  const res = await client.get(request_url)
  console.log(res.data)
}

(async function main () {
  await callApi()
})()
