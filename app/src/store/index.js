import { createStore } from 'vuex';
import user from './modules/user';
import contracts from './modules/contracts';

export default createStore({
    modules: {
        user,
        contracts,
    },
    state: {
        web3: undefined,
    },
    mutations: {
        web3(state, web3) {
            state.web3 = web3;
        },
    },
    getters: {
        web3: (state) => state.web3,
    }
});