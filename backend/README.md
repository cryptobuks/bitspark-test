# BiluminateBackend

**TODO: Add description**

# Development
## Exercise API

    # Generate user token (used by http-req)
    export T=`make token` 

    # Get wallet info
    ./bin/http-req wallet
    
    # Pay invoice
    ./bin/http-req wallet/transactions -X POST -d '{"invoice": "lntb500u...200"}'
    
    # List transactions
    ./bin/http-req wallet/transactions

