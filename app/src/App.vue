<template>
  <div>
    <div id="background" />
    <div class="content">
      <the-header class="header" />
      <router-view class="view" v-slot="{ Component }">
        <transition name="route" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
      <the-footer class="footer" />
      <warning-pair
        class="warning-pair"
        message="You might face problems trying to connect with metamask at initial browser loading due to a bug with the provider api. If so try reloading the page several times. "
      />
    </div>
    <div class="mobile msg">Mobile not supported</div>
  </div>
</template>

<script>
import TheHeader from "./components/Layout/TheHeader.vue";
import TheFooter from "./components/Layout/TheFooter.vue";
import WarningPair from "./components/Warning/WarningPair.vue";

export default {
  components: { TheHeader, TheFooter, WarningPair },
};
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
  position: fixed;
  top: 0;
  left: 0;
  min-width: 100vw;
  max-width: 100vw;
  min-height: 100vh;
  max-height: 100vh;
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
  position: fixed;
  top: 50%;
  left: 50%;
  width: 100vw;
  height: 100vh;
  transform: translateX(-50%) translateY(-50%);
  word-break: break-word;
  text-align: center;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 3.2rem;
  color: white;
}

.route-enter-from {
  opacity: 0;
}

.route-leave-to {
  opacity: 0;
}

.route-enter-active {
  transition: all 0.3s ease-out;
}

.route-leave-active {
  transition: all 0.3s ease-in;
}

.route-enter-to,
.route-leave-from {
  opacity: 1;
}

/* scrollbar */
::-webkit-scrollbar {
  width: 15px;
}

::-webkit-scrollbar-track {
  box-shadow: inset 0 0 5px rgb(0, 0, 0);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(to right, rgb(33, 0, 43) 0, rgb(60, 0, 60) 75%);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(
    to right,
    rgba(33, 0, 43, 0.75) 0,
    rgba(60, 0, 60, 0.75) 75%
  );
}

@media only screen and (max-width: 835px) {
  .mobile.msg {
    display: flex;
  }

  .content {
    display: none;
  }

  .warning-pair {
    position: absolute;
    z-index: -10;
  }
}
</style>