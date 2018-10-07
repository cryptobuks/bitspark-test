
# Table of Contents

1.  [Wallet info](#orgb705e53)
2.  [Invoice info](#orgd804c7c)
3.  [Process lightning transaction](#org6b1b0ed)
4.  [Send Bitcoin to email address](#org595594f)
    1.  [Create transaction (payer)](#orga663150)
        1.  [With amount exceeding wallet balance](#org0edfdca)
    2.  [Claim transaction (payee)](#orga8c4667)
        1.  [Success](#org2780384)
        2.  [Failure: Expired](#orge7f9781)
    3.  [Payer sees that transaction has been claimed](#org33ada83)
5.  [Other](#orge951b9f)
    1.  [Currency Rates](#org3e89bab)



<a id="orgb705e53"></a>

# Wallet info

    _ = gql("""
      query {
        currentUserWallet {
          id
          balance { msatoshi }
          transactions {
            id
            msatoshi
            description
            state
          }
         }
      }
    """)

    200 OK
    
    {
      "data": {
        "currentUserWallet": {
          "balance": {
            "msatoshi": 1000000000
          },
          "id": "ddb4ce40-a47b-4eba-861a-64c7e0ee3e5a",
          "transactions": [
            {
              "description": "Funding transaction",
              "id": "fa2a5122-5630-4e98-978e-9fc5f3bdbab5",
              "msatoshi": 1000000000,
              "state": "APPROVED"
            }
          ]
        }
      }
    }


<a id="orgd804c7c"></a>

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


<a id="org6b1b0ed"></a>

# Process lightning transaction

    _ = gql(
        """
            mutation processLightningTransaction($input: ProcessLightningTransactionInput!) {
              processLightningTransaction(input: $input) {
                transaction {
                  id
                  msatoshi
                  state
                }
              }
            }
        """,
        input={"invoice": "lntb1500n1pd0c66dpp5p8rpzxck9u7umfl9u7dqratj8rlfthe29xl6ejhwt2exuaxfpftqdqvg9jxgg8zn2sscqzysyv8kgctq7haghaus4wqd262mxr9342mvp23gdsv6vmgkce9zgshjd0av06dq3xpe8cy6fucnj454smkqxuetyvu3h5jggx2w8ethlvcp6g3ldq"})

    200 OK
    
    {
      "data": {
        "processLightningTransaction": {
          "transaction": {
            "id": "00c07c52-2d12-4768-89ca-1e7c0dd11f64",
            "msatoshi": -150000,
            "state": "APPROVED"
          }
        }
      }
    }


<a id="org595594f"></a>

# Send Bitcoin to email address


<a id="orga663150"></a>

## Create transaction (payer)

    mutation processEmailTransaction($input: ProcessEmailTransactionInput!) {
      processEmailTransaction(input: $input) {
        transaction {
          id
          state
          msatoshi
          description
        }
      }
    }

    email_src_trn = gql(
        load('processEmailTransaction'),
        input={
            "toEmail": "to@example.com",
            "msatoshi": 1000,
            "description": "Free BTC",
            "expiresAfter": 900
        })

    200 OK
    
    {
      "data": {
        "processEmailTransaction": {
          "transaction": {
            "description": "Free BTC",
            "id": "28e582ca-f870-4233-a234-0cd4dc13b462",
            "msatoshi": -1000,
            "state": "INITIAL"
          }
        }
      }
    }


<a id="org0edfdca"></a>

### With amount exceeding wallet balance

It returns declined transaction.

    balance = silent(lambda: query('{ currentUserWallet { balance { msatoshi } } }'))['data']['currentUserWallet']['balance']
    _ = gql(
        load('processEmailTransaction'),
        input={
          "toEmail": "to@example.com",
          "msatoshi": balance['msatoshi'] + 1,
          "description": "Free BTC",
          "expiresAfter": 900
        })

    200 OK
    
    {
      "data": {
        "processEmailTransaction": {
          "transaction": {
            "description": "Free BTC",
            "id": "5cef53d9-1fb8-40d6-bc43-3d82daa27b85",
            "msatoshi": -999849001,
            "state": "DECLINED"
          }
        }
      }
    }


<a id="orga8c4667"></a>

## Claim transaction (payee)


<a id="org2780384"></a>

### Success

    mutation claimTransaction($input: ClaimTransactionInput!) {
      claimTransaction(input: $input) {
        transaction {
          id
          state
          msatoshi
          description
        }
      }
    }

When called multiple times it returns same transaction (i.e. it's idempotent).

    _ = gql(
        load('claimTransaction'),
        input={
          "claimToken": "cb4db7e1-c1c9-4f42-82ab-ab4b829d0389"
        })

    200 OK
    
    {
      "data": {
        "claimTransaction": {
          "transaction": {
            "description": "Free BTC",
            "id": "e4a65fd0-c786-4aac-b70b-e87b6c519203",
            "msatoshi": 1000,
            "state": "APPROVED"
          }
        }
      }
    }


<a id="orge7f9781"></a>

### Failure: Expired

    _ = silent(lambda: gql(
        load('processEmailTransaction'),
        input={
          "toEmail": "to@example.com",
          "msatoshi": 1000,
          "description": "Free BTC",
          "expiresAfter": 0          # already expired
        }))

    _ = gql(
        load('claimTransaction'),
        input={
          "claimToken": "7b9af26f-4b70-4807-8f9e-b64ad0cc843c"
        })

    200 OK
    
    {
      "data": {
        "claimTransaction": null
      },
      "errors": [
        {
          "locations": [
            {
              "column": 0,
              "line": 2
            }
          ],
          "message": "Non-claimable transaction",
          "path": [
            "claimTransaction"
          ]
        }
      ]
    }


<a id="org33ada83"></a>

## Payer sees that transaction has been claimed

Status of transaction is `approved` and `processed_at` field marks time of claim event.

    _ = GET('/api/wallet/transactions/' + email_src_trn['data']['processEmailTransaction']['transaction']['id'])

    200 OK
    
    {
      "data": {
        "claim_expires_at": "2018-10-07T14:16:39.430881",
        "description": "Free BTC",
        "id": "28e582ca-f870-4233-a234-0cd4dc13b462",
        "inserted_at": "2018-10-07T14:01:39.430991",
        "msatoshi": -1000,
        "processed_at": null,
        "state": "initial",
        "to_email": "to@example.com"
      }
    }


<a id="orge951b9f"></a>

# Other


<a id="org3e89bab"></a>

## Currency Rates

    _ = GET('/api/rates/BTC')

    200 OK
    
    {
      "data": {
        "BTC": {
          "AED": "25025.34",
          "AFN": "500489.79",
          "ALL": "739210.50",
          "AMD": "3289435.14",
          "ANG": "12571.72",
          "AOA": "1881863.01450000",
          "ARS": "264003.75",
          "AUD": "9390.33",
          "AWG": "12212.27",
          "AZN": "11599.13",
          "BAM": "11392.87",
          "BBD": "13626.00",
          "BCH": "12.94498382",
          "BDT": "571686.49",
          "BGN": "11421.49",
          "BHD": "2569.659",
          "BIF": "12062092",
          "BMD": "6813.00",
          "BND": "10292.42",
          "BOB": "47084.40",
          "BRL": "28391.09",
          "BSD": "6813.00",
          "BTC": "1.00000000",
          "BTN": "482270.37",
          "BWP": "72377.84",
          "BYN": "14179.99",
          "BYR": "141799855",
          "BZD": "13695.91",
          "CAD": "8852.82",
          "CDF": "11185325.23",
          "CHF": "6605.95",
          "CLF": "159.2879",
          "CLP": "4624664",
          "CNH": "46792.13",
          "CNY": "46640.94",
          "COP": "20491924.30",
          "CRC": "3883914.67",
          "CUC": "6813.00",
          "CVE": "644942.43",
          "CZK": "150516.34",
          "DJF": "1213055",
          "DKK": "43545.11",
          "DOP": "340684.06",
          "DZD": "802474.18",
          "EEK": "99563.08",
          "EGP": "121473.26",
          "ERN": "102167.07",
          "ETB": "188267.36",
          "ETC": "542.00542005",
          "ETH": "24.80466328",
          "EUR": "5849.01",
          "FJD": "14368.34",
          "FKP": "5234.95",
          "GBP": "5263.88",
          "GEL": "16888.69",
          "GGP": "5234.95",
          "GHS": "32247.29",
          "GIP": "5234.95",
          "GMD": "327194.32",
          "GNF": "61644780",
          "GTQ": "51582.61",
          "GYD": "1429897.40",
          "HKD": "53477.40",
          "HNL": "163562.83",
          "HRK": "43432.06",
          "HTG": "470114.95",
          "HUF": "1909902",
          "IDR": "98053200.73",
          "ILS": "24616.05",
          "IMP": "5234.95",
          "INR": "483825.20",
          "IQD": "8130824.630",
          "ISK": "730967",
          "JEP": "5234.95",
          "JMD": "931132.71",
          "JOD": "4833.864",
          "JPY": "756746",
          "KES": "685728.45",
          "KGS": "464220.66",
          "KHR": "27800477.98",
          "KMF": "2902963",
          "KRW": "7590295",
          "KWD": "2062.840",
          "KYD": "5678.27",
          "KZT": "2477771.99",
          "LAK": "58027093.11",
          "LBP": "10309306.60",
          "LKR": "1100026.98",
          "LRD": "1050905.02",
          "LSL": "97722.36",
          "LTC": "115.40680900",
          "LTL": "21970.87",
          "LVL": "4471.11",
          "LYD": "9399.440",
          "MAD": "64051.74",
          "MDL": "114188.22",
          "MGA": "22690515.0",
          "MKD": "359556.08",
          "MMK": "10425197.73",
          "MNT": "16638481.50",
          "MOP": "55084.08",
          "MRO": "2432241.0",
          "MTL": "4658.31",
          "MUR": "233685.13",
          "MVR": "105328.95",
          "MWK": "4954486.10",
          "MXN": "130107.52",
          "MYR": "28041.66",
          "MZN": "407315.20",
          "NAD": "98277.52",
          "NGN": "2466646.65",
          "NIO": "217603.12",
          "NOK": "56845.44",
          "NPR": "771644.58",
          "NZD": "10260.76",
          "OMR": "2623.039",
          "PAB": "6813.00",
          "PEN": "22543.90",
          "PGK": "22576.09",
          "PHP": "364263.37",
          "PKR": "838169.32",
          "PLN": "25124.32",
          "PYG": "39735779",
          "QAR": "24806.13",
          "RON": "27162.24",
          "RSD": "690047.42",
          "RUB": "464452.43",
          "RWF": "5998786",
          "SAR": "25554.54",
          "SBD": "53748.51",
          "SCR": "92722.31",
          "SEK": "62172.68",
          "SGD": "9317.23",
          "SHP": "5234.95",
          "SLL": "57161070.00",
          "SOS": "3941839.33",
          "SRD": "50811.35",
          "SSP": "887484.54",
          "STD": "143417735.14",
          "SVC": "59624.38",
          "SZL": "97722.18",
          "THB": "223262.01",
          "TJS": "64187.32",
          "TMT": "23879.42",
          "TND": "18713.982",
          "TOP": "15741.70",
          "TRY": "45324.49",
          "TTD": "45926.09",
          "TWD": "209401.68",
          "TZS": "15547266.00",
          "UAH": "191717.82",
          "UGX": "25637476",
          "USD": "6000.00",
          "UYU": "218103.44",
          "UZS": "53335116.18",
          "VEF": "1692837752.78",
          "VND": "157454495",
          "VUV": "739208",
          "WST": "17635.68",
          "XAF": "3830942",
          "XAG": "468",
          "XAU": "6",
          "XCD": "18412.47",
          "XDR": "4857",
          "XOF": "3830942",
          "XPD": "7",
          "XPF": "696925",
          "XPT": "9",
          "YER": "1705629.64",
          "ZAR": "100397.18",
          "ZMK": "35789201.71",
          "ZMW": "69329.09",
          "ZWL": "2196204.69"
        }
      }
    }

