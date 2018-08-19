<template>
  <span v-if="msatoshi !== undefined">
    <span class="unit grey--text" v-bind:class="{ 'medium': medium }">BTC</span>
    <span class="amount darkGrey--text" v-bind:class="{ 'medium': medium }">{{ btc }}</span>
  </span>
  <span v-else>Unknown</span>
</template>

<script>
export default {
  props: ['msatoshi', 'medium'],
  name: 'amount',
  computed: {
    btc: function () {
      return this.msatoshi / 100000000000
    }
  }
}
</script>

<style scoped>
.unit {
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
