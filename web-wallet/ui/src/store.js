import Vue from 'vue'
import Vuex from 'vuex'
import VuexPersistence from 'vuex-persist'
import router from './router'
import { API, NotAuthorizedError } from './api'

Vue.use(Vuex)

const stringifiedFeatureToggles = localStorage.getItem('featureToggles')

const featureToggles = Object.assign(
  {
    qrScan: false,
    recieve: false,
    paymentToEmail: true
  },
  stringifiedFeatureToggles ? JSON.parse(stringifiedFeatureToggles) : {}
)

const state = {
  featureToggles,
  currencyRates: {}, // {"BTC": {"USD": 6000, ...}}
  user: undefined, // currently authorized user
  accessToken: undefined,
  returnTo: undefined,
  wallet: undefined,
  invoices: {},
  transactions: {},
  payment: null,
  paymentResult: null,
  claimResult: null
}

const mutations = {
  apiError (state, err) {
    if (err instanceof NotAuthorizedError) {
      state.user = undefined
      state.accessToken = undefined
      state.wallet = undefined
      state.returnTo = undefined
    }
  },
  clearStore (state) {
    state.user = undefined
    state.accessToken = undefined
    state.returnTo = undefined
    state.wallet = undefined
    state.invoices = {}
    state.transaction = {}
    state.payment = null
    state.paymentResult = null
    state.claimResult = null
  },
  currencyRatesUpdate (state, rates) {
    state.currencyRates = rates
  },
  walletInfo (state, walletInfo) {
    state.wallet = walletInfo
  },
  transactions (state, transactions) {
    state.transactions = transactions
  },
  payment (state, payment) {
    state.payment = payment
  },
  paymentResult (state, paymentResult) {
    state.paymentResult = paymentResult
  },
  removePayment (state) {
    state.payment = null
    state.paymentResult = null
  },
  claimResult (state, claimResult) {
    state.claimResult = claimResult
  },
  removeClaimResult (state) {
    state.claimResult = null
  },
  beforeLogin (state, payload) {
    state.returnTo = payload.returnTo
  },
  loginFailure (state, payload) {
    state.user = undefined
    state.accessToken = undefined
    state.returnTo = undefined
  },
  loginSuccess (state, payload) {
    state.user = payload.user
    state.accessToken = payload.accessToken
    state.returnTo = undefined
  },
  initializeInvoice (state, invoice) {
    state.invoices = {
      ...state.invoices,
      [invoice]: state.invoices[invoice] || {
        payload: isLoading,
        paymentResult: undefined
      }
    }
  },
  setInvoicePayload (state, { invoice, payload }) {
    state.invoices = {
      ...state.invoices,
      [invoice]: {
        ...state.invoices[invoice],
        payload
      }
    }
  },
  startInvoicePayment (state, invoice) {
    state.invoices = {
      ...state.invoices,
      [invoice]: {
        ...state.invoices[invoice],
        paymentResult: isLoading
      }
    }
  },
  setInvoicePaymentResult (state, { invoice, paymentResult }) {
    state.invoices = {
      ...state.invoices,
      [invoice]: {
        ...state.invoices[invoice],
        paymentResult
      }
    }
  }
}

const actions = {
  init: ({ commit, getters: { api } }) => {
    api.getCurrencyRates('BTC')
      .then(rates => commit('currencyRatesUpdate', rates))
  },
  logout: ({ commit, getters: { api } }) => {
    api.logout()
    commit('clearStore')
  },
  fetchUserInfo: ({ commit, dispatch, getters: { api, user } }) => {
    if (!user) return null

    api.subscribeToWalletInfo(walletInfo => {
      commit('walletInfo', walletInfo)
      dispatch('fetchTransactions')
    })

    return api.getWalletInfo()
      .then(r => commit('walletInfo', r))
      .catch(err => commit('apiError', err))
  },
  fetchTransactions: ({ commit, getters: { api, user } }) => {
    if (!user) return null

    return api.getTransactions()
      .then(r => commit('transactions', r))
      .catch(err => commit('apiError', err))
  },
  navigate: ({ dispatch, state }, { to, from }) => {
  },
  beforeLogin: ({ commit }, payload) => {
    // Save current route so that we can return to it after successful login
    const currentRoute = router.currentRoute
    commit('beforeLogin', {
      returnTo: {
        name: currentRoute.name,
        params: currentRoute.params
      }
    })
  },
  loginFailure: ({ commit }, payload) => {
    commit('loginFailure', payload)

    // Payment & Claim pages support non-authorized user so stay there
    if (!['PayInvoice', 'Claim'].includes(router.currentRoute.name)) {
      router.push('/')
    }
  },
  loginSuccess: ({ commit, state }, payload) => {
    const returnTo = state.returnTo
    commit('loginSuccess', payload)
    if (returnTo) {
      router.push(returnTo)
    }
  },
  displayInvoice: ({ commit, state, getters: { api } }, invoice) => {
    commit('initializeInvoice', invoice)
    api.getInvoiceInfo(invoice)
      .catch(e => {
        commit('apiError', e)
        return e
      })
      .then(payload => commit('setInvoicePayload', { invoice, payload }))
  },
  processInvoicePayment ({ commit, getters: { api } }, invoice) {
    commit('startInvoicePayment', invoice)
    api.processPayment({invoice})
      .catch(e => {
        commit('apiError', e)
        return e
      })
      .then(paymentResult => {
        commit('setInvoicePaymentResult', { invoice, paymentResult })
      })
  },
  processToEmailPayment ({ commit, dispatch, getters: { api } }, payment) {
    api.processPayment(payment)
      .catch(e => {
        commit('apiError', e)
        return e
      })
      .then(paymentResult => {
        commit('paymentResult', paymentResult.message)
        router.push({ name: 'PaymentConfirmation' })
      })
  },
  claimToEmailPayment ({ commit, dispatch, getters: { api } }, claimToken) {
    api.claimPayment(claimToken)
      .catch(e => {
        commit('apiError', e)
        return e
      })
      .then(claimResult => {
        commit('claimResult', claimResult)
      })
  },
  createPayment ({ commit }, payment) {
    commit('payment', payment)
  },
  removePayment ({ commit }) {
    commit('removePayment')
  },
  removeClaimResult ({ commit }) {
    commit('removeClaimResult')
  }
}

const getters = {
  api: state => new API(state.accessToken),
  featureToggles: state => state.featureToggles,
  accessToken: state => state.accessToken,
  user: state => state.user,
  balance: state => state.wallet && state.wallet.balance,
  getInvoiceInfo (state) {
    return (invoice) => state.invoices[invoice]
  },
  getConversionRate (state) {
    return (from, to) => {
      return state.currencyRates[from] ? state.currencyRates[from][to] : null
    }
  },
  transactions: state => state.transactions,
  payment: state => state.payment,
  paymentResult: state => state.paymentResult,
  claimResult: state => state.claimResult
}

const vuexLocal = new VuexPersistence({
  storage: window.localStorage,
  reducer: state => ({
    currencyRates: state.currencyRates,
    user: state.user,
    accessToken: state.accessToken,
    returnTo: state.returnTo
  })
})

export const isLoading = class {}

export default new Vuex.Store({
  state,
  getters,
  actions,
  mutations,
  plugins: [vuexLocal.plugin]
})
