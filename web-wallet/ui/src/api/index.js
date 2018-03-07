export class NotAuthorized extends Error {
  constructor () {
    super('Not Authorized')
  }
}

export default class API {
  constructor (accessToken) {
    this.accessToken = accessToken
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
      .then(r => {
        if (r.status === 401) {
          throw new NotAuthorized()
        }
        return r
      })
      .then(r => r.json())
  }

  getInvoiceInfo (invoice) {
    return fetch('/api/payment/invoice/info?invoice=' + invoice)
      .then(r => r.json())
  }
}
