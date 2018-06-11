<template>
  <v-layout row align-center text-xs-center>
    <v-flex xs12>
      <!-- Error -->
      <div v-if="error">
        <h2>Error</h2>
        <div>{{ error.message }}</div>
      </div>
      <!-- Loading -->
      <p v-else-if="isLoading">Fetching invoice data...</p>
      <!-- Processing -->
      <p v-else-if="isProcessing">Processing payment...</p>
      <!-- Payed -->
      <div v-else-if="isPayed">
        <p class="display-2">Success</p>
        <v-btn large color="primary" class="mt-5" v-on:click="successOk">OK</v-btn>          
      </div>
      <!-- Show invoice -->
      <v-container v-else fluid>
        <v-layout row justify-center>
          <v-flex xs12 sm6 lg4>
            <v-card>
              <v-card-title class="grey lighten-4 py-0">
                <v-container class="pa-0">
                  <v-layout row text-xs-center>
                    <v-flex xs10 offset-xs1>
                      <v-chip small label class="mt-0 grey lighten-5">Lightning Payment</v-chip>
                    </v-flex>
                  </v-layout>
                  <v-layout row text-xs-center class="my-4">
                    <v-flex xs12>
                      <strong class="title"><Amount :msatoshi="invoiceInfo.payload.msatoshi" /></strong>
                    </v-flex>
                  </v-layout>
                </v-container>
              </v-card-title>
              <v-card-text>
                {{ invoiceInfo.payload.description }}
              </v-card-text>
              <v-footer height="auto" class="transparent mt-5">
                <v-layout row v-if="!user">
                  <v-flex xs12 text-xs-center>
                    <LoginButton label="Login & Pay" flat  color="primary" icon="" />
                  </v-flex>
                </v-layout>
                <v-layout row v-else>
                  <v-flex xs6 text-xs-right>
                    <v-btn flat color="grey lighten-2" to="/">Cancel</v-btn>
                  </v-flex>
                  <v-flex xs6 text-xs-left>
                    <v-btn flat color="primary" v-on:click="processPayment(invoice)"><v-icon left class="mr-2">mdi-check-circle</v-icon>Confirm</v-btn>
                  </v-flex>
                </v-layout>
              </v-footer>
            </v-card>
          </v-flex>
        </v-layout>
      </v-container>
    </v-flex>
  </v-layout>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import LoginButton from '@/components/LoginButton'
import Amount from '@/components/Amount'
import { isLoading } from '@/store'

export default {
  props: ['invoice'],
  name: 'pay-invoice',
  components: { LoginButton, Amount },
  data () {
    return {}
  },
  computed: {
    invoiceInfo () {
      return this.$store.getters.getInvoiceInfo(this.invoice)
    },
    error () {
      return this.invoiceInfo.payload instanceof Error ? this.invoiceInfo.payload
        : (this.invoiceInfo.paymentResult instanceof Error ? this.invoiceInfo.paymentResult
          : undefined)
    },
    isLoading: function () {
      return this.invoiceInfo.payload === isLoading
    },
    isProcessing: function () {
      return this.invoiceInfo.paymentResult === isLoading
    },
    isPayed: function () {
      return this.invoiceInfo.paymentResult && !this.isProcessing
    },
    ...mapGetters(['user'])
  },
  watch: {
    invoice: function () {
      this.displayInvoice(this.invoice)
    }
  },
  created () {
    this.displayInvoice(this.invoice)
  },
  methods: {
    ...mapActions(['displayInvoice', 'processPayment']),
    successOk: function () {
      this.$router.push('/')
    }
  }
}
</script>
