<template>
  <base-modal class="container">
    <h2>Post Request</h2>
    <base-card class="stat">
      <div class="stat-title">
        <h3>Type:</h3>
      </div>
      <div class="stat-value">
        <select v-model="requestType">
          <option value="add-member">Add Member</option>
          <option value="remove-member">Remove Member</option>
          <option value="withdraw">Withdraw</option>
          <option value="destroy">Destroy</option>
        </select>
      </div>
    </base-card>
    <base-card class="stat">
      <div class="stat-title">
        <h3>{{ dataLabel }}:</h3>
      </div>
      <div class="stat-value">
        <input v-model="requestData" />
      </div>
    </base-card>
    <base-button class="requests-create" link to="/requests/new">+</base-button>
  </base-modal>
</template>

<script>
export default {
  data() {
    return {
      requestType: "withdraw",
      requestData: "",
    }
  },
  computed: {
    dataLabel() {
      return this.requestType === "withdraw" ? "Amount" : "Address"
    },
  },
}
</script>

<style scoped>
h2 {
  text-align: center;
  font-size: 4rem;
  text-shadow: 3px 3px black;
}

.container {
  overflow: visible;
  padding: 1rem 0;
  min-width: 35vw;
  max-width: 35vw;
  min-height: 45vh;
  max-height: 45vh;
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
  min-width: 36.66%;
  max-width: 36.66%;
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
  min-width: 63.33%;
  max-width: 63.33%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.stat-value input,
.stat-value select {
  cursor: default;
  overflow: hidden;
  text-overflow: ellipsis;
  color: white;
  font-size: 1.6rem;
  min-width: 100%;
  max-width: 100%;
  min-height: 100%;
  max-height: 100%;
  text-align: center;
  background-color: rgba(0, 0, 0, 0.5);
  transition: all 0.2s ease-in-out;
}

.stat-value select {
  font-size: 1.4rem;
}

.stat-value input:hover {
  font-size: 1.8rem;
}

.pointer {
  cursor: pointer;
}

.requests-create {
  position: absolute;
  left: 50%;
  bottom: 0;
  transform: translateX(-50%) translateY(50%);

  width: 8rem;
  height: 10%;

  font-size: 2rem;

  display: flex;
  align-items: center;
  justify-content: center;
}

.requests-create:hover {
  transform: translateX(-50%) translateY(50%);
  font-size: 2.5rem;
  width: 7rem;
  height: 9%;
}

</style>