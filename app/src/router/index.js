import { createRouter, createWebHistory } from 'vue-router';
import store from '../store';
import { setupWeb3 } from "../web3";

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes: [
    {
      name: 'Home',
      path: '/',
      component: () => import('../views/Home.vue'),
      meta: [
        {
          title: 'ShareIt'
        }
      ]
    },
    {
      name: 'About',
      path: '/about',
      component: () => import('../views/About.vue'),
      meta: [
        {
          title: 'About'
        }
      ]
    },
    {
      name: 'WalletCatalog',
      path: '/wallets',
      component: () => import('../views/Wallets/WalletCatalog.vue'),
      meta: [
        {
          title: 'Your Wallets'
        }
      ]
    },
    {
      name: 'WalletCreate',
      path: '/wallets/new',
      component: () => import('../views/Wallets/WalletCreate.vue'),
      meta: [
        {
          title: 'Create Wallet'
        }
      ]
    },
    {
      name: 'WalletDetails',
      path: '/wallets/:id',
      component: () => import('../views/Wallets/WalletDetails.vue'),
      meta: [
        {
          title: 'Wallet'
        }
      ]
    },
    {
      name: 'WalletMembers',
      path: '/wallets/:id/members',
      component: () => import('../views/Wallets/WalletMembers.vue'),
      meta: [
        {
          title: 'Members'
        }
      ]
    },
    {
      name: 'WalletDeposit',
      path: '/wallets/:id/deposit',
      component: () => import('../views/Wallets/WalletDeposit.vue'),
      meta: [
        {
          title: 'Deposit'
        }
      ]
    },
    {
      name: 'RequestCreate',
      path: '/wallets/:id/requests/new',
      component: () => import('../views/Requests/RequestCreate.vue'),
      meta: [
        {
          title: 'Create Request'
        }
      ]
    },
    {
      name: 'RequestDetails',
      path: '/wallets/:walletId/requests/:requestId',
      component: () => import('../views/Requests/RequestDetails.vue'),
      meta: [
        {
          title: 'Request'
        }
      ]
    },
    {
      name: 'Invitations',
      path: '/invitations',
      component: () => import('../views/Invitations/Invitations.vue'),
      meta: [
        {
          title: 'Invitations'
        }
      ]
    },
    {
      name: 'InvitationControls.vue',
      path: '/invitations/:walletId/:requestId',
      component: () => import('../views/Invitations/InvitationControls.vue'),
      meta: [
        {
          title: 'Invitation'
        }
      ]
    },
    {
      name: 'Converter',
      path: '/converter',
      component: () => import('../views/Converter.vue'),
      meta: [
        {
          title: 'Converter'
        }
      ]
    },
    {
      name: 'NotFound',
      path: '/:pathMatch(.*)*',
      component: () => import('../views/NotFound/NotFound.vue'),
      meta: [
        {
          title: '404'
        }
      ]
    }
  ]
});

const unrestrictedRoutes = ['Home', 'About', 'Converter', 'NotFound'];
router.beforeEach(async (to, from, next) => {
  // DO NOT CHANGE 
  if (unrestrictedRoutes.includes(to.name)) next();
  await setupWeb3();
  if (!unrestrictedRoutes.includes(to.name)) {
    if (store.getters['user/chainId'] == 3 &&
      store.getters['user/userAddress'] !== undefined) {
      next();
    } else {
      next({ name: 'NotFound' });
    }
  }
});

export default router;
