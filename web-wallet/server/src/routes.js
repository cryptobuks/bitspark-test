const express = require('express')
const db = require('./db')
const paymentRoutes = require('./payment-routes')
const jwtCheck = require('./jwt-check')

const router = express.Router()

router.get('/', (req, res) => res.send('API'))

router.use('/payment', paymentRoutes)

router.get('/db-check', (req, res) => {
  db.query("SELECT 'OK' AS x")
    .then(r => {
      res.send(r.rows[0].x)
    })
    .catch(err => {
      console.error(err)
      res.send('Error')
    })
})

router.get('/auth-check', jwtCheck, (req, res) => {
  console.log(req.user)
  res.send({status: 'OK'})
})

module.exports = router
