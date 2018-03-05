<template>
<div class="hello">
  <h1>API</h1>
  <p>
    <div>Status: <span>{{ status || "Pending..." }}</span></div>
  </p>
</div>
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
