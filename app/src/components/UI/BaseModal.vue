<template>
  <base-card class="modal">
    <slot />
  </base-card>
</template>

<style scoped>
.modal {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translateX(-50%) translateY(-50%);
  width: 50vw;
  height: 50vh;
}
</style>