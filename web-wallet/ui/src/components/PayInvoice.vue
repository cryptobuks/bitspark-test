<template>
  <v-layout row align-center text-xs-center>
    <v-flex xs12>
      <!-- Error -->
      <div v-if="apiError">
        <h2>Error</h2>
        <div>{{ apiError }}</div>
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
                      <Amount :msatoshi="invoicePayload.msatoshi" />
                    </v-flex>
                  </v-layout>
                </v-container>
              </v-card-title>
              <v-card-text>
                {{ invoicePayload.description }}
              </v-card-text>
              <v-footer height="auto" class="transparent mt-5">
                <v-layout row>
                  <v-flex xs6 text-xs-right class="pr-3">
                    <v-btn flat color="grey lighten-2" v-on:click="cancelPayment">Cancel</v-btn>
                  </v-flex>
                  <v-flex xs6 text-xs-left class="pl-3">
                    <LoginButton v-if="!user" />
                    <v-btn v-else flat color="primary" v-on:click="processPayment">&nbsp;<v-icon left class="mr-2">mdi-check-circle</v-icon>Pay&nbsp;</v-btn>
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

export default {
  props: ['invoice'],
  name: 'pay-invoice',
  components: { LoginButton, Amount },
  data () {
    return {
      isProcessing: false,
      apiError: undefined,
      invoicePayload: undefined,
      paymentResult: undefined
    }
  },
  computed: {
    isLoading: function () {
      return !this.invoicePayload
    },
    isPayed: function () {
      return this.paymentResult !== undefined
    },
    price: function () {
      return {
        amount: this.invoicePayload.msatoshi / 100000000,
        unit: 'mBTC'
      }
    },
    ...mapGetters([
      'api',
      'user'
    ])
  },
  watch: {
    invoice: function () {
      this.fetchInvoicePayload()
    }
  },
  created () {
    this.fetchInvoicePayload()
  },
  methods: {
    ...mapActions(['apiAuthError']),
    cancelPayment: function () {
      this.$router.push('/')
    },
    successOk: function () {
      this.$router.push('/')
    },
    processPayment: function () {
      this.isProcessing = true
      this.api.payInvoice(this.invoice)
        .then(r => {
          if (r.status !== 'OK') {
            this.apiError = r.error
            return
          }
          this.isProcessing = false
          this.paymentResult = r.payload
        })
        .catch(e => {
          this.isProcessing = false
          console.error(e)
          this.apiError = 'Process payment failed'
        })
    },
    fetchInvoicePayload: function () {
      this.invoicePayload = undefined
      this.api.getInvoiceInfo(this.invoice)
        .then(r => {
          if (r.status !== 'OK') {
            this.apiError = r.error
            return
          }
          this.invoicePayload = r.payload
        })
        .catch(e => (this.apiError = 'Fetch failed'))
    }
  }
}
</script>
