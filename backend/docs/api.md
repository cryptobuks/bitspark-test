
# Table of Contents

1.  [Wallet info](#org0450e08)
2.  [Invoice info](#org9c05536)
3.  [Process transaction (invoice)](#orgd3cfddc)
4.  [List transactions](#org8011d26)
5.  [Send Bitcoin to email address](#orge0cfe99)
    1.  [Create transaction (payer)](#orgbf6e899)
        1.  [With amount exceeding wallet balance](#org9f53b65)
        2.  [With invalid amount](#orgf421fd6)
    2.  [Claim transaction (payee)](#org12b5a70)
        1.  [Success](#org235e9b8)
        2.  [Failure: Expired](#org6bb1f68)
    3.  [Payer sees that transaction has been claimed](#org937a7b8)



<a id="org0450e08"></a>

# Wallet info

    _ = GET('/api/wallet')

    200 OK
    
    {
      "data": {
        "balance": {
          "msatoshi": 1000000000
        },
        "id": "81acc3b6-3c76-4446-917c-8d8849fbe08e"
      }
    }


<a id="org9c05536"></a>

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


<a id="orgd3cfddc"></a>

# Process transaction (invoice)

    _ = POST('/api/wallet/transactions', {"invoice": "lntb1500n1pd0c66dpp5p8rpzxck9u7umfl9u7dqratj8rlfthe29xl6ejhwt2exuaxfpftqdqvg9jxgg8zn2sscqzysyv8kgctq7haghaus4wqd262mxr9342mvp23gdsv6vmgkce9zgshjd0av06dq3xpe8cy6fucnj454smkqxuetyvu3h5jggx2w8ethlvcp6g3ldq"})

    201 Created
    
    {
      "data": {
        "description": "Foobar #ldq",
        "id": "aea0d56a-3fba-48e6-bf4b-873fda1b28bd",
        "inserted_at": "2018-08-28T22:05:48.508409",
        "invoice": "lntb1500n1pd0c66dpp5p8rpzxck9u7umfl9u7dqratj8rlfthe29xl6ejhwt2exuaxfpftqdqvg9jxgg8zn2sscqzysyv8kgctq7haghaus4wqd262mxr9342mvp23gdsv6vmgkce9zgshjd0av06dq3xpe8cy6fucnj454smkqxuetyvu3h5jggx2w8ethlvcp6g3ldq",
        "msatoshi": -150000,
        "processed_at": "2018-08-28T22:05:48.548452",
        "state": "approved"
      }
    }


<a id="org8011d26"></a>

# List transactions

    _ = GET('/api/wallet/transactions')

    200 OK
    
    {
      "data": [
        {
          "description": "Foobar #ldq",
          "id": "aea0d56a-3fba-48e6-bf4b-873fda1b28bd",
          "inserted_at": "2018-08-28T22:05:48.508409",
          "invoice": "lntb1500n1pd0c66dpp5p8rpzxck9u7umfl9u7dqratj8rlfthe29xl6ejhwt2exuaxfpftqdqvg9jxgg8zn2sscqzysyv8kgctq7haghaus4wqd262mxr9342mvp23gdsv6vmgkce9zgshjd0av06dq3xpe8cy6fucnj454smkqxuetyvu3h5jggx2w8ethlvcp6g3ldq",
          "msatoshi": -150000,
          "processed_at": "2018-08-28T22:05:48.548452",
          "state": "approved"
        },
        {
          "description": "Funding transaction",
          "id": "d113f1bb-eb83-4a34-baa1-540039fc9fa0",
          "inserted_at": "2018-08-28T22:05:48.261450",
          "msatoshi": 1000000000,
          "processed_at": null,
          "state": "approved"
        }
      ]
    }


<a id="orge0cfe99"></a>

# Send Bitcoin to email address


<a id="orgbf6e899"></a>

## Create transaction (payer)

    email_src_trn = POST('/api/wallet/transactions', {
        "to_email": "a@b.cz",
        "msatoshi": 1000,
        "description": "Free BTC",    # optional - visible to both payee & payer
        "expires_after": 900          # in seconds
    })['data']

    201 Created
    
    {
      "data": {
        "claim_expires_at": "2018-08-28T22:07:16.771441",
        "description": "Free BTC",
        "id": "4d8c598a-474a-40f6-8142-58def5269c0c",
        "inserted_at": "2018-08-28T21:52:16.771519",
        "msatoshi": -1000,
        "processed_at": null,
        "state": "initial"
      }
    }


<a id="org9f53b65"></a>

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
        "claim_expires_at": "2018-08-28T22:20:48.728818",
        "description": "Free BTC",
        "id": "8ccbefaa-ece8-4d9b-b65b-2531bf9f14b9",
        "inserted_at": "2018-08-28T22:05:48.728927",
        "msatoshi": -999850001,
        "processed_at": "2018-08-28T22:05:48.734953",
        "state": "declined"
      }
    }


<a id="orgf421fd6"></a>

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


<a id="org12b5a70"></a>

## Claim transaction (payee)


<a id="org235e9b8"></a>

### Success

    _ = POST('/api/wallet/transactions', {"claim_token": "4470892b-acef-4a9f-8b02-861ceadd6c39"})

    201 Created
    
    {
      "data": {
        "description": "Free BTC",
        "id": "ab619809-5a0a-48b5-bf01-5ac53c4f5b2c",
        "inserted_at": "2018-08-28T21:52:48.713919",
        "msatoshi": 1000,
        "processed_at": "2018-08-28T21:52:48.713790",
        "state": "approved"
      }
    }

When called multiple times it returns same transaction (i.e. it's idempotent).

    _ = POST('/api/wallet/transactions', {"claim_token": "4470892b-acef-4a9f-8b02-861ceadd6c39"})
    _ = POST('/api/wallet/transactions', {"claim_token": "4470892b-acef-4a9f-8b02-861ceadd6c39"})

    201 Created
    
    {
      "data": {
        "description": "Free BTC",
        "id": "ab619809-5a0a-48b5-bf01-5ac53c4f5b2c",
        "inserted_at": "2018-08-28T21:52:48.713919",
        "msatoshi": 1000,
        "processed_at": "2018-08-28T21:52:48.713790",
        "state": "approved"
      }
    }
    201 Created
    
    {
      "data": {
        "description": "Free BTC",
        "id": "ab619809-5a0a-48b5-bf01-5ac53c4f5b2c",
        "inserted_at": "2018-08-28T21:52:48.713919",
        "msatoshi": 1000,
        "processed_at": "2018-08-28T21:52:48.713790",
        "state": "approved"
      }
    }


<a id="org6bb1f68"></a>

### Failure: Expired

    email_expired_src_trn = silent(lambda: POST('/api/wallet/transactions', {
        "to_email": "a@b.cz",
        "msatoshi": 1000,
        "description": "Free BTC",
        "expires_after": 0          # already expired
    }))['data']

    _ = POST('/api/wallet/transactions', {"claim_token": "84507a20-852c-49c5-a2cb-1740766bdbb2"})

    400 Bad Request
    
    {
      "error": {
        "detail": "Non-claimable transaction"
      }
    }


<a id="org937a7b8"></a>

## Payer sees that transaction has been claimed

Status of transaction is `approved` and `processed_at` field marks time of claim event.

    _ = GET('/api/wallet/transactions/' + email_src_trn['id'])

    200 OK
    
    {
      "data": {
        "claim_expires_at": "2018-08-28T22:07:16.771441",
        "description": "Free BTC",
        "id": "4d8c598a-474a-40f6-8142-58def5269c0c",
        "inserted_at": "2018-08-28T21:52:16.771519",
        "msatoshi": -1000,
        "processed_at": "2018-08-28T21:52:48.716889",
        "state": "approved"
      }
    }

