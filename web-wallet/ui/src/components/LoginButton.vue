<template>
  <v-btn large v-on:click="doLogin">Login<v-icon right>mdi-account</v-icon></v-btn>
</template>

<script>
import auth from '../auth'

export default {
  name: 'LoginButton',
  methods: {
    doLogin: auth.doLogin
  }
}
</script>