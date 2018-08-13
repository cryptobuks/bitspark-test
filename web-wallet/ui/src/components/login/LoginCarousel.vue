<template>
  <v-carousel hide-controls dark interval="10000" class="bi-carousel">
    <v-carousel-item>
      <v-container fluid>
        <v-layout align-top justify-center text-xs-left>
          <v-flex xs4>
            <img class="carousel-img" src="/static/img/carousel/fast.svg">
          </v-flex>
          <v-flex xs8 class="white--text">
            <h3>Fast</h3>
            <p>Send money in milliseconds. No need to wait for confirmations.</p>
          </v-flex>
        </v-layout>
      </v-container>
    </v-carousel-item>
    <v-carousel-item>
      <v-container fluid>
        <v-layout align-top justify-center text-xs-left>
          <v-flex xs4>
            <img class="carousel-img" src="/static/img/carousel/fast.svg">
          </v-flex>
          <v-flex xs8 class="white--text">
            <h3>Slow</h3>
            <p>Send money in hours. No need to wait for confirmations.</p>
          </v-flex>
        </v-layout>
      </v-container>
    </v-carousel-item>
    <v-carousel-item>
      <v-container fluid>
        <v-layout align-top justify-center text-xs-left>
          <v-flex xs4>
            <img class="carousel-img" src="/static/img/carousel/fast.svg">
          </v-flex>
          <v-flex xs8 class="white--text">
            <h3>Fast</h3>
            <p>Send money in milliseconds. No need to wait for confirmations.</p>
          </v-flex>
        </v-layout>
      </v-container>
    </v-carousel-item>
    <v-carousel-item>
      <v-container fluid>
        <v-layout align-top justify-center text-xs-left>
          <v-flex xs4>
            <img class="carousel-img" src="/static/img/carousel/fast.svg">
          </v-flex>
          <v-flex xs8 class="white--text">
            <h3>Slow</h3>
            <p>Send money in hours. No need to wait for confirmations.</p>
          </v-flex>
        </v-layout>
      </v-container>
    </v-carousel-item>
  </v-carousel>
</template>

<script>
export default {
  name: 'LoginCarousel'
}
</script>
 
<style>
.bi-carousel {
  height: 200px;
  box-shadow: none;
}
.carousel__controls {
  background: none;
}
.bi-carousel .btn--icon.btn--small {
  width: 5px;
  height: 5px;
}
.bi-carousel .btn--icon.btn--small i {
  font-size: 13px !important;
}
.carousel-img {
  width: 63px;
  height: 63px;
}
.bi-carousel h3 {
  font-size: 17px;
  margin-bottom: 8px;
}
.bi-carousel p {
  text-transform: none;
}
</style>