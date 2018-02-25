const express = require('express')
const app = express()

app.use(express.static(process.env.PUBLIC_DIR || '../ui/dist'))
app.get('/api', (req, res) => res.send('API'))

var port = process.env.PORT || 8081
app.listen(port, () => console.log('Running at http://localhost:' + port))
