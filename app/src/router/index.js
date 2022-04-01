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
      component: () => import('../views/Wallets/WalletCatalog.vue')
    },
    {
      path: '/wallets/new',
      component: () => import('../views/Wallets/WalletCreate.vue')
    },
    {
      path: '/wallets/:id',
      component: () => import('../views/Wallets/WalletDetails.vue')
    },
    {
      path: '/requests/new',
      component: () => import('../views/Requests/RequestCreate.vue')
    },
    {
      path: '/requests/:id',
      component: () => import('../views/Requests/RequestDetails.vue')
    }
  ]
});

export default router;
