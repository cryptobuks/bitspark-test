const express = require('express')
const jwtCheck = require('./jwt-check')
const db = require('./db')

const router = express.Router()

router.get('/', jwtCheck, async (req, res) => {
  const wallet = await db.getOrCreateWallet(req.user)
  const transactions = await db.getTransactions(wallet)
  res.json({
    transactions
  })
})

module.exports = router
