<template>
  <v-form class="bi-form">
    <v-flex xs12 text-xs-right>
      <h1>ReviewForm</h1>
      {{payment}}
    </v-flex>
    <BottomButton :label="'Send'" :onClick="handleSendClick" />
  </v-form>
</template>

<script>
import BottomButton from '@/components/controls/BottomButton'

export default {
  name: 'ReviewForm',
  components: {
    BottomButton
  },
  props: ['payment'],
  methods: {
    handleSendClick () {
      console.log('handleSendClick')
    }
  }
}
</script>

<style scoped>
.bi-form {
  width: 100%;
  padding: 0px 22px;
}
</style>
