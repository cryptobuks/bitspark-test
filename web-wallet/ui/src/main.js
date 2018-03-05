// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import Vuetify from 'vuetify'
import App from './App'
import router from './router'
import store from './store'
import auth from './auth'

Vue.config.productionTip = false

Vue.use(Vuetify)
require('vuetify/dist/vuetify.min.css')

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
