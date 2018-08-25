<template>
  <div>
    <v-speed-dial v-if="this.user && (featureToggles.paymentToEmail || featureToggles.qrScan || featureToggles.recieve)" fixed v-model="fab" :bottom="true" :right="true" :direction="'top'" :transition="'scale-transition'">

      <v-btn color="yellow" slot="activator" v-model="fab" fab>
        <v-icon>add</v-icon>
        <v-icon>close</v-icon>
      </v-btn>

      <router-link to="send" v-if="featureToggles.paymentToEmail" tag="div" class="bi-menuitem-container">
        <span class="bi-menuitem-desc charcoalGrey--text">Send / Pay</span>
        <v-btn fab dark small color="blue" class="bi-fab-menu-button">
          <v-icon class="bi-icon-send">arrow_upward</v-icon>
        </v-btn>
      </router-link>
      <div v-if="featureToggles.qrScan" class="bi-menuitem-container">
        <span class="bi-menuitem-desc charcoalGrey--text">Scan QR Code</span>
        <v-btn fab dark small color="grey" class="bi-fab-menu-button">
          <v-icon class="bi-icon-recieve">arrow_upward</v-icon>
        </v-btn>
      </div>
      <div v-if="featureToggles.recieve" class="bi-menuitem-container">
        <span class="bi-menuitem-desc charcoalGrey--text">Recieve / Deposit</span>
        <v-btn fab dark small color="green" class="bi-fab-menu-button">
          <v-icon class="bi-icon-recieve">arrow_upward</v-icon>
        </v-btn>
      </div>
    </v-speed-dial>
    <div v-if="this.user && this.fab" class="bi-fab-overlay" @click="fab=false"></div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'FabButton',
  data () {
    return {
      fab: false
    }
  },
  computed: {
    ...mapGetters(['user', 'featureToggles'])
  },
  methods: {
    handleOnCLick () {
      console.log('Handle on click.')
    }
  }
}
</script>

<style scoped>
.btn--bottom.btn--absolute {
  bottom: 16px;
}
.bi-fab-menu-button {
  width: 45px !important;
  height: 45px !important;
  margin-top: 6px;
  margin-bottom: 6px;
}
.bi-icon-send {
  transform: rotate(45deg);
}
.bi-icon-recieve {
  transform: rotate(225deg);
}
.bi-menuitem-container {
  display: flex;
  align-items: center;
  width: 364px;
  cursor: pointer;
  margin-top: 3px;
  margin-bottom: 3px;
}
.bi-menuitem-desc {
  height: 26px;
  min-width: 140px;
  margin-right: 10px;
  background-color: #d8d8d8;
  border-radius: 5px;
  padding: 5px 14px;
  font-size: 11px;
  font-weight: bold;
  text-transform: uppercase;
  text-align: center;
}
.bi-fab-overlay {
  z-index: 3;
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  background: #000;
  opacity: 0.5;
}
</style>

<style>
/* Vuetify overrides */
.speed-dial {
  z-index: 4 !important;
}
</style>
