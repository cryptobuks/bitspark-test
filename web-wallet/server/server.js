const app = require('./src/app')

var port = process.env.PORT || 8081
app.listen(port, () => console.log('Running at http://localhost:' + port))
