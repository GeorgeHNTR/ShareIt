<template>
  <header>
    <nav>
      <ul>
        <div id="left-aside">
          <li>
            <router-link to="/">ShareIt</router-link>
          </li>
          <li>
            <router-link to="/about">About</router-link>
          </li>
        </div>
        <div id="right-aside">
          <li id="connected">
            <router-link to="/wallets">Wallets</router-link>
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
}
</script>

<style scoped>
header {
  position: absolute;
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
    rgb(124, 20, 110) 0,
    rgb(36, 11, 54) 100%
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
  color: white;
  transition: all 200ms ease-in-out;
}

a:hover {
  text-shadow: 3px 2px #000000;
}

#left-aside,
#right-aside {
  display: flex;
  align-items: center;
}

@media only screen and (max-width: 640px) {
  header {
    display: none;
  }
}
</style>