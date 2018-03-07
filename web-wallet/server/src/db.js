var dbConfig = require('./config').db
var pg = require('pg')

var pool = new pg.Pool(dbConfig)

// For prototyping only
exports.query = function (query, args) {
  return pool.query(query, args)
}

exports.getOrCreateWallet = function (user) {
  return pool.query('SELECT * FROM wallet WHERE sub = $1', [user.sub])
    .then(r => {
      if (r.rows.length === 1) {
        wallet = r.rows[0]
        return {
          id: wallet.id,
          balance: {
            msatoshi: wallet.balance
          }
        }
      }

      const initialBalance = 5100000000;

      return pool.query(
        'INSERT INTO wallet (sub, balance) VALUES ($1, $2)',
        [user.sub, initialBalance]).then(() => exports.getOrCreateWallet(user))
    })
}

exports.updateWalletBalance = function (user, delta) {
  return pool.query('UPDATE wallet SET balance = balance + $2 WHERE sub = $1 AND balance + $2 >= 0', [user.sub, delta])
    .then(r => {
      if (r.rowCount === 0) {
        throw new Error('Insufficient funds')
      }
    })
}
