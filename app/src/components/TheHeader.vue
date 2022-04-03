<template>
  <header>
    <nav>
      <ul>
        <div class="left-aside">
          <li>
            <router-link
              @click="current = 0"
              :class="current == 0 ? 'active' : ''"
              to="/"
              >ShareIt</router-link
            >
          </li>
          <li>
            <router-link
              @click="current = 1"
              :class="current == 1 ? 'active' : ''"
              to="/about"
              >About</router-link
            >
          </li>
        </div>
        <div class="right-aside" v-if="hasMetamask && userAddress">
          <li>
            <router-link
              @click="current = 2"
              :class="current == 2 ? 'active' : ''"
              to="/wallets"
              >Wallets</router-link
            >
          </li>
          <li id="userAddress">{{ userAddress.slice(0, 8) }}..</li>
        </div>
        <div class="right-aside" v-else-if="!userAddress">
          <li v-if="!hasMetamask">
            <base-button link to="https://metamask.io/"
              >+ Install Metamask</base-button
            >
          </li>
          <li v-else @click="connect">
            <base-button>+ Connect to Metamask</base-button>
          </li>
        </div>
      </ul>
    </nav>
  </header>
</template>

<script>
import BaseButton from "./UI/BaseButton.vue"

export default {
  components: { BaseButton },
  data() {
    return {
      current: 0,
    }
  },
  computed: {
    userAddress() {
      return this.$store.getters.userAddress
    },
    hasMetamask() {
      return !!this.$store.getters.web3
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
  },
}
</script>

<style scoped>
header {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
}

nav {
  margin: 1rem 15%;
  border-radius: 50px;
  box-shadow: 5px 5px 36px 20px rgba(0, 0, 0, 0.5);
  background: linear-gradient(to right, rgb(59, 0, 66) 0, rgb(48, 0, 0) 90%);
}

ul {
  display: flex;
  justify-content: space-between;
  padding: 1.5rem 5%;
}

li {
  display: inline-block;
  margin: 0 1rem;
  font-size: 1.5rem;
}

a {
  text-decoration: none;
  color: rgb(192, 192, 192);
  transition: all 200ms ease-in-out;
  text-shadow: 3px 2px 10px #000000;
}

a:hover {
  color: rgb(255, 255, 255);
  text-shadow: 3px 2px #000000;
}

.active {
  color: rgb(255, 255, 255);
  text-shadow: 3px 2px #000000;
}

#userAddress {
  padding: 0.8rem 0.8rem;
  border-radius: 50px;
  font-size: 1.25rem;
  color: rgb(204, 204, 204);
  text-shadow: 2px 2px black;
  text-transform: lowercase;
  animation: color_change 1s infinite alternate;
  transition: all 0.3s ease-in-out;
}

#userAddress:hover {
  color: white;
}

.left-aside,
.right-aside {
  display: flex;
  align-items: center;
}

@keyframes color_change {
  from {
    background-color: rgba(61, 0, 77, 0.8);
    box-shadow: 0 0 8px 2px rgba(61, 0, 77, 0.8);
  }
  to {
    background-color: rgba(75, 0, 0, 0.8);
    box-shadow: 0 0 8px 2px rgba(75, 0, 0, 0.8);
  }
}
</style>