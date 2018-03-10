<template>
  <v-btn v-if="!flat" large v-on:click="doLogin">Login<v-icon right>mdi-account</v-icon></v-btn>
  <v-btn v-else flat v-on:click="doLogin">Login<v-icon right>mdi-account</v-icon></v-btn>
</template>

<script>
import auth from '../auth'

export default {
  props: {
    flat: Boolean
  },
  name: 'LoginButton',
  methods: {
    doLogin: auth.doLogin
  }
}
</script>