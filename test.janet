(import ./com.ahungry.crypt.aws4 :as aws4)

(def method "GET")
(def service "ec2")
(def host "ec2.amazonaws.com")
(def region "us-east-1")
(def endpoint "https://ec2.amazonaws.com")
(def request-parameters "Action=DescribeRegions&Version=2013-10-15")

(def request-opts
  (aws4/make {:request-parameters request-parameters
              :host host
              :amzdate "2020"
              :method method
              :datestamp "2020"
              :region region
              :service service
              :access-key "fake"
              :secret-key "fake"
             }))
(def fake-sig (get request-opts :signature))
(def fake-headers (get request-opts :headers))
(def fake-url (get request-opts :request-url))

#(pp request-opts)

# This matches the AWS sample python implementation output for this portion
(assert (= fake-sig "0be5bd45d1896db0d24b515d1c29faa6005f53c4f80dba6b7c4b6263e74e26b6"))
(assert
 (deep=
  fake-headers
  {:Host "ec2.amazonaws.com"
   :x-amz-date "2020"
   :Authorization "AWS4-HMAC-SHA256 Credential=fake/2020/us-east-1/ec2/aws4_request, SignedHeaders=host;x-amz-date, Signature=0be5bd45d1896db0d24b515d1c29faa6005f53c4f80dba6b7c4b6263e74e26b6"}))
(assert (= fake-url "?Action=DescribeRegions&Version=2013-10-15"))

{
 :headers
 {
  :Host "ec2.amazonaws.com"
  :x-amz-date "2020"
  :Authorization "AWS4-HMAC-SHA256 Credential=fake/2020/us-east-1/ec2/aws4_request, SignedHeaders=host;x-amz-date, Signature=0be5bd45d1896db0d24b515d1c29faa6005f53c4f80dba6b7c4b6263e74e26b6"
  }
 :request-url "?Action=DescribeRegions&Version=2013-10-15"
 :signature "0be5bd45d1896db0d24b515d1c29faa6005f53c4f80dba6b7c4b6263e74e26b6"
 }
