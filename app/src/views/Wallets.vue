<template>
  <base-card v-if="!isConnected">
    <div>No wallets available</div>
  </base-card>
  <base-card @click="seeWallet(currentWallet.id)" v-else class="wallet main">
    {{ currentWallet.title }} Wallet
  </base-card>
  <base-card
    v-if="walletIdx !== 0"
    @click="--walletIdx"
    class="wallet side left"
  ></base-card>
  <base-card
    v-if="wallets.length !== walletIdx + 1"
    @click="++walletIdx"
    class="wallet side right"
  ></base-card>
</template>

<script>
import router from "../router"

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
      router.push(`/wallets/${id}`)
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
  word-break: break-word;
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
  background-color: rgba(224, 19, 19, 0.1);
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
  background-color: rgba(0, 0, 0, 0.25);
  height: 24vh;
  width: 5vw;
}

.side:hover {
  height: 22vh;
  width: 6.5vw;
}

.left {
  border-radius: 0 75px 75px 0;
  left: 15%;
}

.right {
  border-radius: 75px 0 0 75px;
  left: 85%;
}

@media only screen and (max-width: 1144px) {
  .wallet {
    font-size: 3.2rem;
  }

  .wallet:hover {
    font-size: 4rem;
  }
}
</style>