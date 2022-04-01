<template>
  <base-card class="request">
    <h3 class="request-address">{{ address }}..</h3>
    <div class="request-eye">👁</div>
  </base-card>
</template>

<script>
export default {
  props: {
    addr: {
      type: String,
      required: true,
    },
  },
  computed: {
    address() {
      return this.addr && this.addr.slice(0, 10)
    },
  },
}
</script>

<style scoped>
.request {
  display: grid;
  position: relative;
  grid-template-areas: "address address eye";
  background-color: rgba(230, 15, 15, 0.185);
  width: 80%;
  height: 20%;
  /* box-shadow: 0 0 50px 5px rgba(0, 0, 0, 0.7); */
  transition: all 0.15s ease-in-out;
  cursor: pointer;

}

.request:hover {
  width: 82%;
  height: 21%;
  transform: translateY(-0.5%);
}

.request-address {
  grid-area: address;
  position: absolute;
  min-width: 66%;
  max-width: 66%;
  min-height: 100%;
  max-height: 100%;

  display: flex;
  align-items: center;
  /* justify-content: center; */
  padding-left: 15%;

  font-size: 1.2rem;
  text-shadow: 2px 2px rgb(0, 0, 0);

  border-radius: 0 20px 20px 0;
  text-overflow: ellipsis;

  transition: all 0.1s ease-in-out;
}

.request-address:hover {
  font-size: 1.22rem;
}

.request-eye {
  grid-area: eye;
  position: absolute;
  min-width: 100%;
  max-width: 100%;
  min-height: 100%;
  max-height: 100%;

  display: flex;
  align-items: center;
  justify-content: center;
  
  background: linear-gradient(
    to right,
    rgba(0, 0, 0, 0) 0,
    rgba(124, 20, 110, 0.05) 50%,
    rgba(0, 0, 0, 0) 100%
  );

  font-size: 2rem;
  text-shadow: 3px 3px 3px rgb(0, 0, 0);
  transition: all 0.2s ease-in-out;
}

.request-eye:hover {
  font-size: 2.5rem;
}
</style>