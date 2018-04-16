const express = require('express')
const morgan = require('morgan')
const app = express()
const cors = require('cors')
const bodyParser = require('body-parser')
const config = require('./config')
const routes = require('./routes.js')
const lndStub = require('./lnd-rest-stub')

if (config.httpLogFormat) {
  app.use(morgan(config.httpLogFormat))
}

app.use(express.static(process.env.PUBLIC_DIR || '../ui/dist'))
app.use(cors());
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({
  extended: true
}))
app.use('/api', routes)

if (process.env.DEV) {
  console.log('Attaching LND stub')
  app.use('/', lndStub.routes)
}

module.exports = app
