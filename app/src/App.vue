<template>
  <the-header />
  <router-view />
</template>

<script>
import TheHeader from "./components/TheHeader.vue"

export default {
  components: { TheHeader },
}
</script>

<style scoped>
</style>