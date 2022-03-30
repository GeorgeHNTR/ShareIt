<template>
  <div class="container">
    <base-card class="details">
      <h2 class="details-title">{{ title }} Wallet</h2>
      <div class="stats">
        <base-card class="details-balance"></base-card>
        <base-card class="details-members"></base-card>
      </div>
    </base-card>
    <base-card class="requests">
      <h2 class="requests-heading">Requests</h2>
      <div class="stats">
        <base-card class="requests-request"></base-card>
        <base-card class="requests-request"></base-card>
        <base-card class="requests-request"></base-card>
      </div>
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
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translateX(-50%) translateY(-50%);
  width: 55vw;
  height: 55vh;
  gap: 5vw;
}

.details,
.requests {
  background-color: rgba(0, 0, 0, 0.25);
}

.details {
  grid-area: details;
  min-width: calc((55vw - 5vw) / 3 * 2);
  max-width: calc((55vw - 5vw) / 3 * 2);
}

.requests {
  grid-area: requests;
  min-width: calc((55vw - 5vw) / 3 * 1);
  max-width: calc((55vw - 5vw) / 3 * 1);
}

.details-title,
.requests-heading {
  text-decoration: underline;
  word-wrap: break-word;
  text-align: center;
  padding: 3rem 0.5rem 1rem 0.5rem;
  font-size: 3.5rem;
  text-shadow: 4px 4px #000000;
}

.stats {
  height: 67%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-evenly;
}

.details-balance,
.details-members {
  background-color: rgba(0, 0, 0, 0.26);
  width: 80%;
  height: 25%;
}

.requests-request {
  background-color: rgba(0, 0, 0, 0.26);
  width: 80%;
  height: 20%;
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