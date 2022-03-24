const SharedWalletFactory = artifacts.require("SharedWalletFactory");

module.exports = async function (deployer, network, accounts) {
    await deployer.deploy(SharedWalletFactory);
    if(network == 'development') {
        const factory = await SharedWalletFactory.deployed();
        await factory.createNewSharedWallet();
    }
};
