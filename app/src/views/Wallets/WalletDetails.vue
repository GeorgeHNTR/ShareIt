<template>
  <div class="container">
    <base-card class="details">
      <h2 class="details-title">{{ title }} Wallet</h2>
      <div class="stats">
        <wallet-stat
          text="Balance"
          value="0.2 ETH"
          class="details-balance"
        ></wallet-stat>
        <wallet-stat
          text="Members"
          value="7"
          class="details-members"
        ></wallet-stat>
      </div>
    </base-card>
    <base-card class="requests">
      <h2 class="requests-heading">Requests</h2>
      <div class="stats">
        <wallet-request
          addr="0xFA3AB3F3ac1d8080FD2608A187a2dc94b2C459DA"
          class="requests-request"
        ></wallet-request>
        <wallet-request class="requests-request"></wallet-request>
        <wallet-request class="requests-request"></wallet-request>
      </div>
      <base-button class="requests-create" link to="/create/request">+</base-button>
    </base-card>
  </div>
</template>

<script>
import WalletStat from "../../components/Wallet/WalletStat.vue"
import WalletRequest from "../../components/Wallet/WalletRequest.vue"

export default {
  components: { WalletStat, WalletRequest },
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
  background-color: rgba(230, 15, 15, 0.085);
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

.details-title,
.requests-heading {
  text-decoration: underline;
  word-wrap: break-word;
  text-align: center;
  padding: 3rem 0.5rem 1rem 0.5rem;
  font-size: 3.5rem;
  text-shadow: 5px 5px 1px #000000;
  transition: all 0.2s ease-in-out;
}

.details-title:hover,
.requests-heading:hover {
  font-size: 3.6rem;
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
  background-image: rgba(230, 15, 15, 0.185);
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