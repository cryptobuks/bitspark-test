<template>
  <v-container class="bi-container" fluid>
    <v-layout row wrap align-center justify-center text-xs-center>
      <div class="bi-confirmation-heading">
        <v-layout row wrap align-center justify-center text-xs-center>
          <v-flex xs12 mb-3>
            <v-icon v-if="isPending" class="mr-1 pending">schedule</v-icon>
            <v-icon v-else-if="isApproved" class="mr-1 approved">check_circle_outline</v-icon>
            <v-icon v-else class="mr-1 declined">block</v-icon>
          </v-flex>
          <v-flex xs12 mb-2>
            <span v-if="isPending" class="charcoalGrey--text">Transaction waiting to be accepted</span>
            <span v-else-if="isApproved" class="charcoalGrey--text">Transaction completed</span>
            <span v-else class="charcoalGrey--text">Transaction failed</span>
          </v-flex>
        </v-layout>
      </div>
      <v-flex xs12 class="bi-confirmation-info">
        <div v-if="isPending">
          <p class="charcoalGrey--text">Recipient has got 24hrs to accept this transaction.</p>
          <p class="charcoalGrey--text">You can see transaction status in your <span class="bi-link" @click="handleGoToHistory">history.</span></p>
        </div>
        <div v-else-if="isApproved">
          <p class="charcoalGrey--text">Recipient has received funds from you.</p>
          <p class="charcoalGrey--text">Transactions to email are processed via Lightning Network. They are instant and free.</p>
        </div>
        <div v-else>
          <p class="charcoalGrey--text">We’re receiving too many transactions at the moment.</p>
          <p class="charcoalGrey--text"><span class="bi-link" @click="handleTryAgain">Try again.</span></p>
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
  name: 'PaymentConfirmation',
  components: {
    BottomButton
  },
  computed: {
    ...mapGetters(['paymentResult']),
    isPending () {
      return this.paymentResult === 'pending' || this.paymentResult === 'initial'
    },
    isApproved () {
      return this.paymentResult === 'approved'
    }
  },
  mounted () {
    if (!this.paymentResult) {
      this.$router.push({ path: '/' })
    }
  },
  methods: {
    ...mapActions(['removePayment']),
    handleDoneClick () {
      this.removePayment()
      this.$router.push({ path: '/' })
    },
    handleTryAgain () {
      this.$router.push({ path: '/send' })
    },
    handleGoToHistory () {
      this.removePayment()
      this.$router.push({ path: '/history' })
    }
  }
}
</script>

<style scoped>
.bi-confirmation-heading {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  background-color: #fafafa;
  margin-top: -50px;
  padding: 25px;
  border-bottom: 1px solid #d1d1d1;
}
.bi-confirmation-heading i {
  font-size: 85px;
}
.bi-confirmation-info {
  padding: 50px;
}
.bi-confirmation-info p {
  font-size: 14px;
  text-transform: none;
}
.bi-link {
  text-decoration: underline;
  transition: color 0.3s;
}
.bi-link {
  color: #000
}
.approved {
  color: #417505 !important;
}
.pending {
  color: #f5a623 !important;
}
.declined {
  color: #d0021b !important;
}
</style>
