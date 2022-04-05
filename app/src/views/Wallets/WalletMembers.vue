<template>
  <base-modal class="members">
    <base-card v-for="member in members" :key="member" class="member">{{
      member
    }}</base-card>
  </base-modal>
</template>

<script>
import SharedWalletAt from "../../web3/contracts/SharedWallet"

export default {
  data() {
    return {
      members: [],
    }
  },
  async created() {
    try {
      await this.setWallet()
      const isAuth = this.wallet.methods
        .isMember(this.$store.getters["user/userAddress"])
        .call()
      if (!isAuth) this.$router.push({ name: "NotFound" })
      else {
        this.setMembers()
      }
    } catch (err) {
      // theres not shared wallet contract at this address
      this.$router.push({ name: "NotFound" })
    }
  },
  methods: {
    async setWallet() {
      this.wallet = await SharedWalletAt(this.$route.params.id)
    },
    async setMembers() {
      this.members = await this.wallet.methods.members().call()
    },
  },
}
</script>

<style scoped>
.members {
  width: 35vw;
  padding: 3rem 2rem;
  overflow: auto;
  height: auto;
  max-height: 55vh;
}

.member {
  border-radius: 100px;
  font-size: 1.2rem;
  min-height: 5rem;
  height: 20%;
  display: flex;
  align-items: center;
  overflow: hidden;
  text-overflow: ellipsis;
  justify-content: center;
  text-align: center;
  transition: all 0.3s ease-in;
  margin-bottom: 2rem;
}

.member:hover {
  color: white;
  font-size: 1.3rem;
}

.member:last-child {
  margin-bottom: 0;
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

@media only screen and (max-width: 1508px) {
  .members {
    width: 40vw;
  }
}

@media only screen and (max-width: 1288px) {
  .members {
    width: 55vw;
  }
}
</style>