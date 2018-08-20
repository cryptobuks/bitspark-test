<template>
  <v-container class="bi-container" fill-height fluid>
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
  computed: {
    ...mapGetters(['transactions'])
  }
}
</script>

<style scoped>
@media (max-width: 960px) {
  .bi-container {
    margin-top: 104px;
  }
}
</style>