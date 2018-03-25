exports.up = (pgm) => {
  pgm.sql(
    'CREATE TABLE wallet (' +
      '  id BIGSERIAL PRIMARY KEY,' +
      '  sub TEXT NOT NULL UNIQUE,' +
      '  balance NUMERIC NOT NULL' +
      ')'
  )

  pgm.sql(
    'ALTER SEQUENCE wallet_id_seq RESTART WITH 9010000000001 INCREMENT BY 7'
  )
};

exports.down = (pgm) => {
};
