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

if (process.env.NODE_ENV === 'development') {
  items.push(createItem({ expiresAfter: 5, text: 'Expiring in 5 seconds (dev only)' }))
  items.push(createItem({ expiresAfter: 60, text: 'Expiring in 60 seconds (dev only)' }))
}

export default items
