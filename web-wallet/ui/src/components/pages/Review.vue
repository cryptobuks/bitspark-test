<template>
  <v-container class="bi-container" fluid>
    <ReviewForm />
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

<style scoped>
</style>
