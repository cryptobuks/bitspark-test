var hasErrors = false

function reportConfigError(msg) {
  console.error('Error:', msg)
  hasErrors = true
}

if (!process.env.LNCLI) {
  reportConfigError('Missing LNCLI environment variable')
}

if (hasErrors) {
  process.exit(1)
}

module.exports = {
  lncli: process.env.LNCLI
}
