import { createRouter, createWebHistory } from 'vue-router';
import setupWeb3 from '../web3';
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
      name: 'NotFound',
      path: '/:notFound',
      component: () => import('../views/NotFound/NotFound.vue')
    }
  ]
});

const unrestrictedRoutes = ['Home', 'About', 'NotFound'];
router.beforeEach(async (to, from, next) => {
  if (unrestrictedRoutes.includes(to.name)) next();
  else {
    await new Promise((resolve, reject) => {
      setTimeout(() => { resolve(); }, 200);
    }); 
    if (store.getters.chainId == 3 &&
      store.getters.userAddress !== undefined) {
      next();
    } else {
      next({ path: '404' });
    }
  };
});

export default router;
