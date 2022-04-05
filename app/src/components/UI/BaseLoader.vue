<template>
  <div class="backdrop">Loading...</div>
</template>

<style scoped>
.backdrop {
  background-color: rgba(0, 0, 0, 0.92);
  position: absolute;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 10;
  color: white;
  font-size: 4rem;
  text-shadow: 0 0 20px rgb(0, 0, 0);
}
</style>