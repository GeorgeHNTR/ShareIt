const { expect } = require('chai');

const SharedWallet = artifacts.require('SharedWallet');
const SharedWalletFactory = artifacts.require('SharedWalletFactory');
const SharedWalletsStorage = artifacts.require('SharedWalletsStorage');


contract('SharedWalletsStorage', function (accounts) {
    const [creator, newMember, nonMember] = accounts;

    beforeEach(async function () {
        this.factory = await SharedWalletFactory.new();

        this.storageAddr = await this.factory.walletsStorage();
        this.storage = await SharedWalletsStorage.at(this.storageAddr);

        await this.factory.createNewSharedWallet({ from: creator });
        this.walletAddr = await this.factory.lastWalletCreated();
        this.wallet = await SharedWallet.at(this.walletAddr);

    });

    describe('Only wallet member', function () {
        it.only('should be able to add wallet address in their own list', async function () {
            // him
            await this.wallet.createRequest(0, 0, newMember, { from: creator });
            const requestId = (await this.wallet.requestsCounter()) - 1;
            await this.wallet.acceptRequest(requestId, { from: creator });
            await this.wallet.acceptInvitation(requestId, { from: newMember });

            expect((await this.storage.userWallets({ from: newMember }))[0]).to.equal(this.walletAddr);

            // others
            try {
                await this.storage.addWalletToUser(this.walletAddr, nonMember);
                expect.fail();
            } catch (err) { }
        });

    });
});