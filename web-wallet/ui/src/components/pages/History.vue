<template>
  <v-container class="transactions" fill-height fluid>
      <v-layout align-center justify-center>
        <v-flex xs12 lg6>
          <Transaction v-for="transaction in transactions" v-bind:key="transaction.id" :transaction="transaction"></Transaction>
          <FabButton />
        </v-flex>
      </v-layout>
  </v-container>
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
.transactions {
    padding: 0;
}
</style>