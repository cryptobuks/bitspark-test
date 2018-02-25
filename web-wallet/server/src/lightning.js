const util = require('util')
const exec = util.promisify(require('child_process').exec)
const config = require('./config')

function getInvoicePayload(invoice) {
  // TODO: When something goes wrong command returns non-zero exit code (e.g., wrong invoice)
  return exec(config.lncli + ' decodepay ' + invoice).then(result => {
    if (result.stderr) console.error(result.stderr)

    return JSON.parse(result.stdout)
  })
}

module.exports.getInvoicePayload = getInvoicePayload;
