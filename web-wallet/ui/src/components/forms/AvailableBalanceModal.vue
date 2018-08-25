<template>
  <v-dialog v-model="show" width="300" class="bi-dialog">
    <v-card>
      <v-card-text class="bi-card-text">Use all your available balance?</v-card-text>
      <v-card-actions class="bi-buttons">
        <v-btn color="purplishGrey darken-1" flat="flat" @click="handleClose(false)">
          Disagree
        </v-btn>
        <v-btn color="blue darken-1" flat="flat" @click="handleClose(true)">
          Agree
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  name: 'AvailableBalanceModal',
  props: ['show'],
  methods: {
    handleClose (value) {
      this.$emit('handleAvailableBalanceModal', value)
    }
  }
}
</script>

<style scoped>
.bi-card-text {
  padding: 23px;
  margin-bottom: 20px;
}
.bi-buttons {
  justify-content: space-between;
}
</style>
