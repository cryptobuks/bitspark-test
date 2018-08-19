<template>
  <v-form class="bi-form">
    <v-flex xs12 text-xs-right>
      <Input :label="'To:'" />
      <Input :label="'BTC'" />
    </v-flex>
    <v-layout row wrap>
      <v-flex xs9 text-xs-center>
        <p>AVAILABLE BALANCE: {{ mbtc }}BTC</p>
      </v-flex>
      <v-flex xs3 text-xs-center>
        <span class="charcoalGrey--text" @click="fillMax()">Max</span>
      </v-flex>
    </v-layout>
  </v-form>
</template>

<script>
import { mapGetters } from 'vuex'
import Input from '@/components/forms/Input'

export default {
  name: 'SendForm',
  components: {
    Input
  },
  computed: {
    ...mapGetters(['balance']),
    mbtc () {
      if (this.balance && this.balance.msatoshi) {
        return this.balance.msatoshi / 100000000000
      }
    }
  },
  methods: {
    fillMax () {
      console.log('Handle fillMax')
    }
  }
}
</script>

<style scoped>
.bi-form {
  width: 100%;
  padding: 0px 22px;
}
p, span {
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
