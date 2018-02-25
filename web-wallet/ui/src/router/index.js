import Vue from 'vue'
import Router from 'vue-router'
import Hello from '@/components/Hello'
import PayInvoice from '@/components/PayInvoice'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Hello',
      component: Hello
    },
    {
      path: '/pay/:invoice',
      name: 'PayInvoice',
      component: PayInvoice,
      props: true
    }
  ]
})
