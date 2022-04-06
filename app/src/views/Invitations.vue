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
      console.log(this.userAddress)
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

      console.log(wallets)
      console.log(requestsIDs)

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
  max-width: 100%;
  display: flex;
  align-items: center;
  overflow: hidden;
  text-overflow: ellipsis;
  justify-content: center;
  text-align: center;
  transition: all 0.3s ease-in;
  margin-bottom: 2rem;
  cursor: pointer;
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
</style>