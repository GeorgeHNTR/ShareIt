<template>
  <div class="card">
    <slot />
  </div>
</template>

<style scoped>
.card {
  padding: 1.5rem 3rem;
  border-radius: 40px;
  box-shadow: 0 2px 10px 10px rgba(0, 0, 0, 0.6);
  color: white;
  max-width: 100%;
  text-overflow: ellipsis;
  overflow: hidden;
}
</style>