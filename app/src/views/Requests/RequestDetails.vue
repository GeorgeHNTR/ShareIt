<template>
  <base-modal class="container">
    <h2>Request Details</h2>
    <div class="stats">
      <stat-card text="By:" value="0xA153.." class="stats-card"></stat-card>
      <stat-card text="Type:" value="Withdraw" class="stats-card"></stat-card>
      <stat-card text="Data:" value="0.12" class="stats-card"></stat-card>
    </div>
  </base-modal>
</template>

<script>
import StatCard from "../../components/Stat/StatCard.vue"

export default {
  components: { StatCard },
}
</script>


<style scoped>
h2 {
  text-align: center;
  font-size: 3.15rem;
}

.stats {
  position: relative;
  padding: 2rem 0;
  height: 80%;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-evenly;
}

.stats-card {
  font-size: 2rem;
  padding: 0;
  max-height: 5%;
  transition: all 0.2s ease-in-out;
}

</style>