import Web3 from "web3";
import store from '../store';
import router from '../router';

export default async () => {
    if (!window.ethereum) return;
    if (store.getters.web3) return;

    store.commit("web3", new Web3(Web3.givenProvider));

    // chain
    const chainId = await store.getters.web3.eth.net.getId();
    store.commit("chainId", chainId);
    window.ethereum.on("chainChanged", (_chainId) => {
        store.commit("chainId", _chainId);
        if (_chainId != 3) {
            router.push('/');
        }
    });

    // user address
    if ((await store.getters.web3.eth.getAccounts()).length > 0) {
        const userAddress = (
            await store.getters.web3.eth.requestAccounts()
        )[0];
        store.commit("userAddress", userAddress);
    }

    window.ethereum.on("accountsChanged", (accounts) => {
        store.commit("userAddress", accounts[0]);
        if (!accounts[0]) {
            router.push('/');
        }
    });
};