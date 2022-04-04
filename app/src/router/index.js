import { createRouter, createWebHistory } from 'vue-router';
import store from '../store';

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
    },
    {
      name: 'WalletCreate',
      path: '/wallets/new',
      component: () => import('../views/Wallets/WalletCreate.vue'),
    },
    {
      name: 'WalletDetails',
      path: '/wallets/:id',
      component: () => import('../views/Wallets/WalletDetails.vue'),
    },
    {
      name: 'WalletMembers',
      path: '/wallets/:id/members',
      component: () => import('../views/Wallets/WalletMembers.vue'),
    },
    {
      name: 'RequestCreate',
      path: '/requests/new',
      component: () => import('../views/Requests/RequestCreate.vue'),
    },
    {
      name: 'RequestDetails',
      path: '/requests/:id',
      component: () => import('../views/Requests/RequestDetails.vue'),
    },
    {
      name: 'Converter',
      path: '/converter',
      component: () => import('../views/Converter.vue'),
    },
    {
      name: 'NotFound',
      path: '/:pathMatch(.*)*',
      component: () => import('../views/NotFound/NotFound.vue')
    }
  ]
});

const unrestrictedRoutes = ['Home', 'About', 'Converter', 'NotFound'];
router.beforeEach(async (to, from, next) => {
  if (unrestrictedRoutes.includes(to.name)) next();
  else {
    await new Promise((resolve, reject) => {
      // waiting the web3 to set up
      // recommended: do not use less than 50ms
      setTimeout(() => { resolve(); }, 100);
    });
    if (store.getters.chainId == 3 &&
      store.getters.userAddress !== undefined) {
      next();
    } else {
      next({ name: 'NotFound' });
    }
  };
});

export default router;
