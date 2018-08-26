<template>
  <span v-if="msatoshi !== undefined">
    <span class="unit grey--text" v-bind:class="{ 'medium': medium }">{{ currency ? currency : 'BTC' }}</span>
    <span class="amount darkGrey--text" v-bind:class="{ 'medium': medium }">{{ btc }}</span>
  </span>
  <span v-else class="unit">{{ emptyString }}</span>
</template>

<script>
const EMPTY_STRING = '- - -'

export default {
  props: ['msatoshi', 'currency', 'medium'],
  name: 'amount',
  data () {
    return {
      emptyString: EMPTY_STRING
    }
  },
  computed: {
    btc: function () {
      if (this.currency === 'satoshi') {
        return this.msatoshi / 100000 // satoshi
      }
      if (this.currency === 'mBTC') {
        return this.msatoshi / 100000000 // mBTC
      } else { // BTC
        return this.msatoshi / 100000000000
      }
    }
  }
}
</script>

<style scoped>
.unit {
  text-transform: none;
  font-size: 42px;
  font-weight: normal;
  margin-right: 5px;
}
.amount {
  font-size: 42px;
  font-weight: normal;
}
.medium {
  font-size: 37px;
}
</style>
