<template>
  <div>
    <header>
      <nav>
        <ul>
          <div class="left-aside">
            <li>
              <router-link :class="path == '/' ? 'active' : ''" to="/"
                >ShareIt</router-link
              >
            </li>
            <li>
              <router-link :class="path == '/about' ? 'active' : ''" to="/about"
                >About</router-link
              >
            </li>
          </div>
          <div class="right-aside" v-if="hasMetamask && userAddress">
            <li v-if="chainIdIsValid">
              <router-link
                :class="path == '/wallets/new' ? 'active' : ''"
                to="/wallets/new"
                >Create</router-link
              >
            </li>
            <li v-if="chainIdIsValid">
              <router-link
                :class="path == '/wallets' ? 'active' : ''"
                to="/wallets"
                >Wallets</router-link
              >
            </li>
            <user-address
              @mouseover="toggleWarning"
              @mouseleave="toggleWarning"
            ></user-address>
          </div>
          <div class="right-aside non-meta" v-else-if="!userAddress">
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
    <warning-message
      message="Invalid chain id! Switch to Ropsten Test Network"
      ref="warningMsg"
    />
  </div>
</template>

<script>
import BaseButton from "../UI/BaseButton.vue"
import UserAddress from "../UserAddress.vue"
import WarningMessage from "../Warning/WarningMessage.vue"

export default {
  components: { BaseButton, UserAddress, WarningMessage },
  data() {
    return {
      current: 0,
      path: "",
    }
  },
  computed: {
    userAddress() {
      return this.$store.getters.userAddress
    },
    hasMetamask() {
      return !!this.$store.getters.web3
    },
    chainIdIsValid() {
      return this.$store.getters.chainId == "0x3"
    },
  },
  watch: {
    $route(to) {
      this.path = to.fullPath
    },
  },
  methods: {
    connect() {
      this.$store.getters.web3.eth.requestAccounts()
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

.left-aside,
.right-aside {
  display: flex;
  align-items: center;
}

.right-aside {
  justify-content: flex-end;
  max-width: 50%;
}

.left-aside {
  justify-content: flex-start;
}
</style>