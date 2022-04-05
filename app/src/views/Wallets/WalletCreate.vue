<template>
  <div>
    <base-modal class="form">
      <h2>
        Create a <br />
        New Shared Wallet
      </h2>
      <p>
        Lorem ipsum dolor sit amet, consectetur adipisicing elit. Soluta fuga
        sequi molestiae possimus. Tenetur officiis aspernatur magni quibusdam
        quae vero repellendus vel repudiandae quas perspiciatis! Commodi sunt
        beatae mollitia! Quod! Lorem ipsum dolor sit amet, consectetur
        adipisicing elit.
      </p>
      <div class="input-container">
        <label for="name">Enter wallet name:</label>
        <input
          v-model="name"
          ref="input-name"
          @focus="restartInput"
          @blur="validateInput"
          id="name"
          type="text"
          placeholder="Example: My Family Wallet"
        />
      </div>
      <base-button @click="submitHandler" id="submit">Create now</base-button>
    </base-modal>
    <base-loader v-if="loading" />
  </div>
</template>

<script>
export default {
  data() {
    return {
      name: "",
      loading: false,
    }
  },
  methods: {
    validateInput() {
      if (this.name === "") {
        this.$refs["input-name"].style["border-color"] = "red"
        this.$refs["input-name"]["placeholder"] = "Wallet name cannot be empty"
        return false
      }
      return true
    },
    restartInput() {
      this.$refs["input-name"]["placeholder"] = "Example: My Family Wallet"
      this.$refs["input-name"].style["border-color"] = "gray"
    },
    submitHandler() {
      if (this.validateInput()) this.createNewSharedWallet()
    },
    async createNewSharedWallet() {
      this.loading = true
      try {
        await this.$store.getters["contracts/factory"].methods
          .createNewSharedWallet(this.name)
          .send({
            from: this.$store.getters.web3.currentProvider.selectedAddress,
          })
      } catch (err) {
      } finally {
        this.loading = false
        this.name = ""
      }
    },
  },
}
</script>

<style scoped>
.form {
  background-color: rgba(0, 0, 0, 0.3);
  overflow: visible;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding: 1rem 2rem 6rem 1rem;
}

h2 {
  text-align: center;
  font-size: 4.5rem;
  text-shadow: 3px 3px rgb(0, 0, 0);
  padding: 1rem 0 2.5rem 0;
  transition: all 0.2s ease-in-out;
}

h2:hover {
  font-size: 4.6rem;
}

p {
  color: rgb(211, 211, 211);
  text-align: center;
  font-size: 1.6rem;
  transition: all 0.4s ease-in-out;
  transform: translateY(-14%);
}

p:hover {
  color: rgb(240, 240, 240);
  font-size: 1.65rem;
}

label {
  display: inline-block;
  font-size: 1.8rem;
  text-align: center;
  animation: move 0.5s infinite ease-in alternate;
}

input {
  display: inline-block;
  border-radius: 20px;
  padding: 0.5rem 1rem;
  width: 40%;
  font-size: 1.2rem;
  text-align: center;
  text-shadow: 1px 1px rgb(141, 141, 141);
  text-overflow: ellipsis;
}

.input-container {
  display: flex;
  align-items: center;
  justify-content: space-evenly;
}

#submit {
  position: absolute;
  left: 50%;
  bottom: 0;
  transform: translateX(-50%) translateY(50%);
  height: 4rem;
  width: 25%;
  font-size: 1.2rem;
}

#submit:hover {
  height: 3.5rem;
  width: 22%;
  font-size: 1.35rem;
}

@media only screen and (max-width: 1348px) {
  h2 {
    font-size: 3.4rem;
  }

  h2:hover {
    font-size: 3.5rem;
  }
}

@media only screen and (max-width: 1048px) {
  h2 {
    font-size: 3.1rem;
  }

  h2:hover {
    font-size: 3.2rem;
  }
}

@media only screen and (max-width: 1048px) {
  h2 {
    font-size: 2.6rem;
  }

  h2:hover {
    font-size: 2.8rem;
  }

  p {
    font-size: 1.2rem;
  }

  p:hover {
    font-size: 1.21rem;
  }
}

@keyframes move {
  from {
    transform: translateX(0);
  }
  to {
    transform: translateX(10px);
  }
}
</style>