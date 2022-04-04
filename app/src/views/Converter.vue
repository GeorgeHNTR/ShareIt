<template>
  <base-modal class="container">
    <h2>Converter</h2>
    <base-card class="stat">
      <div class="stat-title">
        <h3>ETH:</h3>
      </div>
      <div :class="`stat-value`">
        <input
          @input="convertFrom('ether')"
          v-model.trim="ether"
          type="number"
        />
      </div>
    </base-card>
    <base-card class="stat">
      <div class="stat-title">
        <h3>GWEI:</h3>
      </div>
      <div :class="`stat-value`">
        <input @input="convertFrom('gwei')" v-model.trim="gwei" type="number" />
      </div>
    </base-card>
    <base-card class="stat">
      <div class="stat-title">
        <h3>WEI:</h3>
      </div>
      <div :class="`stat-value`">
        <input @input="convertFrom('wei')" v-model.trim="wei" type="number" />
      </div>
    </base-card>
  </base-modal>
</template>

<script>
export default {
  data() {
    return {
      ether: "",
      gwei: "",
      wei: "",
      denominations: {
        wei: 1,
        gwei: 1000000000,
        ether: 1000000000000000000n,
      },
    }
  },
  methods: {
    convertFrom(_changed) {
      if (!this[_changed]) {
        this.ether = 0
        this.gwei = 0
        this.wei = 0
        return
      }
      switch (_changed) {
        case "wei": {
          this.ether = this.$store.getters.web3.utils.fromWei(this.wei, "ether")
          this.gwei = this.$store.getters.web3.utils.fromWei(this.wei, "gwei")
        }
        case "gwei": {
          this.wei = this.$store.getters.web3.utils.toWei(this.gwei, "gwei")
          this.ether = this.$store.getters.web3.utils.fromWei(this.wei, "ether")
        }
        case "ether": {
          this.wei = this.$store.getters.web3.utils.toWei(this.ether, "ether")
          this.gwei = this.$store.getters.web3.utils.fromWei(this.wei, "gwei")
        }
      }
    },
  },
}
</script>

<style scoped>
h2 {
  font-size: 4rem;
  text-shadow: 3px 3px black;
}

.container {
  padding: 1rem 0;
  min-width: 40vw;
  max-width: 40vw;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-evenly;
}

.input {
  font-size: 1.8rem;
}

/* input */

.stat {
  min-width: 80%;
  max-width: 80%;
  min-height: 15%;
  max-height: 15%;
  display: flex;
}

.stat-title {
  grid-area: title;
  min-width: 66.66%;
  max-width: 66.66%;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(
    to right,
    rgba(59, 0, 66, 0.22) 35%,
    rgba(48, 0, 0, 0.9) 90%
  );
}

.stat-title h3 {
  font-size: 1.6rem;
  text-align: center;
  overflow: hidden;
  text-overflow: ellipsis;
  transition: all 0.25s ease-in-out;
}

.stat-title:hover h3 {
  text-shadow: 3px 3px rgb(0, 0, 0);
}

.stat-value {
  grid-area: value;
  min-width: 33.33%;
  max-width: 33.33%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.stat-value input {
  cursor: default;
  overflow: hidden;
  text-overflow: ellipsis;
  color: white;
  font-size: 1rem;
  min-width: 100%;
  max-width: 100%;
  min-height: 100%;
  max-height: 100%;
  text-align: center;
  background-color: rgba(0, 0, 0, 0.5);
  transition: all 0.2s ease-in-out;
}

.stat-value input:hover {
  font-size: 1.4rem;
}

.pointer {
  cursor: pointer;
}
</style>