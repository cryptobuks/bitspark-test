<template>
  <v-container fluid fill-height>
    <v-layout align-center justify-center>
      <span>Status: <span>{{ status || "Pending..." }}</span></span>
    </v-layout>
  </v-container>
</template>

<script>
import router from '../router'
import { mapGetters } from 'vuex'

export default {
  name: 'login-success',
  data () {
    return {
      status: undefined
    }
  },
  computed: {
    ...mapGetters([
      'user',
      'accessToken'
    ])
  },
  created () {
    if (!this.user) {
      router.push('/')
      return
    }

    window.fetch('/api/auth-check', {
      headers: {
        'Authorization': 'Bearer ' + this.accessToken
      }
    }).then(r => {
      if (r.status === 200) {
        return r.json().then(result => (this.status = result.status))
      }
      this.status = 'Error ' + r.status
    })
  }
}
</script>
