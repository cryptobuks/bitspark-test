import ApolloClient from 'apollo-client'
import { InMemoryCache } from 'apollo-cache-inmemory'

import * as AbsintheSocket from '@absinthe/socket'
import {createAbsintheSocketLink} from '@absinthe/socket-apollo-link'
import {Socket as PhoenixSocket} from 'phoenix'

export default function createClient ({ accessToken }) {
  const socketLink = createAbsintheSocketLink(AbsintheSocket.create(
    new PhoenixSocket('/api/socket', {
      params: {
        Authorization: `Bearer ${accessToken}`
      }
    })
  ))

  return new ApolloClient({
    link: socketLink,
    cache: new InMemoryCache({
      addTypename: false
    })
  })
}
