<template>
  <v-form class="bi-form">
    <v-flex xs12 text-xs-right>
      <Input :label="'To:'"/>
      <Input :label="'BTC'"/>
    </v-flex>
  </v-form>
</template>

<script>
import Input from '@/components/forms/Input'

export default {
  name: 'SendForm',
  components: {
    Input
  }
}
</script>

<style scoped>
.bi-form {
  width: 100%;
  padding: 0px 22px
}
</style>
