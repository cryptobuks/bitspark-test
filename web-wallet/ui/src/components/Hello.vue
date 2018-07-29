<template>
  <v-container fill-height fluid>
    <v-layout align-center justify-center text-xs-center>
      <v-flex xs12>
        <LoginButton v-if="!user" />
        <div v-else>
          <h1 class="mb-5">Available balance</h1>
          <h2>
            <Amount :msatoshi="balance && balance.msatoshi" />
          </h2>
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
    this.$store.dispatch('fetchTransactions')
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
