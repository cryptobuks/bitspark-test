const express = require('express')
const app = express()
const bodyParser = require('body-parser')
const lightning = require('./src/lightning')

app.use(express.static(process.env.PUBLIC_DIR || '../ui/dist'))
app.use(bodyParser.json());
app.get('/api', (req, res) => res.send('API'))

app.get('/api/invoice/info', (req, res) => {
  var invoice = req.query.invoice
  if (!invoice) {
    res.json({
      status: 'ERROR',
      error: 'Missing invoice parameter'
    })

    return
  }

  return lightning.getInvoicePayload(invoice).then(payload => res.json({
    status: 'OK',
    payload
  }))
  .catch(error => res.json({
    status: 'ERROR',
    error: error
  }))
})

app.post('/api/invoice/pay', (req, res) => {
  console.info('PAY', req.body)

  var invoice = req.body.invoice
  if (!invoice) {
    res.json({
      status: 'ERROR',
      error: 'Missing invoice parameter'
    })

    return
  }

  return lightning.payInvoice(invoice).then(payload => {
    console.log('PAY_RESULT', payload)
    res.json({
      status: 'OK',
      payload
    })
  })
  .catch(error => res.json({
    status: 'ERROR',
    error: error
  }))
})

var port = process.env.PORT || 8081
app.listen(port, () => console.log('Running at http://localhost:' + port))
