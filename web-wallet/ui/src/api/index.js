export function NotAuthorizedError (message) {
  Error.call(this, message)
  this.message = message
}

function assertHttpOk (res) {
  if (res.status === 401) {
    throw new NotAuthorizedError('Not Authorized')
  }
  return res
}

export class API {
  constructor (accessToken) {
    this.accessToken = accessToken
  }

  getWalletInfo () {
    return fetch('/api/wallet/info', {
      headers: new Headers({
        'Authorization': 'Bearer ' + this.accessToken,
        'Content-Type': 'application/json'
      })
    }).then(assertHttpOk)
      .then(r => r.json())
  }

  payInvoice (invoice) {
    return fetch('/api/payment/invoice/pay', {
      method: 'POST',
      cache: 'no-cache',
      mode: 'cors',
      body: JSON.stringify({
        invoice: invoice
      }),
      headers: new Headers({
        'Authorization': 'Bearer ' + this.accessToken,
        'Content-Type': 'application/json'
      })
    })
      .then(assertHttpOk)
      .then(r => r.json())
  }

  getInvoiceInfo (invoice) {
    return fetch('/api/payment/invoice/info?invoice=' + invoice)
      .then(r => r.json())
  }
}