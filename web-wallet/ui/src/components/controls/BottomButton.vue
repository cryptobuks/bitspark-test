<template>
  <v-btn class="bi-bottom-button primary charcoalGrey--text" v-if="!this.bigScreen" large v-bind:class="{ 'disabled': actualDisabled }" @click="handleOnClick" :tabindex="tabindex" block>{{label}}</v-btn>
  <v-btn class="bi-bottom-button-big-screen charcoalGrey--text primary" mt-5 v-else large v-bind:class="{ 'disabled': actualDisabled }" @click="handleOnClick" :tabindex="tabindex">{{label}}</v-btn>
</template>

<script>
export default {
  name: 'BottomButton',
  props: ['label', 'onClick', 'disabled', 'tabindex'],
  data () {
    return {
      actualDisabled: this.disabled
    }
  },
  computed: {
    bigScreen () {
      return this.$vuetify.breakpoint.name === 'lg' || this.$vuetify.breakpoint.name === 'xl' || this.$vuetify.breakpoint.name === 'md'
    }
  },
  methods: {
    handleOnClick () {
      if (!this.actualDisabled) {
        this.actualDisabled = true
        this.onClick()
        setTimeout(function () {
          this.actualDisabled = false
        }.bind(this), 300)
      }
    }
  },
  watch: {
    disabled (newVal) {
      this.actualDisabled = newVal
    }
  }
}
</script>

<style scoped>
.bi-bottom-button {
  height: 56px;
  position: fixed;
  bottom: 0;
  right: 0;
  left: 0;
  margin: 0;
  border-radius: 0px;
  font-size: 17px;
  text-transform: uppercase;
}
.bi-bottom-button-big-screen {
  margin-top: 70px;
  min-width: 200px;
  font-size: 18px;
}
.disabled {
  opacity: 0.5;
}
</style>
