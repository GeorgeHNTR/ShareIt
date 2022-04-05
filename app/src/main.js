import { createApp } from 'vue';
import App from './App.vue';

import router from './router';
import store from './store';


import BaseCard from './components/UI/BaseCard.vue';
import BaseButton from './components/UI/BaseButton.vue';
import BaseModal from "./components/UI/BaseModal.vue";
import BaseLoader from "./components/UI/BaseLoader.vue";

const app = createApp(App);

app.use(router);
app.use(store);

app.component('base-card', BaseCard);
app.component('base-button', BaseButton);
app.component('base-modal', BaseModal);
app.component('base-loader', BaseLoader);

app.mount('#app');
