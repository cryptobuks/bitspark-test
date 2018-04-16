const config = require('./config')
const https = require('https')
const fetch = require('node-fetch')

const agent = new https.Agent({
  rejectUnauthorized: false
})

function LightningError (message, payload) {
  this.message = message
  this.payload = payload
  this.name = 'LightningError'
}

LightningError.prototype = new Error()

function handleRestError (response, body) {
  console.error('REST call failed [', response.status, response.statusText, ']')
  console.error('Body:', body)

  return new LightningError(response.statusText, body)
}

async function GET(path) {
  const url = config.lndRestUrl + path
  console.debug('LND GET', url)

  var opts = {
    headers: {
      'grpc-metadata-macaroon': config.lndRestMacaroon,
    }
  }

  if (url.startsWith('https')) {
    opts.agent = agent
  }

  const result = await fetch(url, opts)

  if (result.status !== 200) {
    throw handleRestError(result, await result.text())
  }

  return result.json()
}

async function POST(path, json) {
  const url = config.lndRestUrl + path
  console.debug('LND POST', url)

  var opts = {
    headers: {
      'grpc-metadata-macaroon': config.lndRestMacaroon,
      'content-type': 'application/json'
    },
    method: 'POST',
    body: JSON.stringify(json)
  }

  if (url.startsWith('https')) {
    opts.agent = agent
  }

  const result = await fetch(url, opts)

  if (result.status !== 200) {
    throw handleRestError(result, await result.text())
  }

  return result.json()
}

async function getInvoicePayload(invoice) {
  const result = await GET('/v1/payreq/' + invoice)

  return {
    msatoshi: result.num_satoshis * 1000,
    description: result.description
  }
}

async function payInvoice(invoice) {
  const result = await POST('/v1/channels/transactions', {
    payment_request: invoice
  })

  if (result.payment_error) {
    console.error('Transaction processing failed, Reason:', result.payment_error)
    throw new LightningError('Transaction processing failed', result.payment_error)
  }

  return result
}

module.exports.LightningError = LightningError
module.exports.getInvoicePayload = getInvoicePayload;
module.exports.payInvoice = payInvoice;
