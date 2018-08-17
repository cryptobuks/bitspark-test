<template>
  <v-container class="bi-container subscriptions" fill-height fluid>
    <v-layout align-center justify-center text-xs-center>
      <v-flex xs12 lg6 text-xs-center>
        <img class="mb-5" src="static/img/subscriptions.svg" />
        <p class="mt-2">
          In the final release, this is where we'll show you subscriptions and standing orders (if you have any) <br><br> 
          We plan to add a subscription feature, peer-to-peer transactions, and email-based logins.
        </p>
        <FabButton />
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import FabButton from '../controls/FabButton'

export default {
  name: 'Subscription',
  components: {
    FabButton
  },
  data () {
    return {}
  },
  methods: {}
}
</script>

<style>
.subscriptions img {
  width: 128px;
  height: 128px;
}
.subscriptions p {
  margin: auto;
  max-width: 270px;
  text-transform: none;
  letter-spacing: 0.5px;
}
</style>