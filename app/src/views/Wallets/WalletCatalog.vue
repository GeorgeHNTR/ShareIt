<template>
  <div>
    <div v-if="!hasWallets && !loading">
      <base-card class="empty">
        <div>
          No wallets available <br />
          Maybe create one?
        </div>
      </base-card>
    </div>
    <div v-else-if="hasWallets && !loading">
      <base-card @click="seeWallet" class="wallet main">
        {{ currentWallet.name }}
      </base-card>
      <base-card
        v-if="hasWallets && walletIdx !== 0"
        @click="--walletIdx"
        class="wallet side left"
      ></base-card>
      <base-card
        v-if="hasWallets && wallets.length !== walletIdx + 1"
        @click="++walletIdx"
        class="wallet side right"
      ></base-card>
    </div>

    <base-loader v-if="loading" />
  </div>
</template>

<script>
import SharedWalletAt from "../../web3/contracts/SharedWallet"

export default {
  data() {
    return {
      walletIdx: 0,
      loading: false,
      wallets: [],
    }
  },
  computed: {
    currentWallet() {
      return this.wallets[this.walletIdx]
    },
    currentAddress() {
      return this.$store.getters["user/userAddress"]
    },
    hasWallets() {
      return this.wallets.length !== 0
    },
  },
  created() {
    this.fetchWallets()
  },
  watch: {
    async currentAddress() {
      await this.fetchWallets()
    },
  },
  methods: {
    seeWallet() {
      this.$router.push(`/wallets/${this.wallets[this.walletIdx].id}`)
    },
    async fetchWallets() {
      this.loading = true
      const _wallets = await this.$store.dispatch("contracts/fetchUserWallets")

      const _tempWallets = []
      for (let i = 0; i < _wallets.length; i++) {
        const currentWalletAddress = _wallets[i]
        _tempWallets.push({
          id: currentWalletAddress,
          name: await SharedWalletAt(currentWalletAddress)
            .methods.name()
            .call(),
        })
      }
      this.wallets = _tempWallets
      this.loading = false
    },
  },
}
</script>

<style scoped>
body {
  overflow: hidden;
}

.card {
  padding: 1.5rem;
  position: absolute;
  top: 50%;
  left: 50%;
  width: 30vw;
  transform: translateY(-50%) translateX(-50%);
  text-align: center;
  font-size: 4rem;
  font-weight: 400;
}

.wallet {
  cursor: pointer;
  height: 35vh;
  border-radius: 75px;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  font-size: 6.5rem;
  text-shadow: 5px 5px #000000;
  transition: all 200ms ease-in-out;
}

.wallet:hover {
  height: 33vh;
  width: 32vw;
  font-size: 7rem;
}

.main:hover {
  border-radius: 90px;
}

.side {
  background: linear-gradient(
    to right,
    rgba(59, 0, 66, 0.35) 0,
    rgba(48, 0, 0, 0.7) 90%
  );
  height: 24vh;
  width: 3vw;
}

.side:hover {
  height: 23vh;
  width: 4.5vw;
}

.left {
  border-radius: 0 75px 75px 0;
  left: 20%;
}

.right {
  border-radius: 75px 0 0 75px;
  left: 80%;
}

@media only screen and (max-width: 1381px) {
  .wallet {
    font-size: 3.2rem;
  }

  .wallet:hover {
    font-size: 4rem;
  }

  .empty {
    font-size: 3.2rem;
  }
}
</style>