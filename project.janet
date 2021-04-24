(declare-project
 :name "com.ahungry.crypt.aws4"
 :description "AWS4 Signing Implementation using Janetls"
 :author "Matthew Carter"
 :license "MIT"
 :dependencies
 [
  "json"
  {
   # Use the official, not the fork, as they may conflict with each other
   # if users were to have both installed.
   #:repo "https://github.com/ahungry/janetls.git"
   :repo "https://github.com/LeviSchuck/janetls"
   }
  ]
 :url "https://github.com/ahungry/com.ahungry.crypt.aws4/"
 :repo "git+https://github.com/ahungry/com.ahungry.crypt.aws4.git")

(declare-source
  :name "com.ahungry.crypt.aws4"
  :source ["com.ahungry.crypt.aws4.janet"]
  )
