<template>
  <base-modal class="container">
    <h2 class="title">Invitations</h2>
    <div class="invitations" :class="!members.length && 'flex'">
      <base-card class="no-invitations" v-if="!members.length">
        No Invitations Yet
      </base-card>
      <base-card v-for="member in members" :key="member" class="invitation">{{
        member
      }}</base-card>
    </div>
  </base-modal>
</template>

<script>
import SharedWalletAt from "../web3/contracts/SharedWallet"

export default {
  data() {
    return {
      members: [],
    }
  },
  computed: {
    userAddress() {
      return this.$store.getters["user/userAddress"]
    },
  },
}
</script>

<style scoped>
.title {
  position: fixed;
  padding: 1.2rem 0;
  font-size: 3.5rem;
  text-align: center;
  width: 100%;
  background-color: rgb(20, 0, 10);
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
}

.flex {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
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