<template>
  <base-card class="stat">
    <h3 class="stat-title">{{ text }}</h3>
    <div class="stat-value" @click="navigate">{{ value }}</div>
  </base-card>
</template>

<script>
export default {
  props: {
    text: {
      type: String,
      required: true,
    },
    value: {
      type: String,
      required: true,
    },
    link: {
      type: Boolean,
      required: false,
    },
    to: {
      type: String,
      required: false,
    },
  },
  methods: {
    navigate() {
      if (this.link) this.$router.push(this.to)
    },
  },
}
</script>


<style scoped>
.stat {
  display: grid;
  position: relative;
  grid-template-areas: "title title value";
  background-color: rgba(230, 15, 15, 0.185);
  min-width: 80%;
  max-width: 80%;
  height: 25%;
  /* box-shadow: 0 0 50px 20px rgba(0, 0, 0, 0.7); */
  transition: all 0.2s ease-in-out;
}

.stat:hover {
  transform: translateY(-2%);
}

.stat-title {
  grid-area: title;
  position: absolute;
  min-width: 100%;
  max-width: 100%;
  min-height: 100%;
  max-height: 100%;

  display: flex;
  align-items: center;
  justify-content: left;
  padding-left: 20%;
  font-size: 1.6rem;

  text-shadow: 3px 3px rgb(0, 0, 0);

  border-radius: 0 20px 20px 0;
}

.stat-value {
  text-align: center;
  cursor: pointer;
  grid-area: value;
  position: absolute;
  min-width: 100%;
  max-width: 100%;
  min-height: 100%;
  max-height: 100%;

  display: flex;
  align-items: center;
  justify-content: center;

  font-size: 1.6rem;
  font-weight: 600;
  text-shadow: 3px 3px rgb(0, 0, 0);
  background-color: rgba(28, 0, 0, 0.8);

  transition: all 0.2s ease-in-out;
}

.stat-value:hover {
  font-size: 1.8rem;
}
</style>
