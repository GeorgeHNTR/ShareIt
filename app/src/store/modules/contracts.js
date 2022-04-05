export default {
    namespaced: true,
    state: {
        factory: undefined,
        storage: undefined
    },
    mutations: {
        factory(state, factory) {
            state.factory = factory;
        },
        storage(state, storage) {
            state.storage = storage;
        }
    },
    getters: {
        factory: (state) => state.factory,
        storage: (state) => state.storage
    },
    actions: {
        async fetchUserWallets({ getters, rootGetters }) {
            console.log(rootGetters["user/userAddress"]);
            return getters.storage.methods
                .userWallets()
                .call({
                    from: rootGetters["user/userAddress"],
                });

        }
    }
};