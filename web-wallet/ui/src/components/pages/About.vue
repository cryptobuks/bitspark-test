<template>
  <v-container class="bi-container" fill-height fluid>
    <v-layout align-center justify-center>
      <iframe class="bi-iframe" src="https://www.biluminate.com/about?type=a"></iframe>
      <FabButton />
    </v-layout>
  </v-container>
</template>

<script>
import FabButton from '@/components/controls/FabButton'

export default {
  name: 'About',
  components: {
    FabButton
  }
}
</script>

<style>
</style>
