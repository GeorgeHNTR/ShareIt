import Web3 from "web3";
import store from '../store';
import router from '../router';

export default async () => {
    if (!window.ethereum) return;
    if (window.ethereum._state.initialized === false)
        throw new Error('Ethereum provider error occurred: Try reloading the page');
    if (store.getters.web3) return;

    store.commit("web3", new Web3(Web3.givenProvider));

    // chain
    const chainId = await store.getters.web3.eth.net.getId();
    store.commit("chainId", chainId);
    window.ethereum.on("chainChanged", (_chainId) => {
        if (_chainId != 3) {
            router.push('/');
        }
        store.commit("chainId", _chainId);
    });

    // user address
    if ((await store.getters.web3.eth.getAccounts()).length > 0) {
        const userAddress = (
            await store.getters.web3.eth.requestAccounts()
        )[0];
        store.commit("userAddress", userAddress);
    }

    window.ethereum.on("accountsChanged", (accounts) => {
        if (!accounts[0]) {
            router.push('/');
        }
        store.commit("userAddress", accounts[0]);
    });
};