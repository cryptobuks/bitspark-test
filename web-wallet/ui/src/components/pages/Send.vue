<template>
  <v-container class="bi-container" fluid>
    <v-layout align-center justify-center>
      <SendForm />
    </v-layout>
  </v-container>
</template>

<script>
import SendForm from '@/components/forms/SendForm'

export default {
  name: 'Send',
  components: {
    SendForm
  }
}
</script>

<style>
</style>
