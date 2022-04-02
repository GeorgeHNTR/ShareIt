import store from '../store';
import Web3 from 'web3';

export default async function createWeb3() {
    if (!window.ethereum) return false;
    if (store.getters.web3) return true;

    const web3 = new Web3(Web3.givenProvider);
    store.commit("web3", web3);
    return true;
}