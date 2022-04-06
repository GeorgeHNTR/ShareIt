<template>
  <base-modal class="container">
    <h2 class="title">Invitations</h2>
    <div class="invitations" :class="!invitations.length && 'flex'">
      <base-card class="no-invitations" v-if="!invitations.length">
        No Invitations Yet
      </base-card>
      <base-card
        v-for="invitation in invitations"
        :key="invitation.wallet"
        class="invitation"
        >{{ invitation.wallet }}</base-card
      >
    </div>
  </base-modal>
</template>

<script>
export default {
  data() {
    return {
      invitations: [],
    }
  },
  computed: {
    userAddress() {
      return this.$store.getters["user/userAddress"]
    },
  },
  watch: {
    async userAddress() {
      await this.getInvitations()
    },
  },
  async created() {
    await this.getInvitations()
  },
  methods: {
    async getInvitations() {
      const [wallets, requestsIDs] = await Promise.all([
        this.$store.getters["contracts/storage"].methods
          .getInvitationsWallets()
          .call({
            from: this.userAddress,
          }),
        this.$store.getters["contracts/storage"].methods
          .getInvitationsWallets()
          .call({
            from: this.userAddress,
          }),
      ])

      for (let i = 0; i < wallets.length; i++)
        this.invitations.push({
          wallet: wallets[i],
          requestId: requestsIDs[i],
        })
    },
  },
}
</script>

<style scoped>
.title {
  position: fixed;
  display: flex;
  justify-content: center;
  padding: 1.2rem 0;
  font-size: 3.5rem;
  text-align: center;
  width: 100%;
  background-color: rgb(20, 0, 10);
  border-bottom: 1px solid white;
  box-shadow: 0 10px 10px 5px rgba(0, 0, 0, 0.5);
  transition: all 0.35s ease-in-out;
}

.title:hover {
  font-size: 3.6rem;
}

.container {
  width: 35vw;
  min-height: auto;
  max-height: 60vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.invitations {
  margin-top: 5.9rem;
  padding: 1.5rem 2rem 3rem 2rem;
  overflow: auto;
  height: auto;
  max-height: calc(74%);
}

.invitation {
  border-radius: 100px;
  font-size: 1.2rem;
  min-height: 5rem;
  height: 20%;
  padding-left: 1.5rem;
  margin-bottom: 2rem;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease-in;
}

.invitation:hover {
  color: white;
  font-size: 1.3rem;
}

.invitation:last-child {
  margin-bottom: 0;
}

.no-invitations {
  padding: 2rem 1rem;
  text-align: center;
  font-size: 2.2rem;
  transition: all 0.35s ease-in-out;
}

.no-invitations:hover {
  padding: 1.9rem 1.1rem;
  font-size: 2.3rem;
}

.flex {
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

@media only screen and (max-width: 1580px) {
  .invitation {
    display: flex;
    align-items: center;
    justify-content: flex-start;
  }
}

@media only screen and (max-width: 1180px) {
  .title {
    font-size: 2.5rem;
  }

  .title:hover {
    font-size: 2.6rem;
  }
}
</style>