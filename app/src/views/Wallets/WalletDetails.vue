<template>
  <div>
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
                : $store.getters.web3.utils
                    .fromWei(balance, 'ether')
                    .slice(0, 4)
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
        <base-button
          @click="$router.push(`${$route.path}/deposit`)"
          class="details-button deposit"
          >Deposit</base-button
        >
        <base-button @click="leave" class="details-button leave"
          >Leave</base-button
        >
      </base-card>
      <base-card class="requests">
        <h2 class="requests-heading">Requests</h2>
        <div :class="!requests.length ? 'stats' : 'stats-requests'">
          <base-card class="no-requests" v-if="!requests.length">
            No Requests Yet
          </base-card>
          <stat-card
            v-for="requestId in requests"
            :key="requestId"
            :text="requestId"
            class="request-card"
            value="👁"
            link
            :to="`/requests/${requestId}`"
          ></stat-card>
        </div>
      </base-card>
        <base-button class="requests-create" link to="/requests/new"
          >+</base-button
        >
    </div>
    <base-loader v-if="loading" />
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
      requests: [],
      loading: false,
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
        this.setRequests()
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
    async setRequests() {
      const allRequestCount = await this.wallet.methods.requestsCounter().call()
      for (let i = 0; i < allRequestCount; i++) {
        if (!(await this.wallet.checkRequestIsApprovedById(i).call()))
          this.requests.push(i)
      }
    },
    async leave() {
      this.loading = true
      await this.wallet.methods
        .leave()
        .send({ from: this.$store.getters["user/userAddress"] })
      this.$router.push("/wallets")
      this.loading = false
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
  overflow: hidden;
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

.stats,
.stats-requests {
  height: 67%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-evenly;
}

.stats-requests {
  overflow: auto;
  justify-content: flex-start;
  padding: 2rem 0;
  height: 57%;
}

.request-card {
  margin-bottom: 1.8rem;
  min-height: 3.25rem;
  max-height: 3.25rem;
}

.request-card:last-child {
  margin-bottom: 0;
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

.requests-create {
  left: 85%;
  width: 10%;
}

.requests-create:hover,
.details-button:hover {
  transform: translateX(-50%) translateY(50%);
}

.requests-create:hover {
  font-size: 2.5rem;
  width: 9%;
  height: 8%;
}

.details-button:hover {
  font-size: 1.6rem;
  width: 32%;
  height: 9%;
}

.no-requests {
  text-align: center;
  font-size: 1.3rem;
  padding: 1.5rem 0.8rem;
  transition: all 0.3s ease-in-out;
}

.no-requests:hover {
  text-align: center;
  font-size: 1.35rem;
  padding: 1.3rem 0.4rem;
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