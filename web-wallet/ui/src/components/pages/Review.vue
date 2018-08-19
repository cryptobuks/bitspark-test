<template>
  <v-container class="bi-container" fluid>
    <v-layout align-center justify-center>
      <ReviewForm />
    </v-layout>
  </v-container>
</template>

<script>
import ReviewForm from '@/components/forms/ReviewForm'

export default {
  name: 'Review',
  components: {
    ReviewForm
  }
}
</script>

<style>
</style>
