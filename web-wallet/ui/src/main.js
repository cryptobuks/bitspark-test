// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import Vuetify from 'vuetify'
import App from './App'
import router from './router'
import store from './store'
import auth from './auth'

Vue.config.productionTip = false

// https://material.io/color/#!/?view.left=0&view.right=0&primary.color=9CCC65&secondary.color=EF9A9A
Vue.use(Vuetify, {
  theme: {
    primary: '#ffc80a',
    secondary: '#e57373',
    accent: '#90caf9',
    darkGrey: '#4a4a4a',
    grey: '#9b9b9b',
    charcoalGrey: '#434350',
    purplishGrey: '#757476',
    yellow: '#ffc80a',
    blue: '#4a90e2',
    green: '#68ba42'
  }
})
require('vuetify/dist/vuetify.min.css')
require('mdi/fonts/materialdesignicons-webfont.ttf')
require('mdi/css/materialdesignicons.min.css')

/* eslint-disable no-new, no-unused-vars */
var app = new Vue({
  el: '#app',
  router,
  store,
  template: '<App/>',
  components: { App },
  mounted () {
    auth.init()
  }
})

// window.app = app

store.dispatch('init', {})

router.beforeEach((to, from, next) => {
  store.dispatch('navigate', { to, from }).then(() => next())
})

router.onReady(() => {
  store.dispatch('navigate', {
    to: router.currentRoute
  })
})

navigator.registerProtocolHandler(
  'web+lightning',
  'testwallet.biluminate.com/#/pay/%s',
  'Lightning handler')
