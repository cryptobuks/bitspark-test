import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const state = {
  user: undefined
}

const mutations = {
  login (state, payload) {
    state.user = payload.user
  }
}

const actions = {
  login: ({ commit }, payload) => {
    commit('login', payload)
  }
}

const getters = {
  user: state => state.user
}

export default new Vuex.Store({
  state,
  getters,
  actions,
  mutations
})
