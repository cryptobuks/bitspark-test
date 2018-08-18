<template>
  <v-container class="bi-container" fill-height fluid>
    <v-layout align-center justify-center>
      <BottomButton :label="'Continue to Review'" :disabled="true" :onClick="handleRevieClick"/>
    </v-layout>
  </v-container>
</template>

<script>
import BottomButton from '@/components/controls/BottomButton'

export default {
  name: 'Send',
  components: {
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
