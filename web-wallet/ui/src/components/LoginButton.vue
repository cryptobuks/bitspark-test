<template>
  <v-btn v-if="!flat" v-bind:color="color" large v-on:click="doLogin">{{label || 'Login'}}<v-icon right>mdi-account</v-icon></v-btn>
  <v-btn v-else flat v-bind:color="color" v-on:click="doLogin">{{label || 'Login'}}<v-icon right>mdi-account</v-icon></v-btn>
</template>

<script>
import auth from '../auth'

export default {
  props: {
    label: String,
    flat: Boolean,
    color: String
  },
  name: 'LoginButton',
  methods: {
    doLogin: auth.doLogin
  }
}
</script>
