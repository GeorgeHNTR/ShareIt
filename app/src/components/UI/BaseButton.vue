<template>
  <button v-if="!link">
    <slot />
  </button>
  <router-link v-else :to="to">
    <slot />
  </router-link>
</template>

<script>
export default {
  props: {
    link: {
      type: Boolean,
      required: false,
      default: false,
    },
    to: {
      type: String,
      required: false,
    },
  },
}
</script>

<style scoped>
a {
  background: linear-gradient(
    to right,
    rgb(124, 20, 110) 0,
    rgb(36, 11, 54) 100%
  );
  color: rgb(255, 255, 255);
  padding: 0.5rem 0.8rem;
  cursor: pointer;
  transition: all 200ms ease-in-out;
  text-align: center;
  text-decoration: none;
  border-radius: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 0 8px 2px #ffffff;
}
button {
  background-color: transparent;
  color: white;
  border-radius: 50px;
  padding: 0.5rem 0.8rem;
  border: 2px solid white;
  text-transform: capitalize;
  cursor: pointer;
  transition: all 200ms ease-in-out;
}

a:hover {
  transform: translateY(-5%);
}
button:hover {
  background-image: linear-gradient(
    315deg,
    rgba(255, 255, 255, 0.1) 0%,
    rgba(255, 255, 255, 0.1) 100%
  );
  text-shadow: 1px 1px #000000;
  transform: translateY(-5%);
}
</style>