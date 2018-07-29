<template>
  <div class="transactions">
    <Transaction v-for="transaction in transactions" v-bind:key="transaction.id" :transaction="transaction"></Transaction>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Transaction from '../history/Transaction'

export default {
  name: 'History',
  components: {
    Transaction
  },
  data () {
    return {
      transactions: {}
    }
  },
  created () {
    this.transactions = this.getTransactions()
  },
  methods: {
    ...mapGetters(['getTransactions'])
  }
}
</script>

<style>
</style>