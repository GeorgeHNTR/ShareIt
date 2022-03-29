import { createRouter, createWebHistory } from 'vue-router';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      component: () => import('../views/Home.vue')
    },
    {
      path: '/about',
      component: () => import('../views/About.vue')
    },
    {
      path: '/wallets',
      component: () => import('../views/Wallets.vue')
    }
  ]
});

export default router;
