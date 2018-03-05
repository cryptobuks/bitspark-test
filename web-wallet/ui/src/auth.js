import store from './store'

import { Auth0Lock } from 'auth0-lock'

var lock = new Auth0Lock(
  'VNuKB9PX4R6v27ltkqjhe68X5NSH8pND', 'biluminate.eu.auth0.com',
  {
    auth: {
      params: {
        audience: 'https://biluminate.net/auth'
      }
    }
  }
)

function getUserInfo (accessToken) {
  lock.getUserInfo(accessToken, function (error, profile) {
    if (error) {
      store.dispatch('loginFailure', {
        error: error,
        accessToken
      })
      return
    }

    store.dispatch('loginSuccess', {
      user: profile,
      accessToken
    })
  })
}

function init () {
  lock.on('authenticated', function (authResult) {
    console.warn('authenticated')
    getUserInfo(authResult.accessToken)
  })
}

function doLogin () {
  store.dispatch('beforeLogin', {})
  lock.show()
}

const auth = {
  init: init,
  doLogin: doLogin
}

export default auth
