<template>
  <div class="container">
    <div class="content">
      <h1 class="heading">The Ultimate Shared Wallet Platform</h1>
    </div>
    <img src="../assets/eth.svg" />
  </div>
  <base-button class="learn-more" link to="/about">Learn More</base-button>
</template>

<style scoped>
.container {
  position: absolute;
  left: 50%;
  width: 100vw;
  top: 45%;
  transform: translateX(-50%) translateY(-50%);
  height: 50vh;
  display: grid;
  grid-template-areas: "content image";
  gap: 4rem;
}

.content {
  position: absolute;
  grid-area: content;
  left: 50%;
  top: 50%;
  transform: translateX(-50%) translateY(-50%);
  width: 100%;
  max-width: 100%;
}

.heading {
  color: white;
  font-size: 7rem;
  text-align: right;
  max-height: 100%;
  padding-left: 2rem;
  text-shadow: 5px 5px #000000;
  transition: all 0.2s ease-in-out;
}

.heading:hover {
  font-size: 7.1rem;
  transform: translateX(0.5%);
}

img {
  grid-area: image;
  position: absolute;
  max-height: 90%;
  max-width: 80%;
  top: 50%;
  left: 15%;
  transform: translateY(-50%);
  animation: move 1.4s infinite ease-in-out alternate;
  cursor: pointer;
}

.learn-more {
  text-shadow: 2px 2px #000000;
  position: absolute;
  left: 50%;
  height: 3rem;
  width: 16rem;
  font-size: 2rem;
  top: calc(45% + (50vh / 2) + 5rem);
  transform: translateX(-50%) translateY(-50%);
  transition: all 300ms ease-in-out;
}

.learn-more:hover {
  transform: translateX(-50%) translateY(-70%);
  padding: 0.75rem 1rem;
  font-size: 2.1rem;
}

@media only screen and (max-width: 1380px) {
  .heading {
    font-size: 6rem;
  }

  .heading:hover {
    font-size: 6.1rem;
  }
}

@media only screen and (max-width: 1202px) {
  .heading {
    font-size: 5rem;
  }

  .heading:hover {
    font-size: 5.1rem;
  }
  
  img {
    left: 10%;
  }
}

@media only screen and (max-width: 835px) {
  /* mobile view */
}

@keyframes move {
  from {
    transform: translateY(-50%);
  }
  to {
    transform: translateY(calc(-50% - 20px));
  }
}
</style>