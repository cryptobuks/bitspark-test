const express = require('express')
const lightning = require('./lightning')
const jwtCheck = require('./jwt-check')
const db = require('./db')

const router = express.Router()

function sendError (res, message) {
  res.json({
    status: 'ERROR',
    error: message
  })
}

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

  // Invalid/Missing invoice
  if (!validateInvoice(invoice)) {
    sendError(res, 'Missing invoice parameter')
    return
  }

  // Get invoice payload
  let invoicePayload
  try {
    invoicePayload = await lightning.getInvoicePayload(invoice)
  } catch (err) {
    console.error(err)
    sendError(res, 'Failed to fetch invoice payload')
    return
  }

  // Register transaction into DB
  let wallet, trnId
  try {
    wallet = await db.getOrCreateWallet(req.user)
    trnId = await db.initTrancaction(
      wallet, -invoicePayload.msatoshi, invoicePayload.description,
      invoice, invoicePayload)
    console.log('Transaction ID', trnId)
  } catch (err) {
    console.error(err)
    sendError(res, 'Failed to insert transaction')
    return
  }

  try {
    // Try to deduct amount from wallet (throws on insufficient funds)
    console.log(`/invoice/pay transaction_id=${trnId} action=deduct_balance msatoshi=${-invoicePayload.msatoshi}`)
    await db.updateWalletBalance(req.user, -invoicePayload.msatoshi)

    // Try to process payment (and restore wallet balance if it fails)
    try {
      console.log(`/invoice/pay transaction_id=${trnId} action=processing`)
      const payload = await lightning.payInvoice(invoice)
      console.log(`/invoice/pay transaction_id=${trnId} result=success payload="${JSON.stringify(payload)}"`)
      await db.approveTransaction(trnId)
      res.json({
        status: 'OK',
        payload
      })
      return
    } catch (err) {
      console.log(`/invoice/pay transaction_id=${trnId} action=restore_balance msatoshi=${invoicePayload.msatoshi}`)
      db.updateWalletBalance(req.user, invoicePayload.msatoshi)
      throw err
    }
  } catch (err) {
    await db.declineTransaction(trnId)
    console.error(`/invoice/pay transaction_id=${trnId} result=error name="${err.name}" message="${err.message}"`)
    console.error(err)
    sendError(res, err.message)
    return
  }
 })

module.exports = router
