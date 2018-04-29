const express = require('express')
const router = express.Router()

router.get('/v1/payreq/:invoice', (req, res) => {
  res.json({
    "destination": "039cc950286a8fa99218283d1adc2456e0d5e81be558da77dd6e85ba9a1fff5ad3",
    "payment_hash": "4ce6edd6cddecfd12b6114900dcc5442e35415a4136091d79b7250cd05747600",
    "num_satoshis": "150",
    "timestamp": "1523476204",
    "expiry": "3600",
    "description": "Foobar #" + req.params.invoice.slice(-3),
    "cltv_expiry": "144"
  })
})

router.post('/v1/channels/transactions', (req, res) => {
  if (req.headers['grpc-metadata-macaroon'] !== 'foobaroon') {
    res.status(500).json({
      "error":"verification failed: signature mismatch after caveat verification",
      "code":2
    })
    return
  }

  const invoice = req.body.payment_request

  if (invoice.endsWith('1999')) {
    res.status(500).json({
      "error":"invoice expired. Valid until 2018-04-28 11:43:00 +0000 UTC","code":2
    })
    return
  }

  if (invoice.endsWith('999')) {
    res.json({payment_error: "UnknownPaymentHash"})
    return
  }

  res.json(
    {
      "payment_preimage": "+b9n1eSD0DlPhIdh8JowwMhQfJXEAsxV6RAspa4OJRA=",
      "payment_route": {
        "total_time_lock": 1292308,
        "total_fees": "1",
        "total_amt": "101",
        "hops": [
          {
            "chan_id": "1420515147023712256",
            "chan_capacity": "897123",
            "amt_to_forward": "100",
            "fee": "1",
            "expiry": 1292164
          },
          {
            "chan_id": "1417756472375115776",
            "chan_capacity": "1000000",
            "amt_to_forward": "100",
            "expiry": 1292164
          }
        ]
      }
    }
  )
})

module.exports = {
  routes: router
}
