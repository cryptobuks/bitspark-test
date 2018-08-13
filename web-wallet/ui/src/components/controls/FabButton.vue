<template>
  <v-speed-dial v-if="this.user" fixed v-model="fab" :bottom="true" :right="true" :direction="'top'" :transition="'scale-transition'">
      <v-btn color="yellow" slot="activator" v-model="fab" fab>
        <v-icon>add</v-icon>
        <v-icon>close</v-icon>
      </v-btn>
      <v-btn fab dark small color="green"> 
        <v-icon class="bi-icon-send">arrow_upward</v-icon>
      </v-btn>
      <v-btn fab dark small color="red">
        <v-icon class="bi-icon-recieve">arrow_upward</v-icon>
      </v-btn>
      <v-btn fab dark small color="red">
        <v-icon class="bi-icon-recieve">arrow_upward</v-icon>
      </v-btn>
    </v-speed-dial>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'FabButton',
  data () {
    return {
      fab: false
    }
  },
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
.bi-icon-send {
  transform: rotate(225deg);
}
.bi-icon-recieve {
  transform: rotate(45deg);
}
</style>