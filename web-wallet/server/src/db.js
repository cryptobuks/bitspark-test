var dbConfig = require('./config').db
var pg = require('pg')

var pool = new pg.Pool(dbConfig)

// For prototyping only
exports.query = function (query, args) {
  return pool.query(query, args)
}

exports.getOrCreateWallet = async function (user) {
  const fetchResult = await pool.query('SELECT * FROM wallet WHERE sub = $1', [user.sub])
  if (fetchResult.rows.length === 1) {
    wallet = fetchResult.rows[0]
    return {
      id: wallet.id,
      balance: {
        msatoshi: wallet.balance
      }
    }
  }

  // Create new wallet
  const initialBalance = 510000000; // 5.1 mBTC

  const createResult = await pool.query(
    'INSERT INTO wallet (sub, balance) VALUES ($1, $2) RETURNING id',
    [user.sub, initialBalance])

  await pool.query(
    'INSERT INTO transaction (wallet_id, state, msatoshi, description)'
    + ' VALUES ($1, $2, $3, $4)',
    [createResult.rows[0].id, 'approved', initialBalance, 'Initial balance'])

  return exports.getOrCreateWallet(user)
}

exports.updateWalletBalance = function (user, delta) {
  return pool.query('UPDATE wallet SET balance = balance + $2 WHERE sub = $1 AND balance + $2 >= 0', [user.sub, delta])
    .then(r => {
      if (r.rowCount === 0) {
        throw new Error('Insufficient funds')
      }
    })
}

exports.getTransactions = async function (wallet) {
  const result = await pool.query(
    'SELECT id, created_on, state, description, msatoshi FROM transaction WHERE wallet_id = $1',
    [wallet.id])

  return result.rows
}

exports.initTrancaction = async function (wallet, msatoshi, description, lighting_invoice, payload) {
  const result = await pool.query(
    'INSERT INTO transaction (wallet_id, state, msatoshi, description, lighting_invoice, payload)' +
    ' VALUES ($1, \'initial\', $2, $3, $4, $5) RETURNING id',
    [wallet.id, msatoshi, description, lighting_invoice, payload]
  )

  return result.rows[0].id
}

exports.approveTransaction = function (id) {
  return pool.query('UPDATE transaction SET state = \'approved\' WHERE id = $1', [id])
}

exports.declineTransaction = function (id) {
  return pool.query('UPDATE transaction SET state = \'declined\' WHERE id = $1', [id])
}
