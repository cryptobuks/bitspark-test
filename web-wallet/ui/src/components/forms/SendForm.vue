<template>
  <v-form class="bi-form">
    <v-flex xs12 text-xs-right>
      <Input :value="sendTo" :label="'To:'" @valueInput="handleSendToValue" />
      <Input :value="amount" :label="'BTC'" @valueInput="handleAmountValue" />
    </v-flex>
    <v-layout row wrap>
      <v-flex xs9 text-xs-center>
        <p>AVAILABLE BALANCE: {{ mbtc }}BTC</p>
      </v-flex>
      <v-flex xs3 text-xs-center>
        <span class="charcoalGrey--text" @click="fillMax()">Max</span>
      </v-flex>
    </v-layout>
    <BottomButton :label="'Continue to Review'" :disabled="!isValid" :onClick="handleReviewClick" />
  </v-form>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import BottomButton from '@/components/controls/BottomButton'
import Input from '@/components/forms/Input'

export default {
  name: 'SendForm',
  data () {
    return {
      sendTo: '',
      amount: ''
    }
  },
  components: {
    Input,
    BottomButton
  },
  computed: {
    ...mapGetters(['balance']),
    mbtc () {
      if (this.balance && this.balance.msatoshi) {
        return this.balance.msatoshi / 100000000000
      }
    },
    isValid () {
      return !this.isEmptyString(this.sendTo) && !this.isEmptyString(this.amount)
    }
  },
  methods: {
    ...mapActions(['createPayment']),
    handleSendToValue (value) {
      this.sendTo = value
    },
    handleAmountValue (value) {
      this.amount = value
    },
    fillMax () {
      console.log('Handle fillMax')
    },
    handleReviewClick () {
      var payment = {
        sendTo: this.sendTo,
        amount: this.amount,
        description: '',
        expiresAfter: '86400'
      }
      this.createPayment(payment)
    },
    isEmptyString (string) {
      return (!string || string.length === 0)
    }
  }
}
</script>

<style scoped>
.bi-form {
  width: 100%;
  padding: 0px 22px;
}
p,
span {
  display: block;
  font-size: 11px;
  margin-top: 35px;
}
span {
  cursor: pointer;
  text-transform: uppercase;
  text-decoration: underline;
}
</style>
