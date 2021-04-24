# com.ahungry.crypt.jwt

JWT Implementation using the Janetls library features (https://github.com/LeviSchuck/janetls)

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [com.ahungry.crypt.jwt](#comahungrycryptjwt)
- [Installation](#installation)
- [Usage](#usage)
    - [Encrypt a JWT:](#encrypt-a-jwt)
    - [Verify a JWT:](#verify-a-jwt)
    - [Get the payload/contents of a JWT:](#get-the-payloadcontents-of-a-jwt)
- [Notes](#notes)
- [Copyright](#copyright)
- [License](#license)

<!-- markdown-toc end -->

# Installation

Global:
```sh
jpm install https://github.com/ahungry/com.ahungry.crypt.jwt
```

Local (sample using deps as a local):
```sh
JANET_PATH=./deps jpm install https://github.com/ahungry/com.ahungry.crypt.jwt
```

Via your project.janet file:
```clojure
(declare-project
  :name "whatever"
  :dependencies [{:repo "https://github.com/ahungry/com.ahungry.crypt.jwt"}])
```

# Usage

## Encrypt a JWT:

```clojure
(import com.ahungry.crypt.jwt :as jwt)

(def secret-key "secure")
(def jwt-token (jwt/make secret-key {:hello "World"}))

(assert (= jwt-token "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJoZWxsbyI6IldvcmxkIn0.rEJgyCQrOtCskAyDS95esDxmXLqgdx8ltGPxlLoWL4E"))

```

## Verify a JWT:

```clojure
(import com.ahungry.crypt.jwt :as jwt)

(def secret-key "secure")
(def the-jwt-string "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJoZWxsbyI6IldvcmxkIn0.rEJgyCQrOtCskAyDS95esDxmXLqgdx8ltGPxlLoWL4E")

(jwt/verify-signature secret-key the-jwt-string) # Will return true or false
```

## Get the payload/contents of a JWT:

```clojure
(import com.ahungry.crypt.jwt :as jwt)

(def hardcoded-token "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJoZWxsbyI6IldvcmxkIn0.rEJgyCQrOtCskAyDS95esDxmXLqgdx8ltGPxlLoWL4E" )
(def payload-data (jwt/get-payload hardcoded-token))

(assert (deep= @{"hello" "World"} payload-data))
```

# Notes

At the moment this library does not do date based validation on
iat/exp, if you want to do that, you can take the values out of the
payload and do so.

Also - as it is by far the most commonly used, only HS256 is
supported, the "alg" value in the JWT header is disregarded.  If
non-HS256 JWT are used, signature verification should just fail.

# Copyright

Copyright (c) 2021 Matthew Carter <m@ahungry.com>

# License

MIT - see: LICENSE.md
