<template>
  <v-container fluid>
    <v-layout align-center justify-center text-xs-center>
      <v-flex xs12>
        <LoginButton v-if="!user" />
        <div v-else>
          <p class="mb-1 mt-1">Available balance</p>
          <h2>
            <Amount :msatoshi="balance && balance.msatoshi" />
          </h2>
        </div>
        <FabButton />
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
import FabButton from '@/components/controls/FabButton'
import LoginButton from '@/components/LoginButton'
import Amount from '@/components/Amount'

export default {
  name: 'hello',
  components: {
    FabButton,
    LoginButton,
    Amount
  },
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
 
<style>
  
</style>