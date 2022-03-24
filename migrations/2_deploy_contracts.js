const SharedWalletFactory = artifacts.require("SharedWalletFactory");

module.exports = async function (deployer, network, accounts) {
    await deployer.deploy(SharedWalletFactory);
};
