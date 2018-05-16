const express = require('express')
const app = express()

app.get('/:invoice', (req, res) => {
  if (!req.params.invoice || !req.params.invoice.startsWith('ln')) {
    res.status(404).send('Not found')
    return
  }

  res.redirect('https://bit-1.biluminate.net/#/pay/' + req.params.invoice)
})

app.listen(3000, () => console.log('pay-redir running on port 3000'))
