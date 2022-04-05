<template>
  <li
    @mouseover="toggleWarning"
    @mouseleave="toggleWarning"
    ref="userAddress"
    :class="userAddress == '!' ? 'warning address' : 'address'"
  >
    {{ userAddress }}
  </li>
  <warning-message
    message="Invalid chain id! Switch to Ropsten Test Network"
    ref="warningMsg"
  />
</template>

<script>
import WarningMessage from "./Warning/WarningMessage.vue"

export default {
  components: { WarningMessage },
  computed: {
    userAddress() {
      return this.$store.getters['user/chainId'] == "0x3"
        ? this.$store.getters['user/userAddress']
        : "!"
    },
    chainIdIsValid() {
      return this.$store.getters['user/chainId'] == "0x3"
    },
  },
  methods: {
    async connect() {
      try {
        const userAddress = (
          await this.$store.getters.web3.eth.requestAccounts()
        )[0]
        this.$store.commit("user/userAddress", userAddress)
      } catch (err) {}
    },
    toggleWarning() {
      if (this.chainIdIsValid) return
      const el = this.$refs["warningMsg"].$el
      if (el.style.display == "none" || el.style.display == "") {
        el.style.display = "block"
      } else {
        el.style.display = "none"
      }
    },
  },
}
</script>

<style scoped>
.address {
  max-width: 15%;
  padding: 0.55rem 1rem;
  border-radius: 50px;
  font-size: 1.25rem;
  color: rgb(204, 204, 204);
  text-shadow: 2px 2px black;
  text-transform: lowercase;
  animation: color_change 5s infinite alternate;
  transition: all 0.3s ease-in-out;
  overflow: hidden;
  text-overflow: ellipsis;
}

.address:hover {
  color: white;
}

.warning {
  display: flex;
  justify-content: center;
}

@keyframes color_change {
  0% {
    box-shadow: 0 0 2px 3px rgba(83, 0, 131, 0.65);
    background-color: rgba(83, 0, 131, 0.65);
  }
  50% {
    box-shadow: 0 0 2px 2px rgba(110, 0, 83, 0.8);
    background-color: rgba(110, 0, 83, 0.8);
  }
  100% {
    box-shadow: 0 0 2px 3px rgba(83, 0, 131, 0.65);
    background-color: rgba(83, 0, 131, 0.65);
  }
}
</style>