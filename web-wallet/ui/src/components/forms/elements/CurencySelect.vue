<template>
  <div class="bi-select-combined-container">
    <div class="bi-select-container">
      <v-select :items="currencies" v-model="actualCurrency" box @input="handleCurrencyInput"></v-select>
    </div>
    <div class="bi-input-combined-container">
      <v-text-field v-model="actualAmount" slot="activator" type="number" v-bind:placeholder="placeholder" @input="handleValueInput"></v-text-field>
      <v-tooltip v-if="tooltip" slot="apendIcon" bottom max-width="300px">
        <v-icon small slot="activator" class="tooltip-cion charcoalGrey--text">help</v-icon>
        <span v-html="tooltip"></span>
      </v-tooltip>
    </div>
  </div>
</template>

<script>
import Input from '@/components/forms/elements/Input'

export default {
  name: 'CurencySelect',
  components: {
    Input
  },
  props: ['amount', 'currency', 'placeholder', 'tooltip'],
  data () {
    return {
      actualAmount: this.amount,
      actualCurrency: this.currency,
      currencies: ['BTC', 'mBTC', 'satoshi']
    }
  },
  methods: {
    handleValueInput () {
      this.$emit('valueInput', { currency: this.actualCurrency, amount: this.actualAmount })
    },
    handleCurrencyInput () {
      this.$emit('valueInput', { currency: this.actualCurrency, amount: this.actualAmount })
    }
  },
  watch: {
    amount: function (newVal) {
      this.actualAmount = newVal
    },
    currency: function (newVal) {
      this.actualCurrency = newVal
    }
  }
}
</script>

<style focused>
.bi-input-label {
  font-size: 17px;
  margin: 2px 10px 0px 10px;
}
.bi-select-combined-container {
  display: flex;
  margin-top: 35px;
  border-bottom: 1px solid #434350;
}
.bi-select-container {
  margin: 2px 10px 0px 10px;
  width: 100px;
}
.bi-input-combined-container {
  display: flex;
  margin-top: 0px;
}
.tooltip-cion {
  cursor: pointer;
}
</style>

<style>
/* Vuetify overrides */
.input-group__selections__comma {
  font-size: 17px !important;
}
.bi-input-combined-container input {
  margin-bottom: 4px !important;
  text-align: right !important;
}
.bi-input-combined-container i {
  margin-top: 8px !important;
  margin-left: 10px !important;
  font-size: 13px !important;
}
</style>
