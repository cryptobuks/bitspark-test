const util = require('util')
const exec = util.promisify(require('child_process').exec)

var payloads = {
  'lntb500u1pdgcwz7pp550lr83m5cty7nr744raum67ga6m2m04hm832aqc54mhrnal6qp9qdqgt96k6mtecqpxgsn30trds4g8ywdruw6uz0yfv27ltj0hh36f3hr7v3y2z5jfdj84jsxmtsmvx90dej59rx9xsyd3qylfvhss49v7h5gtaf8695zvu6sqnmcxkf': {
    "currency" : "tb",
    "timestamp" : 1519138910,
    "created_at" : 1519138910,
    "expiry" : 3600,
    "payee" : "021fa38fe355fb1528ae976ddd940cdf899f9cdfb16719602a2b7d13dbb12c60d7",
    "msatoshi" : 50000000,
    "description" : "Yummy",
    "min_final_cltv_expiry" : 6,
    "payment_hash" : "a3fe33c774c2c9e98fd5a8fbcdebc8eeb6adbeb7d9e2ae8314aeee39f7fa004a",
    "signature" : "30440220442717ac6d85507239a3e3b5c13c8962bdf5c9f7bc7498dc7e6448a152496c8f02205940db5c36c315edcca85198a6811b1013e965e10a959ebd10bea4fa2d04ce6a"
  }
}

function getInvoicePayload(invoice) {
  return new Promise((resolve, reject) => {
    var payload = payloads[invoice]
    if (!payload) return reject('Not found')

    return resolve(payload)
  })
}

module.exports.getInvoicePayload = getInvoicePayload;
