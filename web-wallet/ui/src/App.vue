<template>

<v-app id="app">
  <v-layout column fill-height>
    <MainMenu />
    <router-view></router-view>
  </v-layout>
</v-app>

</template>

<script>
import MainMenu from './components/mainMenu/MainMenu'
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
body {
  margin: 0;
}

#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
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

.toolbar {
  background: linear-gradient(90deg, #2E3654 0%, #323655 50%, #584062 100%);
}
</style>
