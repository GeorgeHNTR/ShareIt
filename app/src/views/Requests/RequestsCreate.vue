<template>
  <base-modal class="form">
    <h2>
      Create a <br />
      New Shared Wallet
    </h2>
    <p>
      Lorem ipsum dolor sit amet, consectetur adipisicing elit. Soluta fuga
      sequi molestiae possimus. Tenetur officiis aspernatur magni quibusdam quae
      vero repellendus vel repudiandae quas perspiciatis! Commodi sunt beatae
      mollitia! Quod! Lorem ipsum dolor sit amet, consectetur adipisicing elit.
    </p>
    <base-button id="submit">Create now</base-button>
  </base-modal>
</template>

<style scoped>
.form {
  background-color: rgba(0, 0, 0, 0.3);
  overflow: visible;
  display: flex;
  flex-direction: column;
  justify-content: space-evenly;
  padding-bottom: 4rem;
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
}

p:hover {
  color: rgb(240, 240, 240);
  font-size: 1.65rem;
  transform: translateY(-5%);
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
</style>