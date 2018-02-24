const express = require('express')
const app = express()

app.use(express.static('../ui/dist'))
app.get('/api', (req, res) => res.send('API'))

var port = process.env.PORT || 3000
app.listen(port, () => console.log('Running at http://localhost:' + port))
