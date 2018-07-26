<template>
    <v-toolbar dark class="nav">
        <v-toolbar-title>
            <img class="logo" alt="Biluminate" src="/static/img/logo.svg">
        </v-toolbar-title>
        
        <v-spacer></v-spacer>

        <v-btn icon>
            <v-icon>more_vert</v-icon>
        </v-btn>

        <v-container slot="extension" class="white--text sub-menu" text-xs-center>
            <v-layout row wrap>
                <v-flex class="sub-menu-item" xs4>
                    <router-link to="/history">History</router-link>
                </v-flex>
                <v-flex class="sub-menu-item" xs4>
                    <router-link to="/">Balance</router-link>
                </v-flex>
                <v-flex class="sub-menu-item" xs4>
                    <router-link to="/subscription">Subscriptions</router-link>
                </v-flex>
            </v-layout>
        </v-container>

    </v-toolbar>
</template>

<script>
export default {
  name: 'MainMenu'
}
</script>

<style>
.nav {
  background: linear-gradient(to right, #2f3655, #574062);
}
.sub-menu {
  padding: 0px;
}
.sub-menu-item a {
  width: 100%;
  display: block;
  padding: 18px 10px;
  font-size: 11px;
  letter-spacing: 0.6px;
  text-transform: uppercase;
  border-bottom: 4px solid transparent;
  transition: border 0.2s;
}
.sub-menu-item a.router-link-exact-active {
  color: #fff !important;
  border-bottom: 4px solid #ffc80a;
}
.sub-menu-item:hover {
  opacity: 1;
}
</style>