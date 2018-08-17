<template>
  <v-container class="bi-container" fluid>
    <v-layout align-center justify-center text-xs-center>
      <v-flex xs12 lg6>
        <LoginOverlay v-if="!user" />
        <div class="balance" v-else>
          <p class="mb-1 mt-2">Available balance</p>
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
import LoginOverlay from '@/components/login/LoginOverlay'
import Amount from '@/components/Amount'

export default {
  name: 'hello',
  components: {
    FabButton,
    LoginOverlay,
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
@media (min-width: 960px) {
  .balance {
    margin-top: 100px;
  }
}  
</style>