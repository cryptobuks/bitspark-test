<template>
  <span v-if="msatoshi !== undefined"><span class="unit">mBTC</span> <span class="amount">{{ mbtc }}</span></span>
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
    color: #ADADAD;
  }

  .amount {
    color: #4A4A4A;
  }
</style>
