const express = require('express')
const app = express()
const lightning = require('./src/lightning')

app.use(express.static(process.env.PUBLIC_DIR || '../ui/dist'))
app.get('/api', (req, res) => res.send('API'))

app.get('/api/invoice-info', (req, res) => {
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

var port = process.env.PORT || 8081
app.listen(port, () => console.log('Running at http://localhost:' + port))
