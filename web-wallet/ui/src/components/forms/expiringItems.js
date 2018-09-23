function createItem ({ expiresAfter, text }) {
  return {
    id: expiresAfter,
    value: expiresAfter,
    text
  }
}

const items = [
  createItem({
    expiresAfter: 3600,
    text: 'Expiring in one hour'
  }),
  createItem({
    expiresAfter: 86400,
    text: 'Expiring in 24 hrs'
  }),
  createItem({
    expiresAfter: 604800,
    text: 'Expiring in one week'
  })
]

export default items
