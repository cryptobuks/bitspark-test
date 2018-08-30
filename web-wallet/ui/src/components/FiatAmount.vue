<template>
  <span v-if="amount !== undefined">
    <span class="unit grey--text" v-bind:class="{ 'medium': medium, 'small': small }">{{ currency }}</span>
    <span class="amount darkGrey--text" v-bind:class="{ 'medium': medium, 'small': small }">{{ amount.toFixed(2) }}</span>
  </span>
  <span v-else class="unit">{{ emptyString }}</span>
</template>

<script>
const EMPTY_STRING = '- - -'

export default {
  props: ['amount', 'currency', 'medium', 'small'],
  name: 'fiat-amount',
  data () {
    return {
      emptyString: EMPTY_STRING
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

.small {
  font-size: 11px;
}
</style>
