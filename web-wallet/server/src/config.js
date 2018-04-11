exports.lndRestUrl = process.env.LND_REST_URL
exports.lndRestMacaroon = process.env.LND_REST_MACAROON

// Database
var db = {
  user: process.env.PGUSER || 'postgres',
  database: process.env.PGDATABASE || 'postgres',
  password: process.env.PGPASSWORD,
  host: process.env.PGHOST || 'localhost',
  port: process.env.PGPORT || 5432,
  max: 10, // max number of clients in the pool
  idleTimeoutMillis: 30000 // how long to keep idle client
}

exports.db = db

exports.DATABASE_URL = 'postgres://' +
  db.user + (db.password ? (':' + db.password) : '') +
  '@' + db.host + ':' + db.port + '/' + db.database
