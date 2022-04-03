import { createRouter, createWebHistory } from 'vue-router';
import store from '../store';

const chainGuard = (to, from, next) => {
  if (store.getters.chainId == 3 || store.getters.chainId == undefined) {
    next();
  } else {
    next({ path: '404' });
  }
};

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes: [
    {
      name: 'Home',
      path: '/',
      component: () => import('../views/Home.vue')
    },
    {
      name: 'About',
      path: '/about',
      component: () => import('../views/About.vue')
    },
    {
      name: 'WalletCatalog',
      path: '/wallets',
      component: () => import('../views/Wallets/WalletCatalog.vue'),
      beforeEnter: [chainGuard]
    },
    {
      name: 'WalletCreate',
      path: '/wallets/new',
      component: () => import('../views/Wallets/WalletCreate.vue'),
      beforeEnter: [chainGuard]
    },
    {
      name: 'WalletDetails',
      path: '/wallets/:id',
      component: () => import('../views/Wallets/WalletDetails.vue'),
      beforeEnter: [chainGuard]
    },
    {
      name: 'RequestCreate',
      path: '/requests/new',
      component: () => import('../views/Requests/RequestCreate.vue'),
      beforeEnter: [chainGuard]
    },
    {
      name: 'RequestDetails',
      path: '/requests/:id',
      component: () => import('../views/Requests/RequestDetails.vue'),
      beforeEnter: [chainGuard]
    },
    {
      name: 'NotFound',
      path: '/:notFound',
      component: () => import('../views/NotFound/NotFound.vue')
    }
  ]
});

export default router;
