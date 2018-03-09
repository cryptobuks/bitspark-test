<template>
  <v-container fill-height>
    <v-layout align-center justify-center text-xs-center>
      <v-flex xs12>
        <LoginButton v-if="!user" />
        <div v-else>
          <h1 class="mb-5">Welcome Your Wallet</h1>
          <p>
            Available balance<br />
            <strong><Amount :msatoshi="balance && balance.msatoshi" /></strong>
          </p>
        </div>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
import LoginButton from '@/components/LoginButton'
import Amount from '@/components/Amount'

export default {
  name: 'hello',
  components: { LoginButton, Amount },
  created () {
    this.$store.dispatch('fetchUserInfo')
  },
  watch: {
    user: function () {
      this.$store.dispatch('fetchUserInfo')
    }
  },
  computed: {
    ...mapGetters(['user', 'balance'])
  }
}
</script>
