import currency from '@/currency.js'

describe('Currency', () => {
  it('should correctly convert all currencies to BTC', () => {
    expect(currency.toBtc(1, 'msatoshi')).to.equal(0.00000000001)
    expect(currency.toBtc(1, 'satoshi')).to.equal(0.00000001)
    expect(currency.toBtc(1, 'mbtc')).to.equal(0.001)
    expect(currency.toBtc(1, 'btc')).to.equal(1)
    expect(currency.toBtc(1, 'unknown')).to.equal(1)
  })
  it('should correctly convert all currencies to mBTC', () => {
    expect(currency.toMiliBtc(1, 'msatoshi')).to.equal(0.00000001)
    expect(currency.toMiliBtc(1, 'satoshi')).to.equal(0.00001)
    expect(currency.toMiliBtc(1, 'mbtc')).to.equal(1)
    expect(currency.toMiliBtc(1, 'btc')).to.equal(1000)
    expect(currency.toMiliBtc(1, 'unknown')).to.equal(1)
  })
  it('should correctly convert all currencies to satoshi', () => {
    expect(currency.toSatoshi(1, 'msatoshi')).to.equal(0.001)
    expect(currency.toSatoshi(1, 'satoshi')).to.equal(1)
    expect(currency.toSatoshi(1, 'mbtc')).to.equal(100000)
    expect(currency.toSatoshi(1, 'btc')).to.equal(100000000)
    expect(currency.toSatoshi(1, 'unknown')).to.equal(1)
  })
  it('should correctly convert all currencies to mSatoshi', () => {
    expect(currency.toMiliSatoshi(1, 'msatoshi')).to.equal(1)
    expect(currency.toMiliSatoshi(1, 'satoshi')).to.equal(1000)
    expect(currency.toMiliSatoshi(1, 'mbtc')).to.equal(100000000)
    expect(currency.toMiliSatoshi(1, 'btc')).to.equal(100000000000)
    expect(currency.toMiliSatoshi(1, 'unknown')).to.equal(1)
  })
})
