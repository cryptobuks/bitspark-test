const util = require('util')
const exec = util.promisify(require('child_process').exec)
const config = require('./config')

function LightningError (message) {
  this.message = message
  this.name = 'LightningError'
}

LightningError.prototype = new Error()

function handleCliSuccess (result) {
  try {
    return JSON.parse(result.stdout)
  } catch (e) {
    console.error('Failed to parse lncli result', result)
    throw new LightningError('Failed to parse lncli result')
  }
}

function handleCliError (error) {
  var message
  try {
    message = JSON.parse(error.stdout).message
  } catch (e) {
    console.error(error.toString())
    message = 'Unexpected lncli error'
  }
  throw new LightningError(message)
}

function getInvoicePayload(invoice) {
  return exec(config.lncli + ' decodepay ' + invoice)
    .then(handleCliSuccess)
    .catch(handleCliError)
}

function payInvoice(invoice) {
  return exec(config.lncli + ' pay ' + invoice)
  .then(handleCliSuccess)
  .catch(handleCliError)
}

module.exports.LightningError = LightningError
module.exports.getInvoicePayload = getInvoicePayload;
module.exports.payInvoice = payInvoice;
