const BASE_URL = 'https://testwallet.biluminate.com/api'

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
    return fetch(BASE_URL + '/wallet', {
      headers: new Headers({
        'Authorization': 'Bearer ' + this.accessToken,
        'Content-Type': 'application/json'
      })
    }).then(assertHttpOk)
      .then(r => r.json())
  }

  getTransactions () {
    return fetch(BASE_URL + '/wallet/transactions', {
      headers: new Headers({
        'Authorization': 'Bearer ' + this.accessToken,
        'Content-Type': 'application/json'
      })
    }).then(assertHttpOk)
      .then(r => r.json())
      .then(r => r.data)
  }

  processPayment (payment) {
    return fetch(BASE_URL + '/wallet/transactions', {
      method: 'POST',
      cache: 'no-cache',
      mode: 'cors',
      body: JSON.stringify(payment),
      headers: new Headers({
        Authorization: 'Bearer ' + this.accessToken,
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
    return fetch(BASE_URL + '/wallet/invoice/' + invoice, {
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
