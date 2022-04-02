<template>
  <div id="background"></div>
  <the-header class="header" />
  <router-view class="view" />
  <the-footer class="footer" />
  <div ref="metamask" id="metamask">Initializing Metamask ...</div>
  <div id="mobile-msg">Mobile not supported</div>
</template>

<script>
import TheHeader from "./components/TheHeader.vue"
import TheFooter from "./components/TheFooter.vue"
import Web3 from "web3"

export default {
  components: { TheHeader, TheFooter },
  async mounted() {
    if (!window.ethereum) return
    if (!window.ethereum._state.initialized) {
      this.$refs["metamask"].style.display = "flex"
      setTimeout(() => {
        window.location = window.location
      }, 5000)
      return
    }
    this.$store.commit("web3", new Web3(Web3.givenProvider))
  },
}
</script>

<style>
html,
body,
div,
span,
applet,
object,
iframe,
h1,
h2,
h3,
h4,
h5,
h6,
p,
blockquote,
pre,
a,
abbr,
acronym,
address,
big,
cite,
code,
del,
dfn,
em,
font,
img,
ins,
kbd,
q,
s,
samp,
small,
strike,
strong,
sub,
sup,
tt,
var,
dl,
dt,
dd,
ol,
ul,
li,
fieldset,
form,
label,
legend,
table,
caption,
tbody,
tfoot,
thead,
tr,
th,
td {
  margin: 0;
  padding: 0;
  border: 0;
  outline: 0;
  font-weight: inherit;
  font-style: inherit;
  font-size: 100%;
  font-family: inherit;
  vertical-align: baseline;
}
:focus {
  outline: 0;
}
body {
  line-height: 1;
  color: black;
  background: white;
}
ol,
ul {
  list-style: none;
}
table {
  border-collapse: separate;
  border-spacing: 0;
}
caption,
th,
td {
  text-align: left;
  font-weight: normal;
}
blockquote:before,
blockquote:after,
q:before,
q:after {
  content: "";
}
blockquote,
q {
  quotes: "" "";
}

html {
  font-family: Monospace, sans-serif;
  cursor: default;
  width: 100vw;
  height: 100vh;
  background-color: black;
}

#background {
  position: absolute;
  top: 0;
  left: 0;
  min-width: 100%;
  max-width: 100%;
  min-height: 100%;
  max-height: 100%;
  background-image: url("./assets/background.jpg");
  background-size: cover;
  background-repeat: no-repeat;
  opacity: 0.2;
}

#mobile-msg {
  display: none;
}

#metamask {
  position: absolute;
  color: white;
  display: none;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.96);
  font-size: 4rem;
}

@media only screen and (max-width: 835px) {
  .header,
  .view,
  .footer {
    display: none;
  }

  #mobile-msg {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 80%;
    height: 100%;
    transform: translateX(-50%) translateY(-50%);
    word-break: break-word;
    text-align: center;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 3.2rem;
    color: white;
    text-shadow: 2px 2px black;
  }
}
</style>