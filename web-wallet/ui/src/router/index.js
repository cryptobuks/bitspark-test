import Vue from 'vue'
import Router from 'vue-router'

import Hello from '@/components/Hello'
import ApiCheck from '@/components/ApiCheck'
import PayInvoice from '@/components/PayInvoice'
import HistoryPage from '@/components/pages/History'
import Balance from '@/components/pages/Balance'
import Subscription from '@/components/pages/Subscription'
import Faq from '@/components/pages/Faq'
import About from '@/components/pages/About'
import WalletRoadmap from '@/components/pages/WalletRoadmap'
import Send from '@/components/pages/Send'
import Review from '@/components/pages/Review'
import PaymentConfirmation from '@/components/pages/PaymentConfirmation'
import ClaimPage from '@/components/pages/ClaimPage'

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
    },
    {
      path: '/send',
      name: 'Send',
      component: Send
    },
    {
      path: '/send-review',
      name: 'Review',
      component: Review
    },
    {
      path: '/send-confirmation',
      name: 'PaymentConfirmation',
      component: PaymentConfirmation
    },
    {
      path: '/claim/:claimToken',
      name: 'Claim',
      component: ClaimPage
    },
    {
      path: '/faq',
      name: 'Faq',
      component: Faq
    },
    {
      path: '/roadmap',
      name: 'Roadmap',
      component: WalletRoadmap
    },
    {
      path: '/about',
      name: 'About',
      component: About
    }
  ]
})
