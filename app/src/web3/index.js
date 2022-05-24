import Web3 from "web3";
import router from '../router';
import store from '../store';
import SharedWalletFactory from './contracts/SharedWalletFactory';
import SharedWalletStorageAt from './contracts/SharedWalletStorage';

export async function setupWeb3() {
    if (!window.ethereum) return;
    if (store.getters.web3) return;

    store.commit("web3", new Web3(Web3.givenProvider));

    // chain id
    const chainId = await store.getters.web3.eth.net.getId();
    store.commit("user/chainId", chainId);
    window.ethereum.on("chainChanged", async (_chainId) => {
        store.commit("user/chainId", _chainId);
        if (_chainId == 3)
            await setupContracts();
        else
            router.push('/');
    });

    // user address
    if ((await store.getters.web3.eth.getAccounts()).length > 0) {
        const userAddress = (
            await store.getters.web3.eth.requestAccounts()
        )[0];
        store.commit("user/userAddress", userAddress);
    }

    window.ethereum.on("accountsChanged", (accounts) => {
        store.commit("user/userAddress", accounts[0]);
        if (!accounts[0]) router.push('/');
    });

    try {
        await setupContracts();
    } catch (err) {
        // fails if user not on ropsten
    }
};

export async function setupContracts() {
    store.commit('contracts/factory', SharedWalletFactory());
    const SharedWalletStorageAddress = await store.getters['contracts/factory'].methods.SHARED_WALLETS_STORAGE().call();
    store.commit('contracts/storage', SharedWalletStorageAt(SharedWalletStorageAddress));
}