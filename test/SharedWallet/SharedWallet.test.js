const { expect } = require('chai');

const SharedWallet = artifacts.require('SharedWallet');
const SharedWalletFactory = artifacts.require('SharedWalletFactory');
const SharedWalletsStorage = artifacts.require('SharedWalletsStorage');

contract('SharedWallet', function (accounts) {
    const [creator] = accounts;
    const name = 'test';


    beforeEach(async function () {
        this.factory = await SharedWalletFactory.new();

        this.storageAddr = await this.factory.walletsStorage();
        this.storage = await SharedWalletsStorage.at(this.storageAddr);

        await this.factory.createNewSharedWallet(name, { from: creator });
        this.walletAddr = await this.factory.lastWalletCreated();
        this.wallet = await SharedWallet.at(this.walletAddr);
    });
});