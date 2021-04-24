# com.ahungry.crypt.aws4

AWS v4 Signature implementation using the Janetls library features (https://github.com/LeviSchuck/janetls)

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [com.ahungry.crypt.aws4](#comahungrycryptaws4)
- [Installation](#installation)
- [Usage](#usage)
    - [Create the request-opts](#create-the-request-opts)
- [Copyright](#copyright)
- [License](#license)

<!-- markdown-toc end -->

# Installation

Global:
```sh
jpm install https://github.com/ahungry/com.ahungry.crypt.aws4
```

Local (sample using deps as a local):
```sh
JANET_PATH=./deps jpm install https://github.com/ahungry/com.ahungry.crypt.aws4
```

Via your project.janet file:
```clojure
(declare-project
  :name "whatever"
  :dependencies [{:repo "https://github.com/ahungry/com.ahungry.crypt.aws4"}])
```

# Usage

## Create the request-opts

```clojure
(import com.ahungry.crypt.aws4 :as aws4)

(def request-opts
  (aws4/make {:request-parameters "Action=DescribeRegions&Version=2013-10-15"
              :host "ec2.amazonaws.com"

              # This should be dynamic/the current datetime
              :amzdate "20210424T182850Z"
              :method "GET"

              # This should be dynamic/the current date
              :datestamp "20210424"
              :region "us-east-1"
              :service "ec2"

              # An AWS SDK may want to source from AWS_ACCESS_KEY_ID
              :access-key "fake"

              # An AWS SDK may want to source from AWS_SECRET_ACCESS_KEY
              :secret-key "fake"
             }))

```

will produce the output in request-opts as such:

```clojure
{
 :headers
 {
  :Host "ec2.amazonaws.com"
  :x-amz-date "20210424T182850Z"
  :Authorization "AWS4-HMAC-SHA256 Credential=fake/2020/us-east-1/ec2/aws4_request, SignedHeaders=host;x-amz-date, Signature=0be5bd45d1896db0d24b515d1c29faa6005f53c4f80dba6b7c4b6263e74e26b6"
  }
 :request-url "?Action=DescribeRegions&Version=2013-10-15"
 :signature "0be5bd45d1896db0d24b515d1c29faa6005f53c4f80dba6b7c4b6263e74e26b6"
 }
```

which could then be passed into an HTTPS client and used to interact
with AWS.

# Copyright

Copyright (c) 2021 Matthew Carter <m@ahungry.com>

# License

MIT - see: LICENSE.md
