import Vue from 'vue'
import Router from 'vue-router'

import Hello from '@/components/Hello'
import ApiCheck from '@/components/ApiCheck'
import PayInvoice from '@/components/PayInvoice'
import HistoryPage from '@/components/pages/History'
import Balance from '@/components/pages/Balance'
import Subscription from '@/components/pages/Subscription'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Hello',
      component: Hello
    },
    {
      path: '/api-check',
      name: 'ApiCheck',
      component: ApiCheck
    },
    {
      path: '/pay/:invoice',
      name: 'PayInvoice',
      component: PayInvoice,
      props: true
    },
    {
      path: '/history',
      name: 'History',
      component: HistoryPage
    },
    {
      path: '/balance',
      name: 'Balance',
      component: Balance
    },
    {
      path: '/subscription',
      name: 'Subscription',
      component: Subscription
    }
  ]
})
