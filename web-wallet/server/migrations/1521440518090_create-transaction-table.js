exports.up = (pgm) => {
  pgm.sql(
    'CREATE TABLE transaction_state (' +
    '  state VARCHAR(16) PRIMARY KEY' +
    ')'
  )

  pgm.sql('INSERT INTO transaction_state VALUES(\'initial\')')
  pgm.sql('INSERT INTO transaction_state VALUES(\'approved\')')
  pgm.sql('INSERT INTO transaction_state VALUES(\'declined\')')

  pgm.sql(
    'CREATE TABLE transaction (' +
    '  id BIGSERIAL PRIMARY KEY,' +
    '  wallet_id BIGINT REFERENCES wallet (id) NOT NULL,' +
    '  created_on TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,' +
    '  state VARCHAR(16) REFERENCES transaction_state (state) NOT NULL,' +
    '  description TEXT NOT NULL DEFAULT \'\',' +
    '  msatoshi NUMERIC NOT NULL,' +
    '  payload JSON,' +
    '  lighting_invoice TEXT' +
    ')'
  )

  pgm.sql(
    'ALTER SEQUENCE transaction_id_seq RESTART WITH 10100000000001 INCREMENT BY 3'
  )
};

exports.down = (pgm) => {
  pgm.sql('DROP TABLE transaction')
  pgm.sql('DROP TABLE transaction_state')
};
