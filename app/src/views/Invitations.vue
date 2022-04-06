<template>
  <base-modal class="invitations">
    <base-card class="no-invitations" v-if="!members.length">
      No Invitations Yet
    </base-card>
    <base-card v-for="member in members" :key="member" class="invitation">{{
      member
    }}</base-card>
  </base-modal>
</template>

<script>
import SharedWalletAt from "../web3/contracts/SharedWallet"

export default {
  data() {
    return {
      members: [
        "0xFA3AB3F3ac1d8080FD2608A187a2dc94b2C459DA",
        "0xFA3AB3F3ac1d8080FD2608A187a2dc94b2C459DA",
        "0xFA3AB3F3ac1d8080FD2608A187a2dc94b2C459DA",
        "0xFA3AB3F3ac1d8080FD2608A187a2dc94b2C459DA",
        "0xFA3AB3F3ac1d8080FD2608A187a2dc94b2C459DA",
      ],
    }
  },
}
</script>

<style scoped>
.invitations {
  width: 35vw;
  padding: 3rem 2rem;
  overflow: auto;
  height: auto;
  max-height: 45vh;
}

.invitation {
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
  min-height: 100%;
  max-height: 100%;
  padding: 2rem;
  text-align: center;
  font-size: 2.2rem;
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