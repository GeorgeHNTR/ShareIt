<template>
  <div>
    <header>
      <nav>
        <ul>
          <div class="left-aside">
            <li>
              <router-link
                class="r-link"
                :class="path == '/' ? 'active' : ''"
                to="/"
                >ShareIt</router-link
              >
            </li>
            <li>
              <router-link
                class="r-link"
                :class="path == '/about' ? 'active' : ''"
                to="/about"
                >About</router-link
              >
            </li>
          </div>
          <div
            class="right-aside"
            v-if="hasMetamask && userAddress && chainIdIsValid"
          >
            <li>
              <router-link
                class="r-link"
                :class="path == '/invitations' ? 'active' : ''"
                to="/invitations"
                >♦</router-link
              >
            </li>
            <li>
              <router-link
                class="r-link"
                :class="path == '/wallets/new' ? 'active' : ''"
                to="/wallets/new"
                >Create</router-link
              >
            </li>
            <li>
              <router-link
                class="r-link"
                :class="path == '/wallets' ? 'active' : ''"
                to="/wallets"
                >Wallets</router-link
              >
            </li>
            <user-address></user-address>
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
  </div>
</template>

<script>
import BaseButton from "../UI/BaseButton.vue"
import UserAddress from "../UserAddress.vue"

export default {
  components: { BaseButton, UserAddress },
  data() {
    return {
      current: 0,
    }
  },
  computed: {
    userAddress() {
      return this.$store.getters['user/userAddress']
    },
    hasMetamask() {
      return !!this.$store.getters.web3
    },
    chainIdIsValid() {
      return this.$store.getters['user/chainId'] == 3
    },
    path() {
      return this.$route.path
    },
  },
  methods: {
    connect() {
      this.$store.getters.web3.eth.requestAccounts()
    },
  },
}
</script>

<style scoped>
header {
  position: absolute;
  top: 0;
  left: 0;
  width: 100vw;
  z-index: 100;
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

.r-link {
  text-decoration: none;
  color: rgb(192, 192, 192);
  transition: all 200ms ease-in-out;
  text-shadow: 3px 2px 10px #000000;
}

.r-link:hover {
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