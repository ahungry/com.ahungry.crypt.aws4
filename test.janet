(import ./com.ahungry.crypt.jwt :as jwt)

# Reflection test
(assert (= true (jwt/verify-signature "secure" (jwt/make "secure" {:hello "World"}))))
(def hardcoded-token "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJoZWxsbyI6IldvcmxkIn0.rEJgyCQrOtCskAyDS95esDxmXLqgdx8ltGPxlLoWL4E" )
(assert (= hardcoded-token (jwt/make "secure" {:hello "World"})))

(def payload-data (jwt/get-payload hardcoded-token))
(assert (deep= @{"hello" "World"} payload-data))

# From nodejs jsonwebtoken, making defaults (HMAC SHA256)
# var token = jwt.sign({ foo: 'bar' }, 'secure', { noTimestamp: true });
(def token-from-node-jsonwebtoken "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmb28iOiJiYXIifQ.l_rKgcZdYix2Qd8zBNeRgFaDHOkmYrHxgW6v3EyH98M")

(assert (= true (jwt/verify-signature "secure" token-from-node-jsonwebtoken)))
(assert (= false (jwt/verify-signature "woops wrong key" token-from-node-jsonwebtoken)))


# Second one created from node, this time with a built in timestamp
(def token-from-node-jsonwebtoken2 "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmb28iOiJiYXIiLCJpYXQiOjE2MTkyMjUwNzB9.3sOw88FlvBkXoqQLnEUEzNbo0Jhs298eR3oQAHWg93o")

(assert (= true (jwt/verify-signature "secure" token-from-node-jsonwebtoken2)))
