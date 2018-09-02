<template>
  <v-container class="bi-container" fill-height fluid>
    <v-layout align-center justify-center>
      <div class="scroll-wrapper">
        <iframe class="bi-iframe" src="https://www.biluminate.com/faq?type=a"></iframe>
      </div>
      <FabButton />
    </v-layout>
  </v-container>
</template>

<script>
import FabButton from '@/components/controls/FabButton'

export default {
  name: 'Faq',
  components: {
    FabButton
  }
}
</script>

<style>
</style>
