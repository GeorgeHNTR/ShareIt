<template>
  <base-card class="b-card">
    <p>
      {{ message }}
    </p>
  </base-card>
</template>

<script>
export default {
  props: {
    message: {
      type: String,
      required: true,
    },
  },
}
</script>


<style scoped>
.b-card {
  width: 18%;
  height: auto;
  display: none;
  transition: all 0.5s ease-in-out;
  position: fixed;
  bottom: 13%;
  right: 4%;
  border: 1px solid white;
  background: linear-gradient(
    to right,
    rgba(59, 0, 66, 0.9) 0,
    rgba(48, 0, 0, 0.7) 90%
  ) !important;
}

p {
  text-align: center;
  font-size: 1.2rem;
}
</style>