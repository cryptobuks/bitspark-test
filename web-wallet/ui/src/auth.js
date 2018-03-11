import store from './store'

import { Auth0Lock } from 'auth0-lock'

var lock = new Auth0Lock(
  'VNuKB9PX4R6v27ltkqjhe68X5NSH8pND', 'biluminate.eu.auth0.com',
  {
    autoclose: true,
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
        error: error
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
  if (store.getters.accessToken) {
    getUserInfo(store.getters.accessToken)
  }

  lock.on('authenticated', function (authResult) {
    getUserInfo(authResult.accessToken)
  })

  lock.on('authorization_error', function (error) {
    store.dispatch('loginFailure', {
      error: error
    })
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
