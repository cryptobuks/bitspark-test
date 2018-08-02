<template>
  <div>
    
    <v-toolbar dark tabs grow>
      <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>

      <v-toolbar-title>
        <img class="logo" alt="Biluminate" src="/static/img/logo.svg">
      </v-toolbar-title>

      <v-tabs class="bi-tabs" slot="extension" centered grow slider-color="yellow">
        <v-tab class="bi-tab" :to="{ path:'/history' }">
          <span>History</span>
        </v-tab>
        <v-tab class="bi-tab" :to="{ path:'/' }">
          <span>Balance</span>
        </v-tab>
        <v-tab class="bi-tab" :to="{ path:'/subscription' }">
          <span>Subscription</span>
        </v-tab>
      </v-tabs>
    </v-toolbar>

    <v-navigation-drawer class="bi-navigation-drawer" v-model="drawer" dark absolute temporary>
      <v-list class="bi-drawer-heading pa-1 pt-3 pb-3">
        <v-list-tile avatar>
          <v-list-tile-avatar>
            <img v-bind:src="this.user.picture" />
          </v-list-tile-avatar>

          <v-list-tile-content>
            <v-list-tile-title class="bi-name">{{this.user.name}}</v-list-tile-title>
            <v-list-tile-title class="bi-email">{{this.user.email}}</v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
      </v-list>

      <v-list class="pt-0">
        <v-divider></v-divider>

        <v-list-tile class="bi-list-tile bordered">
          <v-list-tile-content>
            <v-list-tile-title class="bi-list-tile-title">FAQ</v-list-tile-title>
          </v-list-tile-content>
          <v-list-tile-action>
            <v-icon>keyboard_arrow_right</v-icon>
          </v-list-tile-action>
        </v-list-tile>
        <v-list-tile class="bi-list-tile bordered">
          <v-list-tile-content>
            <v-list-tile-title class="bi-list-tile-title">About</v-list-tile-title>
          </v-list-tile-content>
          <v-list-tile-action>
            <v-icon>keyboard_arrow_right</v-icon>
          </v-list-tile-action>
        </v-list-tile>
        <v-list-tile class="bi-list-tile bordered">
          <v-list-tile-content>
            <v-list-tile-title class="bi-list-tile-title">Wallet Roadmap</v-list-tile-title>
          </v-list-tile-content>
          <v-list-tile-action>
            <v-icon>keyboard_arrow_right</v-icon>
          </v-list-tile-action>
        </v-list-tile>
        <v-list-tile class="bi-list-tile">
          <v-list-tile-action>
            <v-icon>power_settings_new</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>
            <v-list-tile-title class="bi-list-tile-title">Logout</v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
      </v-list>

    </v-navigation-drawer>

  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'MainMenu',
  computed: {
    ...mapGetters([
      'user'
    ])
  },
  data () {
    return {
      drawer: null
    }
  }
}
</script>

<style>
.toolbar {
  background: linear-gradient(90deg, #2E3654 0%, #323655 50%, #584062 100%);
}
.tabs, .tabs__bar {
  background-color: transparent !important;
}
.bi-tabs {
  max-width: 500px;
  margin: auto;
}
.tabs span {
  font-size: 11px;
  min-width: 80px;
}
.bi-navigation-drawer {
  background-color: #323655 !important;
}
.bi-drawer-heading {
  background: linear-gradient(90deg, #2E3654 0%, #323655 50%, #584062 100%) !important;
}
.bi-list-tile {
  padding: 3px 0px;
  cursor: pointer;
}
.bi-list-tile.bordered {
  border-bottom: 1px solid #777;
}
.bi-list-tile:hover {
  background-color: #20254A !important;
}
.bi-name {
  font-size: 12px;
}
.bi-email {
  margin-top: -8px;
  font-size: 11px;
  color: #bbb;
}
.bi-list-tile-title {
  font-size: 12px;
  text-transform: uppercase;
}
</style>