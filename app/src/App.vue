<template>
  <div id="background"></div>
  <the-header class="header" />
  <router-view class="view" />
  <the-footer class="footer" />
  <div ref="metamask" id="metamask">
    <div id="bigger">Initializing Metamask ...</div>
    <div id="smaller">This might take a few seconds</div>
  </div>
  <div ref="browser" class="browser msg">Only Chrome browser supported</div>
  <div class="mobile msg">Mobile not supported</div>
</template>

<script>
import TheHeader from "./components/TheHeader.vue"
import TheFooter from "./components/TheFooter.vue"
import Web3 from "web3"

export default {
  components: { TheHeader, TheFooter },
  async mounted() {
    if (!window.ethereum) return
    if (this.currentBrowser() != "chrome") {
      console.log(this.currentBrowser())
      this.$refs["browser"].style.display = "flex"
      return
    }
    if (!window.ethereum._state.initialized) {
      this.$refs["metamask"].style.display = "flex"
      setTimeout(() => {
        window.location = window.location
      }, 1000)
      return
    }
    this.$store.commit("web3", new Web3(Web3.givenProvider))
  },
  methods: {
    currentBrowser() {
      if (
        (!!window.opr && !!opr.addons) ||
        !!window.opera ||
        navigator.userAgent.indexOf(" OPR/") >= 0
      )
        return "opera"

      if (typeof InstallTrigger !== "undefined") return "firefox"

      if (
        /constructor/i.test(window.HTMLElement) ||
        (function (p) {
          return p.toString() === "[object SafariRemoteNotification]"
        })(
          !window["safari"] ||
            (typeof safari !== "undefined" && safari.pushNotification)
        )
      )
        return "safari"

      if (false || !!document.documentMode) {
        return "internet explorer"
      }

      if (!!window.StyleMedia) return "edge"

      if (!!window.chrome) return "chrome"

      return "unrecognized"
    },
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

.browser.msg,
.mobile.msg {
  display: none;
}

.msg {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 100%;
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
  background-color: rgba(0, 0, 0, 0.96);
}

#metamask {
  text-align: center;
  position: absolute;
  color: white;
  display: none;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.96);
}

#metamask #bigger {
  font-size: 4rem;
  padding: 1rem;
}

#metamask #smaller {
  font-size: 1.5rem;
}

@media only screen and (max-width: 835px) {
  .mobile.msg {
    display: flex;
  }
}
</style>