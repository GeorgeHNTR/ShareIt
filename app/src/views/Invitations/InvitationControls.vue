<template>
  <div>
    <base-modal class="container">
      <h2 class="title">Invitation</h2>
      <h3 class="wallet" @click="openAtEtherscan">Wallet address: {{ $route.params.walletId }}</h3>
      <h3 class="wallet" @click="openAtEtherscan">Wallet name: {{ walletName }}</h3>
      <div class="controls">
        <base-button @click="accept" class="controls-btn accept">Accept</base-button>
        <base-button @click="reject" class="controls-btn reject">Reject</base-button>
      </div>
    </base-modal>
    <base-loader v-if="loading" />
  </div>
</template>

<script>
import SharedWalletAt from "../../web3/contracts/SharedWallet";

export default {
  data() {
    return {
      loading: false,
      wallet: undefined,
      walletName: ""
    };
  },
  async created() {
    await this.setWallet();
    if (
      (await this.wallet.methods
        .checkRequestIsAcceptedById(this.$route.params.requestId)
        .call()) != 1
    ) {
      this.$router.push({ name: "NotFound" });
    }
  },
  methods: {
    async setWallet() {
      this.wallet = SharedWalletAt(this.$route.params.walletId);
      this.walletName = await this.wallet.methods.name().call();
    },
    openAtEtherscan() {
      window.open(
        `https://ropsten.etherscan.io/address/${this.$route.params.walletId}`,
        "_blank"
      );
    },
    async accept() {
      this.loading = true;
      try {
        await this.wallet.methods
          .acceptInvitation(Number(this.$route.params.requestId))
          .send({ from: this.$store.getters["user/userAddress"] });
      } catch (err) {
      } finally {
        this.loading = false;
        this.$router.push(`/wallets/${this.$route.params.walletsId}`);
      }
    },
    async reject() {
      this.loading = true;
      try {
        await this.wallet.methods
          .rejectInvitation(this.$route.params.requestId)
          .send({ from: this.$store.getters["user/userAddress"] });
      } catch (err) {
      } finally {
        this.loading = false;
        this.$router.push("/");
      }
    }
  }
};
</script>

<style scoped>
.container {
  min-height: 25vh;
  max-height: 25vh;
  min-width: auto;
  max-width: 40rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-evenly;
  overflow: visible;
  padding: 0 3rem 2.5rem 3rem;
}

.title {
  font-size: 4.5rem;
  text-align: center;
  text-shadow: 4px 4px black;
  transition: all 0.25s ease-in-out;
}

.wallet {
  font-size: 1.2rem;
  color: rgb(200, 200, 200);
  text-align: center;
  text-shadow: 2px 2px black;
  cursor: pointer;
  transition: all 0.25s ease-in-out;
}

.wallet:hover {
  color: rgb(255, 255, 255);
  font-size: 1.18rem;
}

.controls {
  position: absolute;
  bottom: 0;
  transform: translateY(50%);
  display: flex;
  align-items: center;
  justify-content: center;
  width: 66.66%;
}

.controls-btn {
  font-size: 1.4rem;
  padding: 1rem 2rem;
}

.accept {
  border-radius: 50px 0 0 50px;
}

.reject {
  border-radius: 0 50px 50px 0;
}
</style>