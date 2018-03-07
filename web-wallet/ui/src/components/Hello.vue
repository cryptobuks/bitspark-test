<template>
  <v-container fill-height justify-center>
    <LoginButton v-if="!user" />
    <div v-else>
      <h1 class="mb-2">Welcome Your Wallet</h1>
      <p>
        Balance: <Amount :msatoshi="balance && balance.msatoshi" />
      </p>
    </div>
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
