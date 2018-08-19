<template>
  <v-form class="bi-form">
    <v-flex xs12 text-xs-right>
      <h1>ReviewForm</h1>
      {{payment}}
    </v-flex>
    <!-- <BottomButton :label="'Send'" :onClick="handleSendClick" /> -->
  </v-form>
</template>

<script>
export default {
  name: 'ReviewForm',
  props: ['payment']
}
</script>

<style scoped>
.bi-form {
  width: 100%;
  padding: 0px 22px;
}
</style>
