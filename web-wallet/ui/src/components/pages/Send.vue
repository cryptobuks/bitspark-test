<template>
  <v-container class="bi-container" fluid>
    <v-layout align-center justify-center>
      <SendForm />
      <BottomButton :label="'Continue to Review'" :disabled="true" :onClick="handleRevieClick"/>
    </v-layout>
  </v-container>
</template>

<script>
import BottomButton from '@/components/controls/BottomButton'
import SendForm from '@/components/forms/SendForm'

export default {
  name: 'Send',
  components: {
    SendForm,
    BottomButton
  },
  methods: {
    handleRevieClick () {
      console.log('Handle review click.')
    }
  }
}
</script>

<style>
</style>
