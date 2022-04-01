<template>
  <base-modal class="container">
    <h2>Request Details</h2>
    <div class="stats">
      <stat-card
        text="Type"
        value="Add Member"
        class="details-balance"
      ></stat-card>
      <stat-card
        text="Members"
        value="7"
        class="details-members"
      ></stat-card>
      <stat-card
        text="Members"
        value="7"
        class="details-members"
      ></stat-card>
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
  padding: 2rem 0;
  height: 80%;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-evenly;
}
</style>