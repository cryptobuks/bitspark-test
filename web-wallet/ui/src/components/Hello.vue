<template>
<div class="hello">
  <h1>{{ msg }}</h1>
  <p v-if="!user">
    <v-btn v-on:click="doLogin">Login</v-btn>
  </p>
  <p v-else>
    {{ user.email }}
  </p>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import auth from '../auth'

export default {
  name: 'hello',
  data () {
    return {
      msg: 'Welcome to Your Wallet'
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
h1, h2 {
  font-weight: normal;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #35495E;
}
</style>
