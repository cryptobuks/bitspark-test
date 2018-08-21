<template>
  <v-form class="bi-form">
    <v-flex xs12 text-xs-right>
      <Input :value="sendTo" :label="'To:'" :type="'text'" :placeholder="'Email or Address'" :tooltip="'Email or Address tooltip'" @valueInput="handleSendToValue" />
      <Input :value="amount" :label="'BTC'" :type="'number'" :placeholder="'Amount'" :tooltip="'Amount tooltip'" @valueInput="handleAmountValue" />
    </v-flex>
    <v-layout row wrap>
      <v-flex xs9 text-xs-center>
        <p>AVAILABLE BALANCE: {{ btc }}BTC</p>
      </v-flex>
      <v-flex xs3 text-xs-center>
        <span class="charcoalGrey--text" @click="fillMax()">Max</span>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12 text-xs-center>
        <span class="settings-heading charcoalGrey--text" @click="advancedSettings()">Advanced Settings</span>
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
    btc () {
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
    advancedSettings () {
      console.log('Toggle advancedSettings')
    },
    handleReviewClick () {
      var payment = {
        sendTo: this.sendTo,
        amount: this.amount,
        description: '',
        expiresAfter: 86400
      }
      this.createPayment(payment)
      this.$router.push({ name: 'Review' })
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
.settings-heading  {
  margin-top: 10px;
}
</style>
