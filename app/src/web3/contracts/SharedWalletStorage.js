import store from '../../store';

const SharedWalletStorageABI = [
    {
        "inputs": [],
        "name": "userWallets",
        "outputs": [
            {
                "internalType": "address[]",
                "name": "",
                "type": "address[]"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getInvitationsWallets",
        "outputs": [
            {
                "internalType": "address[]",
                "name": "",
                "type": "address[]"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getInvitationsRequestsIDs",
        "outputs": [
            {
                "internalType": "uint256[]",
                "name": "",
                "type": "uint256[]"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "_user",
                "type": "address"
            },
            {
                "internalType": "uint256",
                "name": "_requestId",
                "type": "uint256"
            }
        ],
        "name": "sendUserInvitation",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "_user",
                "type": "address"
            }
        ],
        "name": "removeUserInvitation",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "_newWallet",
                "type": "address"
            },
            {
                "internalType": "address",
                "name": "_user",
                "type": "address"
            }
        ],
        "name": "addWalletToUser",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "_oldWallet",
                "type": "address"
            },
            {
                "internalType": "address",
                "name": "_user",
                "type": "address"
            }
        ],
        "name": "removeWalletForUser",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
];

const SharedWalletStorageAt = (_address) => {
    return new store.getters.web3.eth.Contract(SharedWalletStorageABI, _address);
};

export default SharedWalletStorageAt;