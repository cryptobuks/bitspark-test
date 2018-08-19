<template>
  <span v-if="msatoshi !== undefined">
    <span class="unit grey--text">BTC</span>
    <span class="amount darkGrey--text">{{ btc }}</span>
  </span>
  <span v-else>Unknown</span>
</template>

<script>
export default {
  props: ['msatoshi'],
  name: 'amount',
  computed: {
    btc: function () {
      return this.msatoshi / 100000000000
    }
  }
}
</script>

<style>
.unit {
  font-size: 42px;
  font-weight: normal;
}
.amount {
  font-size: 42px;
  font-weight: normal;
}
</style>
