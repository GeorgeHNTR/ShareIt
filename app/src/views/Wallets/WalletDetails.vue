<template>
  <div class="container">
    <base-card class="details">
      <h2 class="details-title">{{ title }}</h2>
      <div class="stats">
        <stat-card
          text="Balance:"
          link
          :to="`/converter?value=${balance}&den=wei`"
          :value="`${
            balance == 0
              ? '0.00'
              : $store.getters.web3.utils.fromWei(balance, 'ether').slice(0, 4)
          } ETH`"
          class="w-stat"
        ></stat-card>
        <stat-card
          text="Members:"
          link
          :to="$route.path + '/members'"
          :value="String(members.length)"
          class="w-stat"
        ></stat-card>
      </div>
      <base-button @click="$router.push(`${$route.path}/deposit`)" class="details-button deposit"
        >Deposit</base-button
      >
      <base-button @click="leave" class="details-button leave"
        >Leave</base-button
      >
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
import SharedWalletAt from "../../web3/contracts/SharedWallet"

export default {
  components: { StatCard },
  data() {
    return {
      title: "Family",
      wallet: undefined,
      balance: 0,
      members: [],
    }
  },
  async created() {
    try {
      await this.setWallet()
      const isAuth = this.wallet.methods
        .isMember(this.$store.getters["user/userAddress"])
        .call()
      if (!isAuth) this.$router.push({ name: "NotFound" })
      else {
        this.setBalance()
        this.setMembers()
      }
    } catch (err) {
      // theres no shared wallet contract at this address
      this.$router.push({ name: "NotFound" })
    }
  },
  methods: {
    seeRequest(_requests) {
      this.$router.push(`/requests/${_requests}`)
    },
    async setWallet() {
      this.wallet = await SharedWalletAt(this.$route.params.id)
    },
    async setBalance() {
      this.balance = await this.$store.getters.web3.eth.getBalance(
        this.wallet._address
      )
    },
    async setMembers() {
      this.members = await this.wallet.methods.members().call()
    },
    async leave() {
      await this.wallet.methods
        .leave()
        .send({ from: this.$store.getters["user/userAddress"] })
      this.$router.push("/wallets")
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
  position: relative;
  overflow: visible;
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

.requests-create,
.details-button {
  position: absolute;
  left: 50%;
  bottom: 0;
  transform: translateX(-50%) translateY(50%);

  width: 35%;
  height: 10%;

  font-size: 2rem;

  display: flex;
  align-items: center;
  justify-content: center;
}

.details-button {
  font-size: 1.5rem;
}

.deposit {
  left: 30%;
}

.leave {
  left: 70%;
}

.requests-create:hover,
.details-button:hover {
  transform: translateX(-50%) translateY(50%);
  font-size: 2.5rem;
  width: 32%;
  height: 9%;
}

.details-button:hover {
  font-size: 1.6rem;
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