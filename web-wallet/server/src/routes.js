const express = require('express')
const db = require('./db')
const paymentRoutes = require('./payment-routes')
const walletRoutes = require('./wallet-routes')
const transactionsRoutes = require('./transactions-routes')
const jwtCheck = require('./jwt-check')

const router = express.Router()

router.get('/', (req, res) => res.send('API'))

router.use('/payment', paymentRoutes)
router.use('/wallet', walletRoutes)
router.use('/transactions', transactionsRoutes)

router.get('/db-check', (req, res) => {
  db.query("SELECT 'OK' AS x")
    .then(r => {
      res.send(r.rows[0].x)
    })
    .catch(err => {
      console.error('/db-check', err)
      res.send('Error')
    })
})

router.get('/auth-check', jwtCheck, (req, res) => {
  console.log(req.user)
  res.send({status: 'OK'})
})

module.exports = router
