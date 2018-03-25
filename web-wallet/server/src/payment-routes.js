const express = require('express')
const lightning = require('./lightning')
const jwtCheck = require('./jwt-check')
const db = require('./db')

const router = express.Router()

function validateInvoice(invoice) {
  if (invoice.match(/^\w+$/)) {
    return invoice
  }

  return undefined
}

router.get('/invoice/info', (req, res) => {
  var invoice = req.query.invoice
  if (!validateInvoice(invoice)) {
    res.json({
      status: 'ERROR',
      error: 'Missing invoice parameter'
    })

    return
  }

  return lightning.getInvoicePayload(invoice)
    .then(payload => res.json({
      status: 'OK',
      payload
    }))
    .catch(e => {
      console.error('/invoice/info', e)
      res.json({
        status: 'ERROR',
        error: e.message
      })
    })
})

router.post('/invoice/pay', jwtCheck, async (req, res) => {
  console.info('PAY', req.body)
  var invoice = req.body.invoice

  try {
    if (!validateInvoice(invoice)) {
      throw new Error('Missing invoice parameter')
    }

    // Get invoice payload
    const invoicePayload = await lightning.getInvoicePayload(invoice)

    // Try to deduct amount from wallet (throws on insufficient funds)
    console.log('PAY - Deduct', invoicePayload.msatoshi)
    await db.updateWalletBalance(req.user, -invoicePayload.msatoshi)

    // Try to process payment (and restore wallet balance if it fails)
    try {
      console.log('PAY - processPayment')
      const result = await lightning.payInvoice(invoice)
      console.log('PAY_RESULT', payload)
      res.json({
        status: 'OK',
        payload
      })
      return
    } catch (err) {
      console.log('PAY - Restore', invoicePayload.msatoshi)
      db.updateWalletBalance(req.user, invoicePayload.msatoshi)
      throw err
    }
  } catch (err) {
    console.error('/invoice/pay', err)
    res.json({
      status: 'ERROR',
      error: err.message
    })
  }
 })

module.exports = router
