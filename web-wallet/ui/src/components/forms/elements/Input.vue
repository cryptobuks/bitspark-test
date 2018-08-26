<template>
  <div class="bi-input-container">
    <span class="bi-input-label charcoalGrey--text">
      {{label}}
    </span>
    <v-text-field v-model="inputValue" slot="activator" v-bind:type="type" v-bind:placeholder="placeholder" @input="handleValueInput(inputValue)" :tabindex="tabindex"></v-text-field>
    <v-tooltip v-if="tooltip" slot="apendIcon" bottom max-width="300px">
      <v-icon small slot="activator" class="tooltip-icon charcoalGrey--text">help</v-icon>
      <span v-html="tooltip"></span>
    </v-tooltip>
  </div>
</template>

<script>
export default {
  name: 'Input',
  props: ['value', 'label', 'type', 'placeholder', 'tooltip', 'tabindex'],
  data () {
    return {
      inputValue: this.value
    }
  },
  methods: {
    handleValueInput () {
      this.$emit('valueInput', this.inputValue)
    }
  },
  watch: {
    value: function (newVal) {
      this.inputValue = newVal
    }
  }
}
</script>

<style focused>
.bi-input-label {
  font-size: 17px;
  margin: 2px 10px 0px 10px;
}
.bi-input-container {
  display: flex;
  margin-top: 35px;
  border-bottom: 1px solid #434350;
}
.tooltip-icon {
  cursor: pointer;
}
</style>

<style>
/* Vuetify overrides */
.input-group__details {
  display: none !important;
}
.input-group {
  padding: 0 !important;
}
.bi-input-container input {
  margin-bottom: 4px !important;
  text-align: right !important;
}
.bi-input-container i {
  margin-top: 8px !important;
  margin-left: 10px !important;
  font-size: 13px !important;
}
</style>
