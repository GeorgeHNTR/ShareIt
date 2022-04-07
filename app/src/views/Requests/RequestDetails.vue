<template>
  <div>
    <base-modal class="container">
      <h2>Request Details</h2>
      <div class="stats">
        <stat-card
          text="By:"
          :value="requestAuthor.slice(0, 7) + '...'"
          class="stats-card"
        ></stat-card>
        <stat-card
          text="Type:"
          :value="requestType"
          class="stats-card"
        ></stat-card>
        <stat-card
          text="Data:"
          :value="requestData.slice(0, 7) + '...'"
          class="stats-card"
        ></stat-card>
      </div>
      <base-button @click="approve" id="approve">Approve</base-button>
    </base-modal>
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
      requestAuthor: "",
      requestType: "...",
      requestData: "",
      requestTypesTable: {
        0: "add-member",
        1: "remove-member",
        2: "withdraw",
        3: "destroy",
      },
      loading: false,
    }
  },
  async created() {
    if (
      await Promise.all([this.isAlreadyApproved(), this.isAlreadyAccepted()])
    ) {
      this.$router.push({ name: "NotFound" })
      return
    }
    await this.fetchRequestData()
  },
  computed: {
    userAddress() {
      return this.$store.getters["user/userAddress"]
    },
  },
  watch: {
    async userAddress(_new, _old) {
      if (await this.isAlreadyAccepted())
        this.$router.push({ name: "NotFound" })
    },
  },
  methods: {
    async isAlreadyApproved() {
      return SharedWalletAt(this.$route.params.walletId)
        .methods.checkRequestIsApprovedById(this.$route.params.requestId)
        .call({ from: this.userAddress })
    },
    async isAlreadyAccepted() {
      return SharedWalletAt(this.$route.params.walletId)
        .methods.checkMemberHasVotedById(this.$route.params.requestId)
        .call({ from: this.userAddress })
    },
    async fetchRequestData() {
      const [_author, _type] = await Promise.all([
        SharedWalletAt(this.$route.params.walletId)
          .methods.getRequestAuthorById(this.$route.params.requestId)
          .call(),
        SharedWalletAt(this.$route.params.walletId)
          .methods.getRequestTypeById(this.$route.params.requestId)
          .call(),
      ])

      const requestIdIsValid = !!Number(_author)
      if (!requestIdIsValid) {
        this.$router.push({ name: "NotFound" })
        return
      }

      this.requestAuthor = _author
      this.requestType = this.requestTypesTable[Number(_type)]
      if (this.requestType === "withdraw")
        this.requestData = this.$store.getters.web3.utils.fromWei(
          await SharedWalletAt(this.$route.params.walletId)
            .methods.getRequestValueById(this.$route.params.requestId)
            .call(),
          "ether"
        )
      else
        this.requestData = await SharedWalletAt(this.$route.params.walletId)
          .methods.getRequestAddrById(this.$route.params.requestId)
          .call()
    },
    async approve() {
      this.loading = true
      try {
        await SharedWalletAt(this.$route.params.walletId)
          .methods.acceptRequest(this.$route.params.requestId)
          .send({ from: this.userAddress })
      } catch (err) {
        console.error(err)
      } finally {
        this.loading = false
      }
    },
  },
}
</script>


<style scoped>
.container {
  background-color: rgba(255, 0, 0, 0.055);
  width: 35%;
  overflow: visible;
  padding: 4rem 2rem 3rem 2rem;
}

h2 {
  text-align: center;
  font-size: 4rem;
  text-shadow: 5px 5px black;
}

.stats {
  position: relative;
  padding: 2rem 0;
  height: 80%;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-evenly;
}

.stats-card {
  font-size: 2rem;
  padding: 0;
  max-height: 5%;
  transition: all 0.2s ease-in-out;
}

#approve {
  position: absolute;
  left: 50%;
  bottom: 0;
  transform: translateX(-50%) translateY(50%);
  height: 4rem;
  width: 28%;
  font-size: 1.2rem;
}

#approve:hover {
  height: 3.5rem;
  width: 25%;
  font-size: 1.35rem;
}

@media only screen and (max-width: 1510px) {
  h2 {
    text-align: center;
    font-size: 2.8rem;
    text-shadow: 5px 5px black;
  }
}
</style>