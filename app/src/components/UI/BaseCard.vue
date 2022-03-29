<template>
  <div class="card">
    <slot />
  </div>
</template>

<style scoped>
.card {
  border-radius: 15px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.25);
  color: white;
  /* padding: 2rem 4rem; */
  max-width: 100%;
}
</style>