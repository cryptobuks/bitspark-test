const express = require('express')
const jwtCheck = require('./jwt-check')
const db = require('./db')

const router = express.Router()
router.get('/info', jwtCheck, (req, res) => {
  return db.getOrCreateWallet(req.user).then(wallet => res.send(wallet))
})

module.exports = router
