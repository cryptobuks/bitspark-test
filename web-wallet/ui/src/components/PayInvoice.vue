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
    <!-- Show invoice -->
    <div v-else>
      <h3>Description</h3>
      <p>{{ invoicePayload.description }}</p>
      <h3>Price</h3>
      <p>{{ invoicePayload.msatoshi }}</p>

      <v-btn flat color="blue">PAY</v-btn>
      <v-btn flat color="orange">CANCEL</v-btn>
    </div>
  </div>
</template>

<script>
export default {
  props: ['invoice'],
  name: 'pay-invoice',
  data () {
    return {
      apiError: undefined,
      invoicePayload: undefined
    }
  },
  computed: {
    isLoading: function () {
      return !this.invoicePayload
    }
  },
  created () {
    fetch('/api/invoice-info?invoice=' + this.invoice)
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
</script>

<style>
h1, h2, h3 {
  font-weight: normal;
  margin-bottom: 10px;
}
</style>
