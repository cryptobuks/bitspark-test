<template>
  <div class="transaction-state">
    <span v-if="state === 'approved'" class="approved">
      <!--  <v-icon class="mr-1">check_circle_outline</v-icon>  --> Completed
    </span>
    <span v-else-if="state === 'declined'" class="declined">
      <!-- <v-icon class="mr-1">block</v-icon> --> Declined 
    </span>
    <span v-else class="pending">
      <!--  <v-icon class="mr-1">schedule</v-icon>  --> Transaction Pending
    </span>
  </div>
</template>

<script>
export default {
  name: 'TransactionState',
  props: ['state']
}
</script>

<style>
.transaction-state span {
  text-transform: uppercase;
  display: flex;
  align-items: center;
  font-size: 10px;
}
.transaction-state i {
  font-size: 15px;
}
.transaction-state span.approved, .transaction-state .approved i {
  color: #417505 !important;
}
.transaction-state span.pending, .transaction-state .pending i {
  color: #f5a623 !important;
}
.transaction-state span.declined, .transaction-state .declined i {
  color: #d0021b !important;
}
</style>
