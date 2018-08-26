<template>
  <v-form class="bi-form">
    <v-flex xs12 text-xs-right>
      <Input :value="sendTo" :label="'To:'" :type="'text'" :placeholder="'Email or Address'" :tooltip="sendToTooltip" @valueInput="handleSendToValue" />
      <CurencySelect :currency="currency" :amount="amount" :placeholder="'Amount'" :tooltip="amountTooltip" @valueInput="handleAmountValue" />
    </v-flex>
    <v-layout row wrap>
      <v-flex xs9 text-xs-center>
        <p>AVAILABLE BALANCE: {{ btc }}BTC</p>
      </v-flex>
      <v-flex xs3 text-xs-center>
        <span class="charcoalGrey--text" @click="fillMax()">Max</span>
      </v-flex>
    </v-layout>
    <v-layout row wrap mt-5>
      <v-flex xs12 text-xs-center>
        <Select :items="expiringItems" :item="expiringActualItem" @valueInput="handleExpiringValue" />
        <Input :value="description" :label="'Description:'" :type="'text'" :placeholder="'Optional'" @valueInput="handleDescriptionValue" />
      </v-flex>
    </v-layout>
    <BottomButton :label="'Continue to Review'" :disabled="!isValid" :onClick="handleReviewClick" />
    <AvailableBalanceModal :show="showAvailableBalanceModal" @handleAvailableBalanceModal="handleAvailableBalanceModal" />
    <ValidationError v-if="this.errors.length > 0" :error="this.errors[0]" @hide="handleValidationErrorHide"/>
  </v-form>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import BottomButton from '@/components/controls/BottomButton'
import Input from '@/components/forms/elements/Input'
import Select from '@/components/forms/elements/Select'
import CurencySelect from '@/components/forms/elements/CurencySelect'
import AvailableBalanceModal from '@/components/forms/AvailableBalanceModal'
import ValidationError from '@/components/forms/ValidationError'

import expiringItems from './expiringItems.json'

export default {
  name: 'SendForm',
  data () {
    return {
      sendTo: '',
      amount: '',
      description: '',
      currency: 'BTC',
      sendToTooltip: '1. Email - Recipients with email address either get funds instantly (if they already have Biluminate account) or have to create Biluminate account and then the funds will be transfered. The email transfer has expiration that you can adjust in advanced settings. <br><br> 2. Address - Recipients with address will receive funds once the transaction is verified.',
      amountTooltip: 'View amount in crypto or FIAT currency and its available denominations.',
      showAvailableBalanceModal: false,
      expiresAfter: expiringItems[0].value,
      expiringItems: expiringItems,
      expiringActualItem: expiringItems[0],
      errors: []
    }
  },
  components: {
    Input,
    Select,
    CurencySelect,
    BottomButton,
    AvailableBalanceModal,
    ValidationError
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
      this.amount = value.amount
      this.currency = value.currency
    },
    handleDescriptionValue (value) {
      this.description = value
    },
    handleExpiringValue (value) {
      this.expiresAfter = value
    },
    fillMax () {
      this.showAvailableBalanceModal = true
    },
    handleAvailableBalanceModal (fillMax) {
      this.showAvailableBalanceModal = false
      if (fillMax) {
        this.currency = 'BTC'
        this.amount = this.btc
      }
    },
    handleReviewClick () {
      var payment = {
        sendTo: this.sendTo,
        amount: this.amount,
        currency: this.currency,
        description: this.description,
        expiresAfter: this.expiresAfter
      }
      if (this.validateForm()) {
        this.createPayment(payment)
        this.$router.push({ name: 'Review' })
      }
    },
    handleValidationErrorHide () {
      this.errors = []
    },
    validateForm () {
      this.errors = []
      if (!this.validEmail(this.sendTo)) {
        this.errors.push('This is not a valid email address !!!')
      }
      if (!this.validAmount(this.amount)) {
        this.errors.push('Exceeding your available balance !!!')
      }
      if (!this.errors.length) {
        return true
      }
    },
    validEmail (email) {
      var re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      return re.test(email)
    },
    validAmount (amount) {
      if (this.currency === 'satoshi') {
        return amount < this.btc * 1000000 // satoshi
      }
      if (this.currency === 'mBTC') {
        return amount < this.btc * 1000 // mBTC
      }
      if (this.currency === 'BTC') {
        return amount < this.btc
      }
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
  max-width: 500px;
  text-align: center;
  margin-top: 50px;
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
.settings-heading {
  margin-top: 10px;
}
@media (max-width: 960px) {
  .bi-form {
    margin-top: 0;
  }
}
</style>