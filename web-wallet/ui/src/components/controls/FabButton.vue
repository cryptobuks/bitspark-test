<template>
  <v-btn color="yellow" absolute bottom right fab @click="handleOnCLick()">
    <v-icon>add</v-icon>
  </v-btn>  
</template>

<script>
export default {
  name: 'FabButton',
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