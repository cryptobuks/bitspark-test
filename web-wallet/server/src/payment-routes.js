const express = require('express')
const lightning = require('./lightning')
const jwtCheck = require('./jwt-check')
const db = require('./db')

const router = express.Router()

router.get('/invoice/info', (req, res) => {
  var invoice = req.query.invoice
  if (!invoice) {
    res.json({
      status: 'ERROR',
      error: 'Missing invoice parameter'
    })

    return
  }

  return lightning.getInvoicePayload(invoice).then(payload => res.json({
    status: 'OK',
    payload
  }))
  .catch(error => res.json({
    status: 'ERROR',
    error: error
  }))
})

router.post('/invoice/pay', jwtCheck, (req, res) => {
  console.info('PAY', req.body)

  var invoice = req.body.invoice
  if (!invoice) {
    res.json({
      status: 'ERROR',
      error: 'Missing invoice parameter'
    })

    return
  }

  var processPayment = () => lightning.payInvoice(invoice).then(payload => {
    console.log('PAY_RESULT', payload)
    res.json({
      status: 'OK',
      payload
    })
  })

  return lightning.getInvoicePayload(invoice)
    .then(invoice => {
      console.log('PAY - Deduct', invoice.msatoshi)
      return db.updateWalletBalance(req.user, -invoice.msatoshi)
        .then(() => {
          console.log('PAY - processPayment')
          return processPayment()
            .catch(err => {
              console.log('PAY - Restore', invoice.msatoshi)
              db.updateWalletBalance(req.user, invoice.msatoshi)
              throw err
            })
          })
    })
    .catch(err => {
      res.json({
        status: 'ERROR',
        error: err instanceof Error ? err.toString() : err
      })
    })
  })

module.exports = router
