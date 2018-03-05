<template>
  <div class="pay-invoice">
    <h1>Pay Invoice</h1>
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
    <p v-else-if="isPayed">Success</p>
    <!-- Show invoice -->
    <div v-else>
      <h3>Description</h3>
      <p>{{ invoicePayload.description }}</p>
      <h3>Price</h3>
      <p>{{ invoicePayload.msatoshi }}</p>

      <v-btn v-if="!user" v-on:click="doLogin">Login</v-btn>
      <div v-else>
        <v-btn flat color="blue" v-on:click="processPayment">PAY</v-btn>
        <v-btn flat color="orange">CANCEL</v-btn>
      </div>
    </div>
  </div>
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
