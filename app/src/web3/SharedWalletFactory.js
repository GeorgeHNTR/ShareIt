import store from '../store';

const SharedWalletFactoryABI = [
    {
        "inputs": [],
        "stateMutability": "nonpayable",
        "type": "constructor"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": false,
                "internalType": "address",
                "name": "newSharedWalletAddress",
                "type": "address"
            }
        ],
        "name": "newSharedWalletCreated",
        "type": "event"
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
        "type": "function"
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
        "type": "function"
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

const SharedWalletFactoryAddress = '0xB24eb2c44c9ed43D9a4b1B6861e15e003CD72Cf5';

const SharedWalletFactory = () => {
    return new store.getters.web3.eth.Contract(SharedWalletFactoryABI, SharedWalletFactoryAddress);
};

export default SharedWalletFactory;