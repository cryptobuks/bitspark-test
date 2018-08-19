<template>
  <v-container class="bi-container" fluid>
    <v-layout align-center justify-center>
      <ReviewForm v-if="showForm ==='review'" :payment="payment" />
      <SendForm v-else @goToReview="handleGoToReview" />
    </v-layout>
  </v-container>
</template>

<script>
import SendForm from '@/components/forms/SendForm'
import ReviewForm from '@/components/forms/ReviewForm'

export default {
  name: 'Send',
  data () {
    return {
      showForm: 'send',
      payment: {}
    }
  },
  components: {
    SendForm,
    ReviewForm
  },
  methods: {
    handleGoToReview (payment) {
      this.payment = payment
      this.showForm = 'review'
    }
  }
}
</script>

<style>
</style>
