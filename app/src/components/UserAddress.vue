<template>
  <li ref="userAddress" :mouseover="showWarning" id="userAddress">
    {{ userAddress }}
  </li>
</template>

<script>
export default {
  computed: {
    userAddress() {
      return this.$store.getters.chainId == "0x3"
        ? this.$store.getters.userAddress
        : "!"
    },
  },
  methods: {
    async connect() {
      try {
        const userAddress = (
          await this.$store.getters.web3.eth.requestAccounts()
        )[0]
        this.$store.commit("userAddress", userAddress)
      } catch (err) {}
    },
    showWarning() {
      if (this.userAddress == "!") {
        this.$refs["userAddress"].style.cursor = "not-allowed"
      }
    },
  },
}
</script>

<style scoped>
#userAddress {
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

#userAddress:hover {
  color: white;
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