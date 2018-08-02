<template>
  <div class="transactions">
    <Transaction v-for="transaction in transactions" v-bind:key="transaction.id" :transaction="transaction"></Transaction>
    <FabButton />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import FabButton from '../controls/FabButton'
import Transaction from '../history/Transaction'

export default {
  name: 'History',
  components: {
    Transaction,
    FabButton
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