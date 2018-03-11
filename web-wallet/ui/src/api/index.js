export function NotAuthorizedError (message) {
  this.message = message
  this.name = 'NotAuthorizedError'
}

NotAuthorizedError.prototype = new Error()

function assertHttpOk (res) {
  if (res.status === 401) {
    throw new NotAuthorizedError('Not Authorized')
  }
  if (res.status !== 200) {
    throw new Error('Request failed: ' + res.status + ' ' + res.statusText)
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
      .then(r => {
        if (r.status !== 'OK') {
          throw new Error(r.error)
        }
        return r.payload
      })
  }

  getInvoiceInfo (invoice) {
    return fetch('/api/payment/invoice/info?invoice=' + invoice)
      .then(assertHttpOk)
      .then(r => r.json())
      .then(r => {
        if (r.status !== 'OK') {
          throw new Error(r.error)
        }
        return r.payload
      })
  }
}
