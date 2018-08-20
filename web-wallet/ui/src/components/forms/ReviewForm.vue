<template>
  <v-layout align-center justify-space-between column fill-height fill-width>
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
    <div class="bi-amounts-container">
      <v-container pa-0 fluid>
        <v-layout row>
          <v-flex xs12 text-xs-center>
            <span>TOTAL (FEES INCLUDED)</span><br>
            <Amount :msatoshi="totalMsatoshi" :medium="true" />
          </v-flex>
        </v-layout>
        <v-layout row>
          <v-flex xs6 text-xs-center>
            <span>FEE INCLUDED</span>
          </v-flex>
          <v-flex xs6 text-xs-center>
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

export default {
  name: 'ReviewForm',
  components: {
    BottomButton,
    Amount
  },
  computed: {
    ...mapGetters(['user', 'payment']),
    totalMsatoshi () {
      return this.payment.amount * 100000000000
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
}
.bi-form {
  width: 100%;
  padding: 0px 22px;
}
.bi-contacts-container {
  width: 100%;
  margin-top: -50px;
  padding: 15px;
  background-color: #fafafa;
}
.bi-amounts-container {
  width: 100%;
  padding: 15px;
  background-color: #fafafa;
  margin-bottom: 56px;
}
.bi-contacts-container ul {
  background-color: #fafafa;
}
.bi-contacts-container i {
  font-size: 45px !important;
}
</style>
