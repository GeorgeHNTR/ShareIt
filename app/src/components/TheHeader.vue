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
            <button>+ connect</button>
          </li>
        </div>
      </ul>
    </nav>
  </header>
</template>

<script>
export default {}
</script>

<style scoped>
header {
  position: fixed;
  z-index: 10000;
  top: 0;
  left: 0;
  width: 100vw;
}

nav {
  margin: 1rem 15%;
  border-radius: 50px 50px 50px 50px;
  box-shadow: 5px 5px 36px 20px rgba(0, 0, 0, 0.5);
  background: rgb(145, 0, 58);
  background-image: linear-gradient(
    315deg,
    rgba(81, 0, 140, 1) 25%,
    rgb(108, 37, 223) 100%
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
}

@media only screen and (max-width: 640px) {
  header {
    display: none;
  }
}
</style>