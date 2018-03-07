<template>
  <span v-if="msatoshi !== undefined">{{ mbtc }} mBTC</span>
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