export default {
    namespaced: true,
    state: {
        userAddress: undefined,
        chainId: undefined,
    },
    mutations: {
        userAddress(state, userAddress) {
            state.userAddress = userAddress;
        },
        chainId(state, chainId) {
            state.chainId = chainId;
        },
    },
    getters: {
        userAddress: (state) => state.userAddress,
        chainId: (state) => state.chainId,
    }
};