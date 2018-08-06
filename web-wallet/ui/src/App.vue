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
  computed: {
    initials: function () {
      if (!this.user) return null
      if (!this.user.name) return 'YOU'
      return this.user.name.split(/\s+/).map(s => s[0]).join('')
    },
    ...mapGetters([
      'user'
    ])
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
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #9b9b9b;
  letter-spacing: 0.7px;
}

main {
  text-align: center;
  margin-top: 40px;
}

header {
  margin: 0;
  height: 56px;
  padding: 0 16px 0 24px;
  background-color: #35495E;
  color: #ffffff;
}

header span {
  display: block;
  position: relative;
  font-size: 20px;
  line-height: 1;
  letter-spacing: .02em;
  font-weight: 400;
  box-sizing: border-box;
  padding-top: 16px;
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

</style>
