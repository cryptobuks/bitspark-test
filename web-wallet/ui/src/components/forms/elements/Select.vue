<template>
  <div class="bi-select-container">
    <v-select :items="items" v-model="actualItem" box @input="handleInput" :tabindex="tabindex"></v-select>
  </div>
</template>

<script>
export default {
  name: 'Select',
  props: ['items', 'item', 'tabindex'],
  data () {
    return {
      actualItem: this.item,
      actualItems: this.items
    }
  },
  methods: {
    handleInput () {
      this.$emit('valueInput', this.actualItem)
    }
  },
  watch: {
    item: function (newVal) {
      this.actualItem = newVal
    }
  }
}
</script>

<style focused>
.bi-select-container {
  margin: 0;
  padding: 2px 10px 4px 10px;
  width: initial;
  border-bottom: 1px solid #434350;
}
</style>
