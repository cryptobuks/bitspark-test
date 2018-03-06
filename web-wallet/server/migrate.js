const config = require('./src/config.js')

process.env.DATABASE_URL = config.DATABASE_URL

require('./node_modules/node-pg-migrate/bin/node-pg-migrate')
