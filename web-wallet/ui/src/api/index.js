export function NotAuthorizedError (message) {
  this.message = message
  this.name = 'NotAuthorizedError'
}

NotAuthorizedError.prototype = new Error()

function assertHttpOk (res) {
  if (res.status === 401) {
    throw new NotAuthorizedError('Not Authorized')
  }
  if (![200, 201].includes(res.status)) {
    throw new Error('Request failed: ' + res.status + ' ' + res.statusText)
  }
  return res
}

export class API {
  constructor (accessToken) {
    this.accessToken = accessToken
  }

  getWalletInfo () {
    return fetch('/api/wallet', {
      headers: new Headers({
        'Authorization': 'Bearer ' + this.accessToken,
        'Content-Type': 'application/json'
      })
    }).then(assertHttpOk)
      .then(r => r.json())
  }

  getTransactions () {
    return fetch('/api/wallet/transactions', {
      headers: new Headers({
        'Authorization': 'Bearer ' + this.accessToken,
        'Content-Type': 'application/json'
      })
    }).then(assertHttpOk)
      .then(r => r.json())
      .then(r => r.data)
  }

  payInvoice (invoice) {
    return fetch('/api/wallet/transactions', {
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
        if (r.data.state !== 'approved') {
          throw new Error(r.data.state)
        }
        return r.data
      })
  }

  getInvoiceInfo (invoice) {
    return fetch('/api/wallet/invoice/' + invoice, {
      headers: new Headers({
        'Authorization': 'Bearer ' + this.accessToken,
        'Content-Type': 'application/json'
      })
    })
      .then(assertHttpOk)
      .then(r => r.json())
      .then(r => {
        return r.data
      })
  }
}
