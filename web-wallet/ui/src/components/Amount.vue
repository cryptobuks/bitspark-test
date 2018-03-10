<template>
  <span v-if="msatoshi !== undefined"><strong class="display-2">{{ mbtc }}</strong> <span class="caption">mBTC</span></span>
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