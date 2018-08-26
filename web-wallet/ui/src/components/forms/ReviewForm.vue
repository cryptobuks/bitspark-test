<template>
  <v-layout align-center justify-center column class="bi-form">
    <div class="bi-review-form">
      <div class="bi-contacts-container">
        <v-flex xs12>
          <v-list>
            <v-list-tile avatar>
              <v-list-tile-avatar>
                <v-icon v-if="!this.user.picture" x-large class="bi-icon">account_circle</v-icon>
                <img v-else v-bind:src="this.user.picture" />
              </v-list-tile-avatar>
              <v-list-tile-content>
                <v-list-tile-title class="bi-name">{{this.user.name}} (You)</v-list-tile-title>
              </v-list-tile-content>
            </v-list-tile>
          </v-list>
        </v-flex>
        <v-flex xs12>
          <v-list>
            <v-list-tile avatar>
              <v-list-tile-avatar>
                <v-icon x-large class="bi-icon">account_circle</v-icon>
              </v-list-tile-avatar>
              <v-list-tile-content>
                <v-list-tile-title class="bi-name">{{payment.sendTo}}</v-list-tile-title>
              </v-list-tile-content>
            </v-list-tile>
          </v-list>
        </v-flex>
      </div>
      <div class="bi-settings-container">
        <v-container pa-0 fluid>
          <v-layout row mb-3>
            <v-flex xs4 text-xs-left>
              <span>Expiration</span>
            </v-flex>
            <v-flex xs8 text-xs-right>
              <span class="bi-settings-span charcoalGrey--text">{{expire}}</span>
            </v-flex>
          </v-layout>
          <v-layout row>
            <v-flex xs4 text-xs-left>
              <span>Description</span>
            </v-flex>
            <v-flex xs8 text-xs-right>
              <span class="bi-settings-span charcoalGrey--text">{{description}}</span>
            </v-flex>
          </v-layout>
        </v-container>
      </div>
    </div>
    <div class="bi-amounts-container">
      <v-container pa-0 fluid>
        <v-layout row>
          <v-flex xs12 ml-3 mr-3 text-xs-center class="bi-bordered">
            <span>TOTAL (FEES INCLUDED)</span><br>
            <Amount :currency="payment.currency" :msatoshi="totalMsatoshi" :medium="true" />
          </v-flex>
        </v-layout>
        <v-layout row pb-2>
          <v-flex xs6 pt-2 text-xs-center class="bi-border-right">
            <span>FEE INCLUDED</span>
            <br>
            <span class="darkGrey--text bold">Free</span>
          </v-flex>
          <v-flex xs6 pt-2 text-xs-center>
            <span>TOTAL FIAT VALUE</span>
          </v-flex>
        </v-layout>
      </v-container>
    </div>
    <BottomButton :label="'Send'" :onClick="handleSendClick" />
  </v-layout>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import BottomButton from '@/components/controls/BottomButton'
import Amount from '@/components/Amount'

import expiringItems from './expiringItems.json'
const EMPTY_STRING = '- - -'

export default {
  name: 'ReviewForm',
  components: {
    BottomButton,
    Amount
  },
  computed: {
    ...mapGetters(['user', 'payment']),
    expire () {
      var expiresAfter = expiringItems.find(item => item.value === this.payment.expiresAfter)
      return expiresAfter ? expiresAfter.text : EMPTY_STRING
    },
    description () {
      var description = this.payment.description
      return description || EMPTY_STRING
    },
    totalMsatoshi () {
      if (this.payment.currency === 'BTC') {
        return this.payment.amount * 100000000000
      }
      if (this.payment.currency === 'mBTC') {
        return this.payment.amount * 100000000
      }
      if (this.payment.currency === 'satoshi') {
        return this.payment.amount * 100000
      }
    }
  },
  methods: {
    ...mapActions(['processToEmailPayment']),
    handleSendClick () {
      var payment = {
        to_email: this.payment.sendTo,
        msatoshi: this.totalMsatoshi,
        description: this.payment.description,
        expires_after: this.payment.expiresAfter
      }
      console.log(payment)
      this.processToEmailPayment(payment)
    }
  }
}
</script>

<style scoped>
span {
  font-size: 11px;
  text-transform: uppercase;
}
.bi-review-form {
  width: 100%;
}
.bi-form {
  width: 100%;
  max-width: 500px;
  margin: auto;
  margin-top: 50px;
  text-align: center;
  padding: 0px 22px;
}
.bi-contacts-container {
  width: 100%;
  margin-top: -50px;
  padding: 15px;
  background-color: #fafafa;
}
.bi-settings-container {
  margin: 5px 15px;
  padding: 15px;
  background-color: #fff;
}
.bi-settings-span {
  font-size: 14px;
}
.bi-amounts-container {
  width: 100%;
  padding: 15px;
  background-color: #fafafa;
  margin-bottom: 56px;
}
.bi-amounts-container .bi-bordered {
  border-bottom: 1px solid #c6c6c6;
}
.bi-amounts-container .bold {
  font-weight: 600;
}
.bi-amounts-container .bi-border-right {
  border-right: 1px solid #c6c6c6;
}
.bi-contacts-container ul {
  background-color: #fafafa;
}
.bi-contacts-container i {
  font-size: 45px !important;
}
@media (max-width: 960px) {
  .bi-form {
    margin-top: 0;
    padding: 0;
    height: 100%;
    max-width: none;
    justify-content: space-between;
  }
}
</style>
