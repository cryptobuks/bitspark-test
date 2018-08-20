<template>

  <v-app id="app">
    <v-layout column fill-height>

      <MainMenu />
      <router-view></router-view>

    </v-layout>
  </v-app>

</template>

<script>
import MainMenu from './components/controls/MainMenu'
import { mapGetters } from 'vuex'

export default {
  name: 'app',
  components: {
    MainMenu
  },
  created () {
    this.$store.dispatch('fetchUserInfo')
    this.$store.dispatch('fetchTransactions')
  },
  computed: {
    initials: function () {
      if (!this.user) return null
      if (!this.user.name) return 'YOU'
      return this.user.name.split(/\s+/).map(s => s[0]).join('')
    },
    ...mapGetters([
      'user'
    ])
  },
  watch: {
    user: function () {
      this.$store.dispatch('fetchUserInfo')
      this.$store.dispatch('fetchTransactions')
    }
  }
}
</script>

<style>
html {
  overflow-y: auto;
}
body {
  margin: 0;
}

#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #9b9b9b;
  letter-spacing: 0.7px;
  background-color: #fff;
}

main {
  text-align: center;
  margin-top: 40px;
}

header {
  margin: 0;
  height: 56px;
  padding: 0 16px 0 24px;
  background-color: #35495e;
  color: #ffffff;
}

header span {
  display: block;
  position: relative;
  font-size: 20px;
  line-height: 1;
  letter-spacing: 0.02em;
  font-weight: 400;
  box-sizing: border-box;
  padding-top: 16px;
}

p {
  font-size: 12px;
  letter-spacing: 0.8px;
  text-transform: uppercase;
}

a {
  text-decoration: none;
  color: #ccc !important;
  transition: color 0.2s;
  cursor: pointer;
}
a:hover {
  color: #fff !important;
}

.logo {
  vertical-align: middle;
  height: 30px;
}
.bi-iframe {
  border: none;
  height: 100%;
  width: 100%;
}
.bi-container {
  margin: 0;
  padding: 0;
  margin-top: 89px;
}
@media (max-width: 1264px) {
  .bi-container {
    margin-top: 104px;
  }
}
</style>
