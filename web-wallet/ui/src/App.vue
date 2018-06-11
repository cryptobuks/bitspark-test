<template>
  <v-app id="app">
    <v-layout column fill-height>
      <v-toolbar dark color="primary">
        <v-toolbar-title>Bi<span style="color: #FFC80A">luminate</span></v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn flat icon><v-icon>mdi-account</v-icon></v-btn>
      </v-toolbar>
      <router-view></router-view>
    </v-layout>
  </v-app>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'app',
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

.toolbar {
  background: linear-gradient(90deg, #2E3654 0%, #2E3654 13.87%, #F06493 100%);
}
</style>
