<template>
  <v-container fill-height justify-center>
    <v-btn v-if="!user" large right v-on:click="doLogin">Login<v-icon right>mdi-account</v-icon></v-btn>
    <div v-else>
      <h1>Welcome to Your Wallet</h1>
    </div>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
import auth from '../auth'

export default {
  name: 'hello',
  data () {
    return {
    }
  },
  computed: mapGetters([
    'user'
  ]),
  methods: {
    doLogin: auth.doLogin
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>
</style>
