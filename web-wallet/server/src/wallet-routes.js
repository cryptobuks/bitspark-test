const express = require('express')
const jwtCheck = require('./jwt-check')
const db = require('./db')

const router = express.Router()

router.get('/info', jwtCheck, async (req, res) => {
  const wallet = await db.getOrCreateWallet(req.user)
  res.send(wallet)
})

module.exports = router
