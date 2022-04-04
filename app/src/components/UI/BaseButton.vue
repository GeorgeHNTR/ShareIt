<template>
  <button @click="go">
    <slot />
  </button>
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
  methods: {
    go() {
      if (this.to && this.to.startsWith("https://")) {
        window.location.href = this.to
      } else if (this.to) {
        this.$router.push(this.to)
      }
    },
  },
}
</script>

<style scoped>
button {
  background: linear-gradient(
    to right,
    rgb(33, 0, 43) 0,
    rgb(60, 0, 60) 75%
  );
  color: rgb(255, 255, 255);
  border-radius: 50px;
  padding: 0.6rem 1rem;
  cursor: pointer;
  text-transform: capitalize;
  transition: all 200ms ease-in-out;
  font-weight: bold;
  border: 2px solid white;
  display: flex;
  align-items: center;
  justify-content: center;
  text-shadow: 2px 2px #000000;
}

button:hover {
  transform: translateY(-7%);
}
</style>