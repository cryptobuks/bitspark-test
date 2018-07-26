<template>
    <v-toolbar dark class="nav">
        <v-toolbar-title>
            <img class="logo" alt="Biluminate" src="/static/img/logo.svg">
        </v-toolbar-title>
        
        <v-spacer></v-spacer>

        <v-btn icon>
            <v-icon>more_vert</v-icon>
        </v-btn>

        <v-container slot="extension" class="white--text sub-menu" grid-list-md text-xs-center>
            <v-layout row wrap>
                <v-flex class="sub-menu-item" xs4>
                    <router-link to="/history">History</router-link>
                </v-flex>
                <v-flex class="sub-menu-item" xs4>
                    <router-link to="/">Balance</router-link>
                </v-flex>
                <v-flex class="sub-menu-item" xs4>
                    <router-link to="/subscription">Subscription</router-link>
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
.sub-menu-item a {
  font-size: 11px;
  letter-spacing: 0.4px;
  text-transform: uppercase;
}
.sub-menu-item:hover {
  opacity: 1;
}
</style>