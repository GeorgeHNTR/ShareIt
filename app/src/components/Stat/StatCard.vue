<template>
  <base-card class="stat">
    <div class="stat-title">
      <h3>{{ text }}</h3>
    </div>
    <div :class="`stat-value ${link ? 'pointer' : ''}`" @click="navigate">
      <h3>{{ value }}</h3>
    </div>
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
      if (this.to) this.$router.push(this.to)
    },
  },
}
</script>


<style scoped>
.stat {
  min-width: 80%;
  max-width: 80%;
  display: flex;
  min-height: 20%;
  max-height: 20%;
  flex-direction: row;
  flex-wrap: nowrap;
  justify-content: space-around;
  align-items: stretch;
}

.stat-title {
  grid-area: title;
  min-width: 66.66%;
  max-width: 66.66%;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: space-evenly;
  flex-direction: column;
  flex-wrap: wrap;
  align-content: flex-start;
  overflow: hidden;
  background: linear-gradient(
    to right,
    rgba(59, 0, 66, 0.22) 35%,
    rgba(48, 0, 0, 0.9) 90%
  );
}

.stat-value {
  grid-area: value;
  min-width: 33.33%;
  max-width: 33.33%;
  display: flex;
  flex-direction: column;
  flex-wrap: wrap;
  justify-content: center;
  align-items: center;
  align-content: center;
}

.stat-title h3 {
  min-width: 70%;
  max-width: 70%;
  padding-left: 20%;
  text-align: center;

  overflow: hidden;
  text-overflow: ellipsis;
  display: inline-block;
  transition: all 0.25s ease-in-out;
}
.stat-title:hover h3 {
  text-shadow: 3px 3px rgb(0, 0, 0);
}

.stat-value h3 {
  font-size: 1.5rem;
  min-width: 90%;
  max-width: 90%;
  min-height: 100%;
  max-height: 100%;
  padding-right: 10%;
  text-align: center;
  background-color: rgba(0, 0, 0, 0.5);
  transition: all 0.2s ease-in-out;
  display: flex;
  flex-direction: column;
  flex-wrap: wrap;
  justify-content: center;
  align-items: center;
  align-content: center;
}

.stat-value h3:hover {
  font-size: 1.8rem;
}

.pointer {
  cursor: pointer;
}
</style>
