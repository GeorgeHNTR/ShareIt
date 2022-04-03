import Web3 from "web3";
import store from '../store';

export default async () => {
    if (!window.ethereum) return;

    store.commit("web3", new Web3(Web3.givenProvider));
    store.commit(
        "chainId",
        await store.getters.web3.eth.net.getId()
    );

    if ((await store.getters.web3.eth.getAccounts()).length > 0) {
        const userAddress = (
            await store.getters.web3.eth.requestAccounts()
        )[0];
        store.commit("userAddress", userAddress);
    }

    window.ethereum.on("accountsChanged", (accounts) => {
        store.commit("userAddress", accounts[0]);
    });

    window.ethereum.on("chainChanged", (chainId) => {
        store.commit("chainId", chainId);
    });
};