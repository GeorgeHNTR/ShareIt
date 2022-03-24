const SharedWalletFactory = artifacts.require("SharedWalletFactory");
const SharedWalletsStorage = artifacts.require("SharedWalletsStorage");

module.exports = function (deployer, network, accounts) {
    deployer.deploy(SharedWalletsStorage);
    deployer.deploy(SharedWalletFactory);
};
