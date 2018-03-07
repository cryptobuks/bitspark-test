exports.up = (pgm) => {
  pgm.sql(
    'CREATE TABLE wallet (' +
      '  id SERIAL PRIMARY KEY,' +
      '  sub TEXT NOT NULL UNIQUE,' +
      '  balance NUMERIC NOT NULL' +
      ')'
  )
};

exports.down = (pgm) => {
};
