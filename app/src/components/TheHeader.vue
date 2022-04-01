<template>
  <header>
    <nav>
      <ul>
        <div id="left-aside">
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
        <div id="right-aside">
          <li id="connected">
            <router-link
              @click="current = 2"
              :class="current == 2 ? 'active' : ''"
              to="/wallets"
              >Wallets</router-link
            >
          </li>
          <li id="notConnected">
            <base-button>+ Connect</base-button>
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
  border-radius: 50px 50px 50px 50px;
  box-shadow: 5px 5px 36px 20px rgba(0, 0, 0, 0.5);
  background: linear-gradient(
    to right,
    rgb(59, 0, 66) 0,
    rgb(48, 0, 0) 90%
  );
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

#left-aside,
#right-aside {
  display: flex;
  align-items: center;
}

@media only screen and (max-width: 835px) {
  header {
    display: none;
  }
}
</style>