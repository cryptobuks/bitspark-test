const express = require('express')
const jwtCheck = require('./jwt-check')

const router = express.Router()
router.get('/info', jwtCheck, (req, res) => {
  res.send({
    balance: {
      msatoshi: 5000000000
    }
  })
})

module.exports = router
