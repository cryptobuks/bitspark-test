<template>
  <div class="transaction">
    <v-icon x-large color="grey">account_circle</v-icon>
    <div class="transaction-info">
      <h2 class="mb-1">Dummy Heading</h2>
      <p>Transaction description</p>
      <TransactionState :state="transaction.state" />
    </div>
    <TransactionAmount :msatoshi="transaction.msatoshi"/>
  </div>
</template>

<script>
import TransactionAmount from '@/components/history/TransactionAmount'
import TransactionState from '@/components/history/TransactionState'

export default {
  name: 'name',
  components: {
    TransactionAmount,
    TransactionState
  },
  props: ['transaction']
}
</script>

<style>
.transaction {
  display: flex;
  align-items: flex-start;
  padding: 15px;
  border-bottom: 1px solid rgba(151, 151, 151, 0.2);
}
.transaction img {
  width: 45px;
  height: 45px;
  margin: 4px 10px;
}
.transaction-info {
  width: 100%;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  margin: 0 17px;
}
.transaction-info h2 {
  font-size: 17px;
  font-weight: bold !important;
  color: #545555;
  font-weight: normal;
}
.transaction-info p {
  text-transform: none;
  margin-bottom: 0;
  font-size: 12px;
  letter-spacing: 0.3px;
}
</style>