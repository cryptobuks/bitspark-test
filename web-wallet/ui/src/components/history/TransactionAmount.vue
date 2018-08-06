<template>
  <span v-bind:class="{ '': mbtc > 0 }" class="transaction-amount">{{ mbtc }}</span>
</template>

<script>
export default {
  name: 'TransactionAmount',
  props: ['msatoshi'],
  computed: {
    mbtc: function () {
      return this.msatoshi / 100000000
    }
  }
}
</script>

<style>
.transaction-amount {
  font-weight: bold;
  font-size: 17px;
  max-width: 73px;
  color: #d0021b;
}
.transaction-amount.positive {
  color: #417505;
}
</style>
