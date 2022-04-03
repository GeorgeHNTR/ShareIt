<template>
  <div id="background"></div>
  <the-header class="header" />
  <router-view class="view" />
  <the-footer class="footer" />
  <!-- <div ref="browser" class="browser msg">Only Chrome browser supported</div> -->
  <div class="mobile msg">Mobile not supported</div>
  <warning-button
    @mouseover="toggleWarning"
    @mouseleave="toggleWarning"
    ref="warning-btn"
    class="warning warning-btn"
  />
  <warning-message ref="warningMsg" class="warning warning-msg" />
</template>

<script>
import TheHeader from "./components/Layout/TheHeader.vue"
import TheFooter from "./components/Layout/TheFooter.vue"
import WarningButton from "./components/Warning/WarningButton.vue"
import WarningMessage from "./components/Warning/WarningMessage.vue"
import Web3 from "web3"

export default {
  components: { TheHeader, TheFooter, WarningButton, WarningMessage },
  async mounted() {
    // if (this.currentBrowser() != "chrome") {
    //   console.log(this.currentBrowser())
    //   this.$refs["browser"].style.display = "flex"
    //   return
    // }
    if (!window.ethereum) return

    this.$store.commit("web3", new Web3(Web3.givenProvider))
    this.$store.commit(
      "chainId",
      await this.$store.getters.web3.eth.net.getId()
    )

    if ((await this.$store.getters.web3.eth.getAccounts()).length > 0) {
      const userAddress = (
        await this.$store.getters.web3.eth.requestAccounts()
      )[0]
      this.$store.commit("userAddress", userAddress)
    }

    window.ethereum.on("accountsChanged", (accounts) => {
      this.$store.commit("userAddress", accounts[0])
    })

    window.ethereum.on("chainChanged", (chainId) => {
      this.$store.commit("chainId", chainId)
      setTimeout(() => {
        this.$router.push(this.$router.go())
      }, 3000)
    })
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
    toggleWarning() {
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

.warning-btn {
  position: absolute;
  top: 4%;
  right: 6%;
}

.warning-msg {
  position: absolute;
  top: 13%;
  right: 10%;
}

@media only screen and (max-width: 835px) {
  .mobile.msg {
    display: flex;
  }

  .warning-btn {
    z-index: -1;
  }
}
</style>