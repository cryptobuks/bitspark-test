
# Table of Contents

1.  [Wallet info](#orgfb36dff)
2.  [Invoice info](#org0469b82)
3.  [Process transaction (invoice)](#org7d394d4)
4.  [List transactions](#orgfa30844)
5.  [Send Bitcoin to email address](#org1d39c56)
    1.  [Create transaction (payer)](#org93864b3)
        1.  [With amount exceeding wallet balance](#org132eddc)
        2.  [With invalid amount](#org1785bcf)
    2.  [Claim transaction (payee)](#orgba77550)
        1.  [Success](#org85d2bc1)
        2.  [Failure: Expired](#org0240cd0)
    3.  [Payer sees that transaction has been claimed](#org49a812d)



<a id="orgfb36dff"></a>

# Wallet info

    _ = GET('/api/wallet')

    200 OK
    
    {
      "data": {
        "balance": {
          "msatoshi": 1000000000
        },
        "id": "a29513a1-6f40-42ec-8f1a-221fdb2008c4"
      }
    }


<a id="org0469b82"></a>

# Invoice info

    _ = GET('/api/wallet/invoice/lntb1500n1pd0c66dpp5p8rpzxck9u7umfl9u7dqratj8rlfthe29xl6ejhwt2exuaxfpftqdqvg9jxgg8zn2sscqzysyv8kgctq7haghaus4wqd262mxr9342mvp23gdsv6vmgkce9zgshjd0av06dq3xpe8cy6fucnj454smkqxuetyvu3h5jggx2w8ethlvcp6g3ldq')

    200 OK
    
    {
      "data": {
        "description": "Foobar #ldq",
        "dst_alias": "SomeNodeAlias #039",
        "msatoshi": 150000
      }
    }


<a id="org7d394d4"></a>

# Process transaction (invoice)

    _ = POST('/api/wallet/transactions', {"invoice": "lntb1500n1pd0c66dpp5p8rpzxck9u7umfl9u7dqratj8rlfthe29xl6ejhwt2exuaxfpftqdqvg9jxgg8zn2sscqzysyv8kgctq7haghaus4wqd262mxr9342mvp23gdsv6vmgkce9zgshjd0av06dq3xpe8cy6fucnj454smkqxuetyvu3h5jggx2w8ethlvcp6g3ldq"})

    201 Created
    
    {
      "data": {
        "description": "Foobar #ldq",
        "id": "d2f73e17-b242-48dc-86bc-5d0014db9cad",
        "inserted_at": "2018-08-30T17:58:40.303354",
        "invoice": "lntb1500n1pd0c66dpp5p8rpzxck9u7umfl9u7dqratj8rlfthe29xl6ejhwt2exuaxfpftqdqvg9jxgg8zn2sscqzysyv8kgctq7haghaus4wqd262mxr9342mvp23gdsv6vmgkce9zgshjd0av06dq3xpe8cy6fucnj454smkqxuetyvu3h5jggx2w8ethlvcp6g3ldq",
        "msatoshi": -150000,
        "processed_at": "2018-08-30T17:58:40.379003",
        "state": "approved"
      }
    }


<a id="orgfa30844"></a>

# List transactions

    _ = GET('/api/wallet/transactions')

    200 OK
    
    {
      "data": [
        {
          "description": "Foobar #ldq",
          "id": "d2f73e17-b242-48dc-86bc-5d0014db9cad",
          "inserted_at": "2018-08-30T17:58:40.303354",
          "invoice": "lntb1500n1pd0c66dpp5p8rpzxck9u7umfl9u7dqratj8rlfthe29xl6ejhwt2exuaxfpftqdqvg9jxgg8zn2sscqzysyv8kgctq7haghaus4wqd262mxr9342mvp23gdsv6vmgkce9zgshjd0av06dq3xpe8cy6fucnj454smkqxuetyvu3h5jggx2w8ethlvcp6g3ldq",
          "msatoshi": -150000,
          "processed_at": "2018-08-30T17:58:40.379003",
          "state": "approved"
        },
        {
          "description": "Funding transaction",
          "id": "88bbd6f8-ec98-4ca7-8995-b07f5f9f9892",
          "inserted_at": "2018-08-30T17:58:39.986193",
          "msatoshi": 1000000000,
          "processed_at": null,
          "state": "approved"
        }
      ]
    }


<a id="org1d39c56"></a>

# Send Bitcoin to email address


<a id="org93864b3"></a>

## Create transaction (payer)

    email_src_trn = POST('/api/wallet/transactions', {
        "to_email": "to@example.com",
        "msatoshi": 1000,
        "description": "Free BTC",    # optional - visible to both payee & payer
        "expires_after": 900          # in seconds
    })['data']

    201 Created
    
    {
      "data": {
        "claim_expires_at": "2018-08-30T18:11:50.486755",
        "description": "Free BTC",
        "id": "932deaaf-5969-4654-a8da-f9d43791721b",
        "inserted_at": "2018-08-30T17:56:50.486867",
        "msatoshi": -1000,
        "processed_at": null,
        "state": "initial",
        "to_email": "to@example.com"
      }
    }


<a id="org132eddc"></a>

### With amount exceeding wallet balance

It returns declined transaction.

    wallet = silent(lambda: GET('/api/wallet'))
    _ = POST('/api/wallet/transactions', {
        "to_email": "a@b.cz",
        "msatoshi": wallet['data']['balance']['msatoshi'] + 1,
        "description": "Free BTC",
        "expires_after": 900
    })

    201 Created
    
    {
      "data": {
        "claim_expires_at": "2018-08-30T18:13:40.609864",
        "description": "Free BTC",
        "id": "e688bcf9-134c-4beb-99df-5488391bb05e",
        "inserted_at": "2018-08-30T17:58:40.609941",
        "msatoshi": -999850001,
        "processed_at": "2018-08-30T17:58:40.615997",
        "state": "declined",
        "to_email": "a@b.cz"
      }
    }


<a id="org1785bcf"></a>

### With invalid amount

    _ = POST('/api/wallet/transactions', {
        "to_email": "a@b.cz",
        "msatoshi": -1000, # <- can't send negative amount
        "description": "Free BTC",
        "expires_after": 900
    })

    400 Bad Request
    
    {
      "error": {
        "detail": "Non-positive amount given"
      }
    }


<a id="orgba77550"></a>

## Claim transaction (payee)


<a id="org85d2bc1"></a>

### Success

    _ = POST('/api/wallet/transactions', {"claim_token": "ebd5eef4-61c3-4fd9-87de-6ad7d719f131"})

    201 Created
    
    {
      "data": {
        "description": "Free BTC",
        "id": "093a5c23-e637-4720-a69c-b1d43cabe83c",
        "inserted_at": "2018-08-30T17:57:33.676110",
        "msatoshi": 1000,
        "processed_at": "2018-08-30T17:57:33.676014",
        "state": "approved"
      }
    }

When called multiple times it returns same transaction (i.e. it's idempotent).

    _ = POST('/api/wallet/transactions', {"claim_token": "ebd5eef4-61c3-4fd9-87de-6ad7d719f131"})
    _ = POST('/api/wallet/transactions', {"claim_token": "ebd5eef4-61c3-4fd9-87de-6ad7d719f131"})

    201 Created
    
    {
      "data": {
        "description": "Free BTC",
        "id": "093a5c23-e637-4720-a69c-b1d43cabe83c",
        "inserted_at": "2018-08-30T17:57:33.676110",
        "msatoshi": 1000,
        "processed_at": "2018-08-30T17:57:33.676014",
        "state": "approved"
      }
    }
    201 Created
    
    {
      "data": {
        "description": "Free BTC",
        "id": "093a5c23-e637-4720-a69c-b1d43cabe83c",
        "inserted_at": "2018-08-30T17:57:33.676110",
        "msatoshi": 1000,
        "processed_at": "2018-08-30T17:57:33.676014",
        "state": "approved"
      }
    }


<a id="org0240cd0"></a>

### Failure: Expired

    email_expired_src_trn = silent(lambda: POST('/api/wallet/transactions', {
        "to_email": "to@example.com",
        "msatoshi": 1000,
        "description": "Free BTC",
        "expires_after": 0          # already expired
    }))['data']

    _ = POST('/api/wallet/transactions', {"claim_token": "ae6f77c6-ce90-4f22-9f3d-c239a05634e8"})

    400 Bad Request
    
    {
      "error": {
        "detail": "Non-claimable transaction"
      }
    }


<a id="org49a812d"></a>

## Payer sees that transaction has been claimed

Status of transaction is `approved` and `processed_at` field marks time of claim event.

    _ = GET('/api/wallet/transactions/' + email_src_trn['id'])

    200 OK
    
    {
      "data": {
        "claim_expires_at": "2018-08-30T18:11:50.486755",
        "description": "Free BTC",
        "id": "932deaaf-5969-4654-a8da-f9d43791721b",
        "inserted_at": "2018-08-30T17:56:50.486867",
        "msatoshi": -1000,
        "processed_at": "2018-08-30T17:57:33.678304",
        "state": "approved",
        "to_email": "to@example.com"
      }
    }

