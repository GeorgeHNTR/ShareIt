<template>
  <the-header />
  <router-view />
  <the-footer />
</template>

<script>
import TheHeader from "./components/TheHeader.vue"
import TheFooter from "./components/TheFooter.vue"

export default {
  components: { TheHeader, TheFooter },
}
</script>

<style>
html {
  width: 100vw;
  height: 100vh;
  background: rgb(2, 0, 36);
  background-image: linear-gradient(
    145deg,
    rgba(2, 0, 36, 1) 5%,
    rgba(60, 27, 247, 1) 50%,
    rgba(115, 0, 255, 1) 100%
  );
}
</style>