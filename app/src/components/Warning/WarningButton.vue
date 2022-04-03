<template>
  <base-button class="btn">!</base-button>
</template>

<style scoped>
.btn {
  cursor: default;
  width: 3rem;
  height: 3rem;
  font-size: 1.8rem;
  transition: all 0.2s ease-in-out;
}

.btn:hover {
  width: 2.8rem;
  height: 2.8rem;
  font-size: 2rem;
  transform: translateX(-1px) translateY(1px);
}
</style>