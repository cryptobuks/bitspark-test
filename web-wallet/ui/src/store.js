import Vue from 'vue'
import Vuex from 'vuex'
import VuexPersistence from 'vuex-persist'
import router from './router'
import { API, NotAuthorizedError } from './api'

Vue.use(Vuex)

const state = {
  user: undefined, // currently authorized user
  accessToken: undefined,
  returnTo: undefined,
  wallet: undefined,
  invoices: {},
  transactions: {},
  payment: {}
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
  },
  walletInfo (state, walletInfo) {
    state.wallet = walletInfo.data
  },
  transactions (state, transactions) {
    state.transactions = transactions
  },
  payment (state, payment) {
    state.payment = payment
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
  logout: ({ commit }) => {
    commit('clearStore')
  },
  fetchUserInfo: ({ commit, getters: { api, user } }) => {
    if (!user) return null

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

    // Payment page supports non-authorized user so stay there
    if (router.currentRoute.name !== 'PayInvoice') {
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
  processPayment ({ commit, getters: { api } }, invoice) {
    commit('startInvoicePayment', invoice)
    api.payInvoice(invoice)
      .catch(e => {
        commit('apiError', e)
        return e
      })
      .then(paymentResult => {
        commit('setInvoicePaymentResult', { invoice, paymentResult })
      })
  },
  createPayment ({ commit }, payment) {
    commit('payment', payment)
  }
}

const getters = {
  api: state => new API(state.accessToken),
  accessToken: state => state.accessToken,
  user: state => state.user,
  balance: state => state.wallet && state.wallet.balance,
  getInvoiceInfo (state) {
    return (invoice) => state.invoices[invoice]
  },
  getTransactions (state) {
    return state.transactions
  },
  payment: state => state.payment
}

const vuexLocal = new VuexPersistence({
  storage: window.localStorage,
  reducer: state => ({
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
