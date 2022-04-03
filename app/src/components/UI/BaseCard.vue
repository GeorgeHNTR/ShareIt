<template>
  <div class="card">
    <slot />
  </div>
</template>

<style scoped>
.card {
  border-radius: 40px;
  box-shadow: 0 2px 10px 10px rgba(0, 0, 0, 0.60);
  padding: 2rem;
  color: white;
  max-width: 100%;
  text-overflow: ellipsis;
  overflow: hidden;
}
</style>