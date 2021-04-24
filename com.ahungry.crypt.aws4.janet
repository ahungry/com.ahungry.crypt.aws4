(import janetls)
(import json)

(defn sign [key msg]
  (janetls/md/hmac :sha256 key msg :raw))

(defn get-signature-key [key date-stamp region-name service-name]
  (-> (sign (string "AWS4" key) date-stamp)
      (sign region-name)
      (sign service-name)
      (sign "aws4_request")))

(defn make [opts]
  # Pull in user defined values
  (def access-key (get opts :access-key))
  (def secret-key (get opts :secret-key))
  (def request-parameters (get opts :request-parameters))
  (def host (get opts :host))
  (def amzdate (get opts :amzdate))
  (def method (get opts :method))
  (def datestamp (get opts :datestamp))
  (def region (get opts :region))
  (def service (get opts :service))

  # Set up values that don't change
  (def canonical-uri "/")
  (def canonical-querystring request-parameters)
  (def canonical-headers
    (string "host:" host "\n" "x-amz-date:" amzdate "\n"))
  (def signed-headers "host;x-amz-date")
  (def payload-hash (janetls/md/digest :sha256 ""))
  (def canonical-request
    (string method "\n" canonical-uri "\n" canonical-querystring "\n"
            canonical-headers "\n" signed-headers "\n" payload-hash))

  (pp canonical-request)

  (def algorithm "AWS4-HMAC-SHA256")
  (def credential-scope
    (string datestamp "/" region "/" service "/" "aws4_request"))
  (def string-to-sign
    (string algorithm "\n" amzdate "\n" credential-scope "\n"
            (janetls/md/digest :sha256 canonical-request)))
  (def signing-key (get-signature-key secret-key datestamp region service))
  (def signature (janetls/md/hmac :sha256 signing-key string-to-sign))

  {:sig signature})
