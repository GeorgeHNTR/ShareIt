const SharedWalletFactory = artifacts.require("SharedWalletFactory");

module.exports = async function (deployer) {
    await deployer.deploy(SharedWalletFactory);
};
