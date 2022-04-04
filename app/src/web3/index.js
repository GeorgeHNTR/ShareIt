import Web3 from "web3";
import store from '../store';
import router from '../router';

export default async () => {
    if (!window.ethereum) return;
    if (store.getters.web3) return;

    const provider = Web3.givenProvider.chainId !== null
        ? Web3.givenProvider
        : 'https://ropsten.infura.io/v3/0dc62080d95a458fbcd7bd0e28a1a95d';
    store.commit("web3", new Web3(provider));

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