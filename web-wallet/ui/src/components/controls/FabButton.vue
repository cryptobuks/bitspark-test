<template>
  <v-btn v-if="this.user" color="yellow" absolute bottom right fab @click="handleOnCLick()">
    <v-icon>add</v-icon>
  </v-btn>  
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'FabButton',
  computed: {
    ...mapGetters(['user'])
  },
  methods: {
    handleOnCLick () {
      console.log('Handle on click.')
    }
  }
}
</script>

<style>
.btn--bottom.btn--absolute {
  bottom: 16px;
}
</style>