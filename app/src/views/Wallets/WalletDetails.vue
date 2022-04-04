<template>
  <div class="container">
    <base-card class="details">
      <h2 class="details-title">{{ title }}</h2>
      <div class="stats">
        <stat-card
          text="Balance:"
          link
          to="/convert"
          value="0.2 ETH"
          class="w-stat"
        ></stat-card>
        <stat-card
          text="Members:"
          link
          :to="$route.path + '/members'"
          value="7"
          class="w-stat"
        ></stat-card>
      </div>
    </base-card>
    <base-card class="requests">
      <h2 class="requests-heading">Requests</h2>
      <div class="stats">
        <stat-card
          text="0xFA3AB3F3ac1d8080FD2608A187a2dc94b2C459DA"
          value="👁"
          link
          to="/requests/0xFA3AB3F3ac1d8080FD2608A187a2dc94b2C459DA"
        ></stat-card>
        <stat-card
          text="0x4F056464f6E0af5f2e8c0429BA61098481E4449E"
          value="👁"
          link
          to="/requests/0x4F056464f6E0af5f2e8c0429BA61098481E4449E"
        ></stat-card>
        <stat-card
          text="0xA153E837fE6cd51D72658C1746b952279199D434"
          value="👁"
          link
          to="/requests/0xA153E837fE6cd51D72658C1746b952279199D434"
        ></stat-card>
      </div>
      <base-button class="requests-create" link to="/requests/new"
        >+</base-button
      >
    </base-card>
  </div>
</template>

<script>
import StatCard from "../../components/Stat/StatCard.vue"

export default {
  components: { StatCard },
  data() {
    return {
      title: "Family",
    }
  },
  methods: {
    seeRequest(_requests) {
      this.$router.push(`/requests/${_requests}`)
    },
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

.details {
  grid-area: details;
  min-width: calc((55vw - 5vw) / 3 * 2);
  max-width: calc((55vw - 5vw) / 3 * 2);
}

.requests {
  overflow: visible;
  position: relative;
  grid-area: requests;
  min-width: calc((55vw - 5vw) / 3 * 1);
  max-width: calc((55vw - 5vw) / 3 * 1);
}

.details-title {
  font-size: 4rem;
}

.details-title:hover {
  font-size: 4.2rem;
}

.requests-heading {
  font-size: 3.5rem;
}

.requests-heading:hover {
  font-size: 3.6rem;
}

.details-title,
.requests-heading {
  text-decoration: underline;
  word-wrap: break-word;
  text-align: center;
  padding: 3rem 0.5rem 1rem 0.5rem;
  text-shadow: 5px 5px 1px #000000;
  transition: all 0.2s ease-in-out;
}

.w-stat {
  min-height: 30% !important;
  max-height: 30% !important;
  font-size: 2.2rem;
}

.stats {
  height: 67%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-evenly;
}

.requests-create {
  position: absolute;
  left: 50%;
  bottom: 0;
  transform: translateX(-50%) translateY(50%);

  width: 50%;
  height: 10%;

  font-size: 2rem;

  display: flex;
  align-items: center;
  justify-content: center;
}

.requests-create:hover {
  transform: translateX(-50%) translateY(50%);
  font-size: 2.5rem;
  width: 45%;
  height: 9%;
}

@media only screen and (max-width: 1628px) {
  .requests-heading {
    font-size: 3rem;
  }
  .requests-heading:hover {
    font-size: 3.1rem;
  }
}

@media only screen and (max-width: 1408px) {
  .requests-heading {
    font-size: 2.5rem;
  }
  .requests-heading:hover {
    font-size: 2.6rem;
  }
}

@media only screen and (max-width: 1184px) {
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

  .requests-heading {
    font-size: 2.3rem;
  }
  .requests-heading:hover {
    font-size: 2.4rem;
  }
}
</style>