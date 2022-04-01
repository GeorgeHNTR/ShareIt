<template>
  <button class="common" v-if="!link">
    <slot />
  </button>
  <router-link class="common" v-else :to="to">
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
.common {
  background-image: linear-gradient(
    to right,
    rgb(90, 0, 60) 0,
    rgb(33, 0, 43) 75%
  );
  color: rgb(255, 255, 255);
  border-radius: 50px;
  padding: 0.5rem 0.8rem;
  cursor: pointer;
  text-transform: capitalize;
  transition: all 200ms ease-in-out;
}

a {
  text-align: center;
  text-decoration: none;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 0 8px 2px #ffffff;
}

button {
  font-weight: bold;
  border: 2px solid white;
}

a:hover {
  transform: translateY(-15%);
}
button:hover {
  text-shadow: 2px 2px #000000;
  transform: translateY(-7%);
}
</style>