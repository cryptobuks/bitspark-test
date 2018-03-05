<template>
  <v-container grid-list-md text-xs-center fill-height>
    <v-layout row wrap>
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
        <div v-else>
          <p class="display-2">{{ invoicePayload.description }}</p>
          <p class="display-1 mt-5">{{ price.amount }} {{ price.unit }}</p>

          <div class="mt-5">
            <v-btn v-if="!user" v-on:click="doLogin">Login</v-btn>
            <div v-else>
              <v-btn large color="primary" v-on:click="processPayment">PAY<v-icon right>mdi-flash</v-icon></v-btn>
              <v-btn color="accent" v-on:click="cancelPayment">CANCEL<v-icon right>mdi-close-circle</v-icon></v-btn>
            </div>
          </div>
        </div>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import auth from '../auth'

export default {
  props: ['invoice'],
  name: 'pay-invoice',
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
      'user',
      'accessToken'
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
    doLogin: auth.doLogin,
    cancelPayment: function () {
      this.$router.push('/')
    },
    successOk: function () {
      this.$router.push('/')
    },
    processPayment: function () {
      this.isProcessing = true
      fetch('/api/invoice/pay', {
        method: 'POST',
        cache: 'no-cache',
        mode: 'cors',
        body: JSON.stringify({
          invoice: this.invoice
        }),
        headers: new Headers({
          'Authorization': 'Bearer ' + this.accessToken,
          'Content-Type': 'application/json'
        })
      })
        .then(r => {
          if (r.status === 401) {
            this.apiAuthError()
            throw new Error('Not authorized')
          }
          return r
        })
        .then(r => r.json())
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
      fetch('/api/invoice/info?invoice=' + this.invoice)
        .then(r => r.json())
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

<style>
h1, h2, h3 {
  font-weight: normal;
  margin-bottom: 10px;
}
</style>
