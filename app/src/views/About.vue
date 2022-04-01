<template>
  <section class="container">
    <base-card class="mission">
      <article>
        <h2>Mission</h2>
        <p>
          Lorem ipsum dolor sit, amet consectetur adipisicing elit. Maiores odit
          ullam doloremque cupiditate labore aliquid corrupti cum culpa optio
          molestiae alias facere ipsa non ex, eaque assumenda. Quidem, dolorem
          ducimus? Lorem ipsum dolor sit, amet consectetur adipisicing elit.
          Maiores odit ullam doloremque cupiditate labore aliquid corrupti cum
          culpa optio molestiae alias facere ipsa non ex, eaque assumenda.
          Quidem, dolorem ducimus?
        </p>
        <p>
          Lorem ipsum dolor sit, amet consectetur adipisicing elit. Maiores odit
          ullam doloremque cupiditate labore aliquid corrupti cum culpa optio
          molestiae alias facere ipsa non ex, eaque assumenda. Quidem, dolorem
          ducimus?
        </p>
        <p>
          Lorem ipsum dolor sit, amet consectetur adipisicing elit. Maiores odit
          ullam doloremque cupiditate labore aliquid corrupti cum culpa optio
          molestiae alias facere ipsa non ex, eaque assumenda. Quidem, dolorem
          ducimus? Lorem ipsum dolor sit, amet consectetur adipisicing elit.
          Maiores odit ullam doloremque cupiditate labore aliquid corrupti cum
          culpa optio molestiae alias facere ipsa non ex, eaque assumenda.
          Quidem, dolorem ducimus?
        </p>
      </article>
    </base-card>
    <div id="separator"></div>
    <aside>
      <base-card class="use">
        <article>
          <h2>How to use</h2>
          <p>
            Lorem ipsum dolor, sit amet consectetur adipisicing elit. Corporis
            porro, quibusdam consequuntur perferendis sequi, eaque reprehenderit
            laborum maxime nobis dolor hic maiores, nisi facere doloremque
            dolores quas itaque eius voluptates.
          </p>
          <p>
            Lorem ipsum dolor, sit amet consectetur adipisicing elit. Corporis
            porro, quibusdam consequuntur perferendis sequi, eaque reprehenderit
            laborum maxime nobis dolor hic maiores, nisi facere doloremque
            dolores quas itaque eius voluptates.
          </p>
        </article>
      </base-card>
      <base-card class="guide">
        <article>
          <h2>Metamask</h2>
          <a href="https://metamask.io/" target="_blank"
            >https://metamask.io/</a
          >
        </article>
      </base-card>
    </aside>
  </section>
  <base-card> </base-card>
</template>

<style scoped>
.card {
  padding: 0;
  word-break: break-word;
  cursor: pointer;
  transition: max-width 1s ease-in-out, min-width 1s ease-in-out,
    max-height 1s ease-in-out, min-height 1s ease-in-out;
  background-color: rgba(230, 15, 15, 0.185);
}
.card:hover {
  min-width: 102%;
  max-width: 102%;
  min-height: 102%;
  max-height: 102%;
  transform: translateX(-1%) translateY(-1%);
}

.container {
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translateX(-50%) translateY(-50%);

  min-width: 55vw;
  max-width: 55vw;
  height: 65vh;

  display: grid;
  grid-template-areas: "mission aside";
  gap: 5vw;
}

aside {
  grid-area: aside;
  min-width: calc((55vw - 5vw) / 2);
  max-width: calc((55vw - 5vw) / 2);
  min-height: 100%;
  max-height: 100%;

  display: grid;
  grid-template-areas: "." "use" "use" "guide" ".";
  gap: 2rem;
}

.mission {
  grid-area: mission;
}

.use {
  grid-area: use;
}

.use p {
  max-width: calc((55vw - 5vw) / 2);
  max-height: 100%;
}

.guide {
  grid-area: guide;
}

.guide article {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

article {
  padding: 2rem 3rem;
}

p {
  overflow: hidden;
  display: inline-block;
  text-overflow: ellipsis;
}

h2 {
  text-shadow: 4px 4px #000000;
  font-size: 4rem;
  text-align: center;
  margin-bottom: 1.5rem;
}

a {
  color: white;
  min-width: 100%;
  max-width: 100%;
  text-align: center;
}

#separator {
  position: absolute;
  left: 50%;
  min-width: 0.5rem;
  max-width: 0.5rem;
  border-radius: 5px;
  top: 50%;
  transform: translateX(-50%) translateY(-50%);
  height: 62vh;
  background: linear-gradient(
    rgb(140, 5, 250),
    rgb(49, 1, 45),
    rgb(140, 5, 250)
  );
}

@media only screen and (max-width: 1510px) {
  h2 {
    font-size: 2rem;
  }
  article {
    padding: 2rem 1.5rem;
  }
}

@media only screen and (max-width: 1088px) {
  /* mobile view */
}
</style>