const express = require('express')
const app = express()
const jwt = require('express-jwt');
const jwks = require('jwks-rsa');
const cors = require('cors')
const bodyParser = require('body-parser')
const lightning = require('./src/lightning')
const db = require('./src/db')

const jwtCheck = jwt({
  secret: jwks.expressJwtSecret({
      cache: true,
      rateLimit: true,
      jwksRequestsPerMinute: 5,
      jwksUri: "https://biluminate.eu.auth0.com/.well-known/jwks.json"
  }),
  audience: 'https://biluminate.net/auth',
  issuer: "https://biluminate.eu.auth0.com/",
  algorithms: ['RS256']
})

app.use(express.static(process.env.PUBLIC_DIR || '../ui/dist'))
app.use(cors());
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({
  extended: true
}))

app.get('/api', (req, res) => res.send('API'))

app.get('/api/db-check', (req, res) => {
  db.query("SELECT 'OK' AS x")
    .then(r => {
      res.send(r.rows[0].x)
    })
    .catch(err => {
      console.error(err)
      res.send('Error')
    })
})

app.get('/api/auth-check', jwtCheck, (req, res) => {
  console.log(req.user)
  res.send({status: 'OK'})
})

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

app.post('/api/invoice/pay', jwtCheck, (req, res) => {
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
