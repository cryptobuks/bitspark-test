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
  invoices: {}
}

const mutations = {
  apiError (state, err) {
    if (err instanceof NotAuthorizedError) {
      state.user = undefined
      state.accessToken = undefined
      state.wallet = undefined
    }
  },
  walletInfo (state, walletInfo) {
    state.wallet = walletInfo
  },
  beforeLogin (state, payload) {
    state.returnTo = payload.returnTo
  },
  apiAuthError (state, payload) {
    state.user = undefined
    state.accessToken = undefined
    state.wallet = undefined
  },
  loginFailure (state, payload) {
    state.user = undefined
    state.accessToken = undefined
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
  fetchUserInfo: ({ commit, getters: { api } }) => {
    return api.getWalletInfo()
      .then(r => commit('walletInfo', r))
      .catch(err => commit('apiError', err))
  },
  navigate: ({ dispatch, state }, { to, from }) => {
    console.log('to', to)
    console.log('from', from)
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
  apiAuthError: ({ commit }) => {
    commit('apiAuthError')
    console.error('apiAuthError')
  },
  loginFailure: ({ commit }, payload) => {
    commit('loginFailure', payload)
    console.error('loginFailure', payload.error)
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
      .catch(e => e)
      .then(payload => commit('setInvoicePayload', { invoice, payload }))
  },
  processPayment ({ commit, state, getters: { api } }, invoice) {
    commit('startInvoicePayment', invoice)
    api.payInvoice(invoice)
      .catch(e => e)
      .then(paymentResult => commit('setInvoicePaymentResult', { invoice, paymentResult }))
  }

}

const getters = {
  api: state => new API(state.accessToken),
  user: state => state.user,
  balance: state => state.wallet && state.wallet.balance,
  getInvoiceInfo (state) {
    return (invoice) => state.invoices[invoice]
  }
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
