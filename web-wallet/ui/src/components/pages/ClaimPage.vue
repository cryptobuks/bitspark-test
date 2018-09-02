<template>
  <v-container class="bi-container bi-claim" fluid>
    <v-layout row wrap align-center justify-center text-xs-center>
      <div class="bi-claim-heading">
        <v-layout row wrap align-center justify-center text-xs-center>
          <v-flex xs12 mb-3>
            <v-icon v-if="isApproved" class="mr-1 approved">check_circle_outline</v-icon>
            <v-icon v-else class="mr-1 declined">block</v-icon>
          </v-flex>
          <v-flex xs12 mb-2>
            <span v-if="isApproved" class="charcoalGrey--text">Transaction completed</span>
            <span v-else class="charcoalGrey--text">Transaction expired</span>
          </v-flex>
        </v-layout>
      </div>
      <v-flex xs12 class="bi-claim-info">
        <div v-if="isApproved">
          <p class="charcoalGrey--text">You have recieved your funds from recipient.</p>
          <p class="charcoalGrey--text">Transactions to email were processed via Lightning Network. They are instant and free.</p>
        </div>
        <div v-else>
          <p class="charcoalGrey--text">Transaction has already expired.</p>
        </div>
      </v-flex>
      <BottomButton :label="'Done'" :onClick="handleDoneClick" :tabindex="1" />
    </v-layout>
  </v-container>
</template>

<script>
import BottomButton from '@/components/controls/BottomButton'
import { mapGetters, mapActions } from 'vuex'

export default {
  name: 'ClaimPage',
  components: {
    BottomButton
  },
  computed: {
    ...mapGetters(['claimResult']),
    isApproved () {
      return this.claimResult && this.claimResult.state === 'approved'
    }
  },
  mounted () {
    this.claimToEmailPayment(this.$route.params.claimToken)
  },
  methods: {
    ...mapActions(['claimToEmailPayment', 'removeClaimResult']),
    handleDoneClick () {
      this.removeClaimResult()
      this.$router.push({ path: '/' })
    }
  }
}
</script>

<style scoped>
.bi-claim {
  max-width: 1264px;
}
.bi-claim-heading {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  background-color: #fafafa;
  margin-top: -50px;
  padding: 25px;
  border-bottom: 1px solid #d1d1d1;
}
.bi-claim-heading i {
  font-size: 85px;
}
.bi-claim-info {
  padding: 50px;
}
.bi-claim-info p {
  font-size: 14px;
  text-transform: none;
}
.approved {
  color: #417505 !important;
}
.declined {
  color: #d0021b !important;
}

@media (min-width: 1264px) {
  .bi-claim {
    max-width: 960px;
    margin: auto !important;
    margin-top: 140px !important;
  }
}
</style>
