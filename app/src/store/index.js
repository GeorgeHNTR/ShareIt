import { createStore } from 'vuex';

export default createStore({
    state: {
        web3: undefined,
        userAddress: undefined,
        chainId: undefined,
        factory: undefined,
        storage: undefined
    },
    mutations: {
        web3(state, web3) {
            state.web3 = web3;
        },
        userAddress(state, userAddress) {
            state.userAddress = userAddress;
        },
        chainId(state, chainId) {
            state.chainId = chainId;
        },
        factory(state, factory) {
            state.factory = factory;
        },
        storage(state, storage) {
            state.storage = storage;
        }
    },
    getters: {
        web3: (state) => state.web3,
        userAddress: (state) => state.userAddress,
        chainId: (state) => state.chainId,
        factory: (state) => state.factory,
        storage: (state) => state.storage
    }
});