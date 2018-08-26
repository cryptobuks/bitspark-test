<template>
  <div class="validation-error animated" v-bind:class="{'fadeInUp': fadeInUp, 'fadeOutDown': !fadeInUp }">
    <span>{{error}}</span>
  </div>
</template>

<script>
export default {
  name: 'ValidationError',
  props: ['error'],
  data () {
    return {
      fadeInUp: true
    }
  },
  mounted () {
    document.addEventListener('click', this.hide)
  },
  methods: {
    hide () {
      this.fadeInUp = false
      setTimeout(() => {
        this.$emit('hide')
        this.fadeInUp = true
      }, 500)
    }
  }
}
</script>

<style scoped>
.validation-error {
  position: fixed;
  bottom: 60px;
  left: 0;
  right: 0;
  margin: 20px 30px;
  padding: 10px 20px;
  border-radius: 4px;
  background: #4a4a4a;
  color: #fff;
  transition: 
}

.animated {
  -webkit-animation-duration: 0.3s;
  animation-duration: 0.3s;
  -webkit-animation-fill-mode: both;
  animation-fill-mode: both;
}
@keyframes fadeInUp {
  from {
    opacity: 0;
    -webkit-transform: translate3d(0, 100%, 0);
    transform: translate3d(0, 100%, 0);
  }

  to {
    opacity: 1;
    -webkit-transform: translate3d(0, 0, 0);
    transform: translate3d(0, 0, 0);
  }
}
.fadeInUp {
  -webkit-animation-name: fadeInUp;
  animation-name: fadeInUp;
}
@keyframes fadeOutDown {
  from {
    opacity: 1;
  }

  to {
    opacity: 0;
    -webkit-transform: translate3d(0, 100%, 0);
    transform: translate3d(0, 100%, 0);
  }
}
.fadeOutDown {
  -webkit-animation-name: fadeOutDown;
  animation-name: fadeOutDown;
}
</style>
