<template>
  <v-container fill-height justify-center>
    <LoginButton v-if="!user" />
    <div v-else>
      <h1>Welcome to Your Wallet</h1>
    </div>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
import LoginButton from '@/components/LoginButton'

export default {
  name: 'hello',
  components: { LoginButton },
  computed: {
    ...mapGetters(['user'])
  }
}
</script>
