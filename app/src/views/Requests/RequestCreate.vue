<template>
  <div>
    <base-modal class="container">
      <h2>Post Request</h2>
      <base-card class="stat">
        <div class="stat-title">
          <h3>Type:</h3>
        </div>
        <div class="stat-value">
          <select v-model="requestType">
            <option value="add-member">Add Member</option>
            <option value="remove-member">Remove Member</option>
            <option value="withdraw">Withdraw</option>
            <option value="destroy">Destroy</option>
          </select>
        </div>
      </base-card>
      <base-card class="stat">
        <div class="stat-title">
          <h3>{{ dataLabel }}:</h3>
        </div>
        <div class="stat-value">
          <input
            ref="data"
            @focus="warningMessage = ''"
            :type="inputType"
            v-model="requestData"
          />
        </div>
      </base-card>
      <div class="warning" v-if="warningMessage">
        {{ warningMessage }}
      </div>
      <base-button class="requests-create" @click="post">+</base-button>
    </base-modal>
    <base-loader v-if="loading" />
  </div>
</template>

<script>
import SharedWalletAt from "../../web3/contracts/SharedWallet"

export default {
  data() {
    return {
      requestType: "withdraw",
      requestData: "",
      validRequestTypes: ["add-member", "remove-member", "withdraw", "destroy"],
      wallet: undefined,
      requestTypesTable: {
        "add-member": 0,
        "remove-member": 1,
        withdraw: 2,
        destroy: 3,
      },
      loading: false,
      warningMessage: "",
      dataLabel: "Amount (ETH)",
    }
  },
  async created() {
    try {
      await this.setWallet()
      const isAuth = await this.isAuth(this.userAddress)
      if (!isAuth) this.$router.push({ name: "NotFound" })
    } catch (err) {
      // there's no shared wallet contract at this address
      this.$router.push({ name: "NotFound" })
    }
  },
  computed: {
    userAddress() {
      return this.$store.getters["user/userAddress"]
    },
    inputType() {
      return this.requestType === "withdraw" ? "number" : "text"
    },
  },
  watch: {
    requestType(_new, _old) {
      if (_new === "withdraw") {
        this.dataLabel = "Amount (ETH)"
        this.requestData = ""
      } else if (_old === "withdraw") {
        this.dataLabel = "Address"
        this.requestData = ""
      }
    },
    async userAddress(_new, _old) {
      if (!(await this.isAuth(_new))) this.$router.push({ name: "NotFound" })
    },
  },
  methods: {
    async isAuth(_address) {
      return this.wallet.methods.isMember(_address).call()
    },
    async setWallet() {
      this.wallet = await SharedWalletAt(this.$route.params.id)
    },
    async validateInput() {
      const requestData = this.$refs.data.value
      if (!this.validRequestTypes.includes(this.requestType)) return false
      if (requestData.length === 0) {
        this.warningMessage = "Data field cannot be empty!"
        return false
      }
      if (
        this.requestType === "withdraw" &&
        (Number.isNaN(requestData) ||
          Number(requestData) <= 0 ||
          Number(requestData) >
            (await this.$store.getters.web3.eth.getBalance(
              this.wallet._address
            )))
      ) {
        this.warningMessage = "Invalid withdrawal amount!"
        return false
      }
      if (
        this.requestType !== "withdraw" &&
        (!requestData.startsWith("0x") || requestData.length !== 42) &&
        !requestData.endsWith(".eth")
      ) {
        this.warningMessage = "Invalid address!"
        return false
      }
      if (
        this.requestType === "remove-member" &&
        !(await this.isAuth(requestData))
      ) {
        this.warningMessage = "Can not request removing non-member!"
        return false
      }
      if (
        this.requestType === "add-member" &&
        (await this.isAuth(requestData))
      ) {
        this.warningMessage = "Can not request adding member!"
        return false
      }
      return true
    },
    async post() {
      if (await this.validateInput()) {
        this.loading = true
        try {
          await this.wallet.methods
            .createRequest(
              this.requestTypesTable[this.requestType],
              this.requestType !== "withdraw"
                ? this.$refs.data.value
                : this.$store.getters.web3.utils.toBN(
                    this.$store.getters.web3.utils.toWei(
                      this.$refs.data.value,
                      "ether"
                    )
                  )
            )
            .send({ from: this.$store.getters["user/userAddress"] })
        } catch (err) {
          console.log(err)
        } finally {
          this.loading = false
          this.requestData = false
          this.$router.push(`/wallets/${this.$route.params.id}`)
        }
      }
    },
  },
}
</script>

<style scoped>
h2 {
  text-align: center;
  font-size: 4rem;
  text-shadow: 3px 3px black;
}

.container {
  overflow: visible;
  padding: 1rem 0;
  min-width: 35vw;
  max-width: 35vw;
  min-height: 45vh;
  max-height: 45vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-evenly;
}

.input {
  font-size: 1.8rem;
}

/* input */

.stat {
  min-width: 80%;
  max-width: 80%;
  min-height: 15%;
  max-height: 15%;
  display: flex;
}

.stat-title {
  min-width: 36.66%;
  max-width: 36.66%;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(
    to right,
    rgba(59, 0, 66, 0.22) 35%,
    rgba(48, 0, 0, 0.9) 90%
  );
}

.stat-title h3 {
  font-size: 1.6rem;
  text-align: center;
  overflow: hidden;
  text-overflow: ellipsis;
  transition: all 0.25s ease-in-out;
}

.stat-title:hover h3 {
  text-shadow: 3px 3px rgb(0, 0, 0);
}

.stat-value {
  min-width: 63.33%;
  max-width: 63.33%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.stat-value input,
.stat-value select {
  cursor: default;
  overflow: hidden;
  text-overflow: ellipsis;
  color: white;
  font-size: 1.6rem;
  min-width: 100%;
  max-width: 100%;
  min-height: 100%;
  max-height: 100%;
  text-align: center;
  background-color: rgba(0, 0, 0, 0.5);
  transition: all 0.2s ease-in-out;
}

.stat-value select {
  font-size: 1.4rem;
}

.stat-value input:hover {
  font-size: 1.8rem;
}

.pointer {
  cursor: pointer;
}

.requests-create {
  position: absolute;
  left: 50%;
  bottom: 0;
  transform: translateX(-50%) translateY(50%);

  width: 8rem;
  height: 10%;

  font-size: 2rem;

  display: flex;
  align-items: center;
  justify-content: center;
}

.requests-create:hover {
  transform: translateX(-50%) translateY(50%);
  font-size: 2.5rem;
  width: 7rem;
  height: 9%;
}

.warning {
  color: red;
  font-weight: 600;
}
</style>