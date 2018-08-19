<template>
  <div class="bi-input-container">
    <span class="bi-input-label charcoalGrey--text">
      {{label}}
    </span>
    <v-text-field v-model="inputValue" slot="activator" v-bind:type="type" v-bind:placeholder="placeholder" @input="handleValueInput(inputValue)"></v-text-field>
    <v-tooltip slot="apendIcon" bottom>
      <v-icon small slot="activator" class="charcoalGrey--text">help</v-icon>
      <span>{{tooltip}}</span>
    </v-tooltip>
  </div>
</template>

<script>
export default {
  name: 'Input',
  props: ['value', 'label', 'type', 'placeholder', 'tooltip'],
  data () {
    return {
      inputValue: this.value
    }
  },
  methods: {
    handleValueInput () {
      this.$emit('valueInput', this.inputValue)
    }
  }
}
</script>

<style focused>
.input-group__details {
  display: none;
}
.input-group {
  padding: 0;
}
.bi-input-label {
  font-size: 17px;
  margin: 2px 10px 0px 10px;
}
.bi-input-container {
  display: flex;
  margin-top: 35px;
  border-bottom: 1px solid #434350;
}
.bi-input-container input {
  margin-bottom: 4px;
  text-align: right;
}
.bi-input-container i {
  margin-top: 8px;
  margin-left: 10px;
  font-size: 13px !important;
}
</style>
