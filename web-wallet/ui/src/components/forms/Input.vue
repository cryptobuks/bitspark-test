<template>
  <div class="bi-input-container">
    <span class="bi-input-label charcoalGrey--text">
      {{label}}
    </span>
    <v-text-field slot="activator"></v-text-field>
    <v-tooltip slot="apendIcon" left>
      <v-icon small slot="activator" class="charcoalGrey--text">help</v-icon>
      <span>Hello</span>
    </v-tooltip>
  </div>
</template>

<script>
export default {
  name: 'Input',
  props: ['label']
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
  margin-top: 2px;
  margin-right: 10px;
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
