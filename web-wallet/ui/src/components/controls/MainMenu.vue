<template>

    <v-toolbar dark tabs grow>
      <v-toolbar-title>
        <img class="logo" alt="Biluminate" src="/static/img/logo.svg">
      </v-toolbar-title>

      <v-spacer></v-spacer>

      <v-btn icon>
        <v-icon>more_vert</v-icon>
      </v-btn>

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
    
</template>

<script>
export default {
  name: 'MainMenu',
  data () {
    return {
      model: 'tab-2'
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
</style>