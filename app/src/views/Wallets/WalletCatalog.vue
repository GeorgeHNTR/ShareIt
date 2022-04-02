<template>
  <div>
    <base-card class="empty" v-if="!isConnected">
      <div>No wallets available</div>
    </base-card>
    <base-card @click="seeWallet()" v-if="isConnected" class="wallet main">
      {{ currentWallet.title }} Wallet
    </base-card>
    <base-card
      v-if="isConnected && walletIdx !== 0"
      @click="--walletIdx"
      class="wallet side left"
    ></base-card>
    <base-card
      v-if="isConnected && wallets.length !== walletIdx + 1"
      @click="++walletIdx"
      class="wallet side right"
    ></base-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      isConnected: true,
      walletIdx: 0,
      wallets: [
        {
          title: "Family",
          id: "0x1",
        },
        {
          title: "School",
          id: "0x2",
        },
        {
          title: "Personal",
          id: "0x3",
        },
      ],
    }
  },
  computed: {
    currentWallet() {
      return this.wallets[this.walletIdx]
    },
  },
  methods: {
    seeWallet(id) {
      this.$router.push(`/wallets/${this.wallets[this.walletIdx].id}`)
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
  background: linear-gradient(to right, rgba(59, 0, 66, 0.1) 0, rgba(48, 0, 0, 0.7) 90%);
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
  background: linear-gradient(to right, rgba(59, 0, 66, 0.35) 0, rgba(48, 0, 0, 0.7) 90%);
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