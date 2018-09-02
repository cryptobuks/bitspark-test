const express = require('express')
const helmet = require('helmet')
const morgan = require('morgan')
const app = express()
const config = require('./config')

if (config.httpLogFormat) {
  app.use(morgan(config.httpLogFormat))
}

app.use(helmet({frameguard: {action: 'deny'}}))
app.use(express.static(process.env.PUBLIC_DIR || '../ui/dist'))

module.exports = app
