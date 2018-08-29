<template>
  <div class="transaction-amount">
    <span class="transaction-amount-money" v-bind:class="{ 'positive': mbtc > 0 }">{{ mbtc }}</span>
    <span>mBTC</span>
  </div>
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

<style scoped>
.transaction-amount {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  max-width: 73px;
}
.transaction-amount-money {
  font-weight: bold;
  font-size: 17px;
  color: #d0021b;
}
.transaction-amount-money.positive {
  color: #417505;
}
</style>
