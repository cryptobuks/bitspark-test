<template>
  <div>

    <v-toolbar dark tabs grow fixed v-if="this.user">
      <v-toolbar-side-icon @click.stop="drawer = !drawer" v-if="!(this.routesWithoutMenu.indexOf($route.name) > -1)"></v-toolbar-side-icon>
      <v-btn icon v-if="(this.routesWithoutMenu.indexOf($route.name) > -1) && $route.name !== 'PaymentConfirmation' && $route.name !== 'Claim'" @click="$router.go(-1)">
        <v-icon>arrow_back</v-icon>
      </v-btn>

      <v-toolbar-title v-if="!(this.routesWithoutMenu.indexOf($route.name) > -1)">
        <img class="bi-logo" alt="Biluminate" src="/static/img/biluminate-logo.svg">
      </v-toolbar-title>
      <v-toolbar-title v-if="this.routesWithoutMenu.indexOf($route.name) > -1" class="bi-central-heading" v-bind:class="{'no-margin': this.routesWithoutBackButton.indexOf($route.name) > -1 }">
        <h1>{{ heading }}</h1>
      </v-toolbar-title>

      <v-tabs v-if="!(this.routesWithoutMenu.indexOf($route.name) > -1)" :hide-slider="(this.routesWithoutMenuSlider.indexOf($route.name) > -1 )" class="bi-tabs" slot="extension" centered grow slider-color="yellow">
        <v-tab class="bi-tab" :to="{ path:'/history' }">
          <span class="grey--text">History</span>
        </v-tab>
        <v-tab class="bi-tab" :to="{ path:'/' }">
          <span class="grey--text">Balance</span>
        </v-tab>
        <v-tab class="bi-tab" :to="{ path:'/subscription' }">
          <span class="grey--text">Subscriptions</span>
        </v-tab>
      </v-tabs>
    </v-toolbar>

    <v-navigation-drawer v-if="this.user" class="bi-navigation-drawer" v-model="drawer" dark temporary fixed>
      <v-list class="bi-drawer-heading pa-1 pt-3 pb-3">
        <v-list-tile avatar>
          <v-list-tile-avatar>
            <v-icon v-if="!this.user.picture" x-large class="bi-icon">account_circle</v-icon>
            <img v-else v-bind:src="this.user.picture" />
          </v-list-tile-avatar>

          <v-list-tile-content>
            <v-list-tile-title class="bi-name">{{this.user.name}}</v-list-tile-title>
            <v-list-tile-title class="bi-email grey--text">{{this.user.email}}</v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
      </v-list>

      <v-list class="pt-0">
        <v-divider></v-divider>

        <v-list-tile class="bi-list-tile" :to="{ path:'/faq' }">
          <v-list-tile-content>
            <v-list-tile-title class="bi-list-tile-title grey--text">FAQ</v-list-tile-title>
          </v-list-tile-content>
          <v-list-tile-action>
            <v-icon color="grey">keyboard_arrow_right</v-icon>
          </v-list-tile-action>
        </v-list-tile>
        <v-list-tile class="bi-list-tile" :to="{ path:'/about' }">
          <v-list-tile-content>
            <v-list-tile-title class="bi-list-tile-title grey--text">About</v-list-tile-title>
          </v-list-tile-content>
          <v-list-tile-action>
            <v-icon color="grey">keyboard_arrow_right</v-icon>
          </v-list-tile-action>
        </v-list-tile>
        <v-list-tile class="bi-list-tile" :to="{ path:'/roadmap' }">
          <v-list-tile-content>
            <v-list-tile-title class="bi-list-tile-title grey--text">Wallet Roadmap</v-list-tile-title>
          </v-list-tile-content>
          <v-list-tile-action>
            <v-icon color="grey">keyboard_arrow_right</v-icon>
          </v-list-tile-action>
        </v-list-tile>
        <v-list-tile class="bi-list-tile" @click="handleLogoutOnClick">
          <v-list-tile-action>
            <v-icon small color="grey">power_settings_new</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>
            <v-list-tile-title class="bi-list-tile-title yellow--text">Logout</v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
      </v-list>

    </v-navigation-drawer>

  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  name: 'MainMenu',
  data () {
    return {
      routesWithoutMenuSlider: ['Faq', 'About', 'Roadmap', 'Send'],
      routesWithoutMenu: ['Send', 'Review', 'PaymentConfirmation', 'Claim'],
      routesWithoutBackButton: ['PaymentConfirmation', 'Claim'],
      drawer: null
    }
  },
  computed: {
    ...mapGetters(['user']),
    heading () {
      switch (this.$route.name) {
        case 'Send': return 'Send / Pay'
        case 'Review': return 'Review & Confirm'
        case 'PaymentConfirmation': return 'Confirmation'
        case 'Claim': return 'Claim funds'
        default: return 'Biluminate'
      }
    }
  },
  methods: {
    ...mapActions(['logout']),
    handleLogoutOnClick () {
      this.drawer = null
      this.logout()
      this.$router.push({ path: '/' })
    }
  }
}
</script>

<style scoped>
.bi-bigger-toolbar {
  height: 88px;
}
.bi-logo {
  width: 180px;
}
.bi-central-heading {
  width: 100%;
  text-align: center;
  margin-left: -40px;
}
.bi-central-heading h1 {
  font-size: 13px;
  font-weight: normal;
  text-transform: uppercase;
}
.bi-central-heading.no-margin {
  margin: 0;
}
.bi-tabs {
  max-width: 500px;
  margin: auto;
}
.bi-navigation-drawer {
  background-color: #282b3d !important;
  overflow-y: hidden;
}
.bi-drawer-heading {
  background: linear-gradient(
    90deg,
    #2e3654 0%,
    #323655 50%,
    #584062 100%
  ) !important;
}
.bi-list-tile {
  padding: 6px 15px 6px 10px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.18);
  cursor: pointer;
}
.bi-list-tile:hover {
  background: linear-gradient(
    90deg,
    #2e3654 0%,
    #323655 50%,
    #584062 100%
  ) !important;
}
.bi-name {
  font-size: 13px;
  letter-spacing: 0.8px;
}
.bi-email {
  margin-top: -6px;
  font-size: 11px;
  letter-spacing: 0.5px;
}
.bi-list-tile-title {
  font-size: 12px;
  text-transform: uppercase;
}
</style>

<style>
/* Vuetify overrides */
.toolbar {
  background: linear-gradient(
    90deg,
    #2e3654 0%,
    #2e3654 50%,
    #584062 100%
  ) !important;
}
.tabs span {
  font-size: 11px !important;
  min-width: 80px !important;
}
.tabs__item {
  opacity: 1 !important;
}
.tabs__item:hover span {
  transition: color 0.3s;
  color: #fff !important;
}
.tabs__item--active span {
  color: #fff !important;
}
.tabs__slider {
  height: 4px !important;
}
.tabs,
.tabs__bar {
  background-color: transparent !important;
}
.toolbar__content > .btn:first-child {
  margin-left: 17px !important;
}
.list__tile--link:hover {
  background: none !important;
}
.bi-list-tile:hover i,
.bi-list-tile:hover .bi-list-tile-title {
  color: #fff !important;
}
@media (min-width: 1264px) {
  .tabs span {
    font-size: 12px !important;
  }
  .toolbar {
    height: 89px !important;
  }
  .toolbar__content {
    height: 89px !important;
  }
  .toolbar__extension {
    margin-top: -47px !important;
  }
}
</style>