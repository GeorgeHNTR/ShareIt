<template>
  <div class="card">
    <slot />
  </div>
</template>

<style scoped>
.card {
  background: linear-gradient(
    to right,
    rgba(59, 0, 66, 0.25) 0,
    rgba(48, 0, 0, 0.7) 90%
  );
  border-radius: 40px;
  box-shadow: 0 2px 10px 10px rgba(0, 0, 0, 0.6);
  color: white;
  max-width: 100%;
  text-overflow: ellipsis;
  overflow: hidden;
}
</style>