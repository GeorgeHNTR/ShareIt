<template>
  <div>
    <base-modal class="container">
      <base-card class="deposit-card">
        <div class="deposit-title">
          <h3>Deposit amount in ETH:</h3>
        </div>
        <div :class="`deposit-value`">
          <input v-model="amount" type="number" />
        </div>
      </base-card>
      <base-button class="deposit" @click="deposit">+</base-button>
    </base-modal>
    <base-loader v-if="loading" />
  </div>
</template>

<script>
import SharedWalletAt from "../../web3/contracts/SharedWallet"

export default {
  data() {
    return {
      loading: false,
      amount: "",
    }
  },
  methods: {
    async deposit() {
      this.loading = true
      try {
        await SharedWalletAt(this.$route.params.id)
          .methods.deposit()
          .send({
            value: this.$store.getters.web3.utils.toWei(
              String(this.amount),
              "ether"
            ),
            from: this.$store.getters["user/userAddress"],
          })
        this.$router.push(`/wallets/${this.$route.params.id}`)
      } catch (err) {
        console.log(err)
      } finally {
        this.loading = false
        this.amount = ""
      }
    },
  },
}
</script>

<style scoped>
.container {
  padding: 1rem 0;
  min-height: 20vh;
  max-height: 20vh;
  min-width: 40vw;
  max-width: 40vw;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-evenly;
  overflow: visible;
}

/* input */

.deposit-card {
  min-width: 80%;
  max-width: 80%;
  min-height: 50%;
  max-height: 50%;
  display: flex;
}

.deposit-title {
  grid-area: title;
  min-width: 66.66%;
  max-width: 66.66%;
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

.deposit-title h3 {
  font-size: 1.6rem;
  text-align: center;
  overflow: hidden;
  text-overflow: ellipsis;
  transition: all 0.25s ease-in-out;
}

.deposit-title:hover h3 {
  text-shadow: 3px 3px rgb(0, 0, 0);
}

.deposit-value {
  grid-area: value;
  min-width: 33.33%;
  max-width: 33.33%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.deposit-value input {
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

.deposit-value input:hover {
  font-size: 2rem;
}

/* button */

.deposit {
  position: absolute;
  left: 50%;
  bottom: 0;
  transform: translateX(-50%) translateY(50%);

  width: 5rem;
  height: 3.2rem;

  font-size: 2rem;

  display: flex;
  align-items: center;
  justify-content: center;
}

.deposit:hover {
  transform: translateX(-50%) translateY(50%);
  font-size: 3rem;
  width: 3.2rem;
  height: 4.2rem;
}
</style>