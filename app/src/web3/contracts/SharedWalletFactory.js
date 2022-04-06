import store from '../../store';

const SharedWalletFactoryABI = [
  {
    "inputs": [],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "inputs": [],
    "name": "lastWalletCreated",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "walletsStorage",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [
      {
        "internalType": "string",
        "name": "_name",
        "type": "string"
      }
    ],
    "name": "createNewSharedWallet",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
];

const SharedWalletFactoryAddress = '0xaaCf3361c0EeD23a679d27D30f2CaEeae3b1C20E';

const SharedWalletFactory = () => {
  return new store.getters.web3.eth.Contract(SharedWalletFactoryABI, SharedWalletFactoryAddress);
};

export default SharedWalletFactory;