import ApolloClient from 'apollo-client'
import { InMemoryCache } from 'apollo-cache-inmemory'

import * as AbsintheSocket from '@absinthe/socket'
import {createAbsintheSocketLink} from '@absinthe/socket-apollo-link'
import {Socket as PhoenixSocket} from 'phoenix'

export default function createClient ({ accessToken }) {
  const socket = new PhoenixSocket('/api/socket', {
    params: {
      Authorization: `Bearer ${accessToken}`
    }
  })

  const socketLink = createAbsintheSocketLink(AbsintheSocket.create(socket))

  const client = new ApolloClient({
    link: socketLink,
    cache: new InMemoryCache({
      addTypename: false
    })
  })

  client.setToken = token => (socket.params.Authorization = `Bearer ${token}`)

  return client
}
