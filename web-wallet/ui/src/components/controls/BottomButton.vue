<template>
  <v-btn class="bi-bottom-button primary charcoalGrey--text" v-if="!this.bigScreen" large v-bind:class="{ disabled: 'disabled' }" @click="handleOnClick" block>{{label}}</v-btn>
  <v-btn class="bi-bottom-button-big-screen charcoalGrey--text primary" mt-5 v-else large v-bind:class="{ disabled: 'disabled' }" @click="handleOnClick">{{label}}</v-btn>
</template>

<script>
export default {
  name: 'BottomButton',
  props: ['label', 'onClick', 'disabled'],
  computed: {
    bigScreen () {
      return this.$vuetify.breakpoint.name === 'lg' || this.$vuetify.breakpoint.name === 'xl' || this.$vuetify.breakpoint.name === 'md'
    }
  },
  methods: {
    handleOnClick () {
      if (!this.disabled) {
        this.onClick()
      }
    }
  }
}
</script>

<style scoped>
.bi-bottom-button {
  height: 56px;
  position: absolute;
  bottom: 0;
  right: 0;
  left: 0;
  margin: 0;
  border-radius: 0px;
  font-size: 17px;
  text-transform: uppercase;
}
.bi-bottom-button-big-screen {
  margin-top: 100px;
  min-width: 200px;
  font-size: 18px;
}
.disabled {
  opacity: 0.5;
}
</style>
