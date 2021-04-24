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
(def fake-sig (get request-opts :sig))
(def fake-headers (get request-opts :headers))
(def fake-url (get request-opts :url))

# This matches the AWS sample python implementation output for this portion
(assert (= fake-sig "0be5bd45d1896db0d24b515d1c29faa6005f53c4f80dba6b7c4b6263e74e26b6"))
