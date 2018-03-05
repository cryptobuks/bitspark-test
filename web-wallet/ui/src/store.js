import Vue from 'vue'
import Vuex from 'vuex'
import VuexPersistence from 'vuex-persist'
import router from './router'

Vue.use(Vuex)

const state = {
  user: undefined,
  accessToken: undefined,
  returnTo: undefined
}

const mutations = {
  beforeLogin (state, payload) {
    state.returnTo = payload.returnTo
  },
  apiAuthError (state, payload) {
    state.user = undefined
    state.accessToken = undefined
  },
  loginFailure (state, payload) {
    state.user = undefined
    state.accessToken = undefined
  },
  loginSuccess (state, payload) {
    state.user = payload.user
    state.accessToken = payload.accessToken
    state.returnTo = undefined
  }
}

const actions = {
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
  }
}

const getters = {
  user: state => state.user,
  accessToken: state => state.accessToken
}

const vuexLocal = new VuexPersistence({
  storage: window.localStorage
})

export default new Vuex.Store({
  state,
  getters,
  actions,
  mutations,
  plugins: [vuexLocal.plugin]
})
