<template>
  <v-btn class="bi-login-button yellow" v-if="!this.bigScreen" large v-on:click="doLogin" block>{{label || 'Login'}}</v-btn>
  <v-btn class="bi-login-button-big-screen yellow" mt-5 v-else large v-on:click="doLogin">{{label || 'Login'}}</v-btn>
</template>

<script>
import auth from '../auth'

export default {
  props: {
    label: String,
    icon: {
      type: String,
      default: 'mdi-account'
    }
  },
  name: 'LoginButton',
  computed: {
    bigScreen () {
      return this.$vuetify.breakpoint.name === 'lg' || this.$vuetify.breakpoint.name === 'xl' || this.$vuetify.breakpoint.name === 'md'
    }
  },
  methods: {
    doLogin: auth.doLogin
  }
}
</script>

<style scoped>
.bi-login-button {
  height: 56px;
  position: fixed;
  bottom: 0;
  right: 0;
  left: 0;
  margin: 0;
  border-radius: 0px;
  font-size: 17px;
  text-transform: uppercase;
}
.bi-login-button-big-screen {
  margin-top: 100px;
  min-width: 200px;
  font-size: 18px;
}
</style>
