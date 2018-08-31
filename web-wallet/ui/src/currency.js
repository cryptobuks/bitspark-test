function toBtc (amount, currency) {
  switch (currency.toLowerCase()) {
    case 'msatoshi': return amount / 100000000000
    case 'satoshi': return amount / 100000000
    case 'mbtc': return amount / 1000
    case 'btc': return amount
    default: return amount
  }
}
function toMiliBtc (amount, currency) {
  switch (currency.toLowerCase()) {
    case 'msatoshi': return amount / 100000000
    case 'satoshi': return amount / 100000
    case 'mbtc': return amount
    case 'btc': return amount * 1000
    default: return amount
  }
}
function toSatoshi (amount, currency) {
  switch (currency.toLowerCase()) {
    case 'msatoshi': return amount / 1000
    case 'satoshi': return amount
    case 'mbtc': return amount * 100000
    case 'btc': return amount * 100000000
    default: return amount
  }
}
function toMiliSatoshi (amount, currency) {
  switch (currency.toLowerCase()) {
    case 'msatoshi': return amount
    case 'satoshi': return amount * 1000
    case 'mbtc': return amount * 100000000
    case 'btc': return amount * 100000000000
    default: return amount
  }
}

const currency = {
  toBtc: toBtc,
  toMiliBtc: toMiliBtc,
  toSatoshi: toSatoshi,
  toMiliSatoshi: toMiliSatoshi
}
export default currency
