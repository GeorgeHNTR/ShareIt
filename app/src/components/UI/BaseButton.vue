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
  color: white;
  background-image: linear-gradient(
    315deg,
    rgba(81, 0, 140, 1) 25%,
    rgb(108, 37, 223) 100%
  );
  padding: 0.5rem 0.8rem;
  text-transform: capitalize;
  cursor: pointer;
  transition: all 200ms ease-in-out;
  text-align: center;
  text-decoration: none;
  border-radius: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
}
button {
  background-color: transparent;
  color: white;
  border-radius: 50px;
  padding: 0.5rem 0.8rem;
  border-color: white;
  text-transform: capitalize;
  cursor: pointer;
  transition: all 200ms ease-in-out;
}

a:hover,
button:hover {
  background-image: linear-gradient(
    315deg,
    rgba(255, 255, 255, 0.1) 0%,
    rgba(255, 255, 255, 0.1) 100%
  );
  text-shadow: 2px 2px #000000;
  transform: translateY(-5%);
}
</style>