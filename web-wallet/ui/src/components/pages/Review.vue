<template>
  <v-container class="bi-container" fluid>
    <ReviewForm />
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
import ReviewForm from '@/components/forms/ReviewForm'

export default {
  name: 'Review',
  components: {
    ReviewForm
  },
  computed: {
    ...mapGetters(['payment'])
  },
  mounted () {
    if (!this.payment) {
      this.$router.push({ path: '/' })
    }
  }
}
</script>

<style scoped>
</style>
