<template>
  <div class="bi-overlay">
    <v-container fluid>
      <v-layout align-center justify-center text-xs-center>
        <v-flex xs12 lg6 md6 class="bi-overlay-content">
          <div class="bi-logo-container">
            <img class="bi-logo-bigger" alt="Biluminate" src="/static/img/biluminate-logo-slogan.svg">
          </div>
          <div class="bi-login-carousel">
            <LoginCarousel/>
          </div>
          <LoginButton/>
        </v-flex>
      </v-layout>
    </v-container>
  </div>
</template>

<script>
import LoginButton from '@/components/LoginButton'
import LoginCarousel from '@/components/login/LoginCarousel'

export default {
  name: 'LoginOverlay',
  components: {
    LoginButton,
    LoginCarousel
  }
}
</script>
 
<style scoped>
.bi-overlay {
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(180deg, #2e3654 0%, #563f61 100%);
}
.bi-overlay-content {
  flex-direction: column;
  align-items: flex-end;
}
.bi-logo-container {
  margin-top: 100px;
}
.bi-logo-bigger {
  width: 221px;
}
.bi-logo-container p {
  font-size: 10px;
  text-transform: uppercase;
  color: #fff;
}
.bi-login-carousel {
  max-width: 300px;
  margin: auto;
  margin-top: 200px;
}

@media (min-width: 960px) {
  .bi-logo-bigger {
    width: 296px;
  }
  .bi-logo-container p {
    font-size: 14px;
  }
} 
</style>