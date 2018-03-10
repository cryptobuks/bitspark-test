// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import Vuetify from 'vuetify'
import App from './App'
import router from './router'
import store from './store'
import auth from './auth'

Vue.config.productionTip = false

Vue.use(Vuetify, {
  theme: {
    primary: '#9ccc65',
    secondary: '#e57373',
    accent: '#90caf9'
  }
})
require('vuetify/dist/vuetify.min.css')
require('mdi/fonts/materialdesignicons-webfont.ttf')
require('mdi/css/materialdesignicons.min.css')

window.router = router

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  template: '<App/>',
  components: { App },
  mounted () {
    auth.init()
  }
})

router.beforeEach((to, from, next) => {
  store.dispatch('navigate', {to, from}).then(() => next())
})

router.onReady(() => {
  store.dispatch('navigate', {
    to: router.currentRoute
  })
})
