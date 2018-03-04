import router from './router'
import store from './store'

import { Auth0Lock } from 'auth0-lock'

var lock = new Auth0Lock(
  'VNuKB9PX4R6v27ltkqjhe68X5NSH8pND', 'biluminate.eu.auth0.com')

function getUserInfo (accessToken) {
  lock.getUserInfo(accessToken, function (error, profile) {
    if (error) {
      alert(error)
      return
    }

    localStorage.setItem('accessToken', accessToken)

    store.dispatch('login', {
      user: profile,
      accessToken: accessToken
    })

    console.log(profile)
    router.push('/')
  })
}

lock.on('authenticated', function (authResult) {
  console.log(authResult)
  getUserInfo(authResult.accessToken)
})

var accessToken = localStorage.getItem('accessToken')

if (accessToken) {
  getUserInfo(accessToken)
}

export default lock
