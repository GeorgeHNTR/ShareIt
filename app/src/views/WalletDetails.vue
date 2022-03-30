<template>
  <div class="container">
    <base-card class="details">
      <div class="details-title">{{ title }} Wallet</div>
      <div class="details-balance"></div>
      <div class="details-members"></div>
    </base-card>
    <base-card class="requests">
      <div class="requests-heading">Requests</div>
      <div class="requests-request"></div>
      <div class="requests-request"></div>
      <div class="requests-request"></div>
    </base-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      title: "Family",
    }
  },
}
</script>

<style scoped>
.card {
  padding: 0;
}

.container {
  display: grid;
  grid-template-areas: "details details requests";
  /* background-color: green; */
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translateX(-50%) translateY(-50%);
  width: 55vw;
  height: 55vh;
  gap: 5vw;
}

.details {
  display: flex;
  flex-direction: column;
  align-items: center;
  min-width: calc((55vw - 5vw) / 3 * 2);
  max-width: calc((55vw - 5vw) / 3 * 2);
  grid-area: details;
  background-color: rgba(0, 0, 0, 0.25);
}

.requests {
  min-width: calc((55vw - 5vw) / 3 * 1);
  max-width: calc((55vw - 5vw) / 3 * 1);
  grid-area: requests;
  background-color: rgba(0, 0, 0, 0.25);
}

.details-title {
    text-decoration: underline;
  text-align: center;
  padding: 2rem 0.5rem;
  font-size: 3.5rem;
}

.requests-heading {
    text-decoration: underline;
  word-wrap: break-word;
  text-align: center;
  padding: 2rem 0.5rem;
  font-size: 3.5rem;
}

.details-balance {
    background-color: red;

}

@media only screen and (max-width: 1064px) {
  .container {
    width: 70vw;
    height: 55vh;
  }

  .details {
    min-width: calc((70vw - 5vw) / 3 * 2);
    max-width: calc((70vw - 5vw) / 3 * 2);
  }

  .requests {
    min-width: calc((70vw - 5vw) / 3 * 1);
    max-width: calc((70vw - 5vw) / 3 * 1);
  }
}
</style>