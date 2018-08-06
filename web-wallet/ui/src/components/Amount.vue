<template>
  <span v-if="msatoshi !== undefined">
    <span class="unit grey--text">mBTC</span>
    <span class="amount darkGrey--text">{{ mbtc }}</span>
  </span>
  <span v-else>Unknown</span>
</template>

<script>
export default {
  props: ['msatoshi'],
  name: 'amount',
  computed: {
    mbtc: function () {
      return this.msatoshi / 100000000
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
