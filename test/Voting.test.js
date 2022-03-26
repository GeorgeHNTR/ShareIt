const { expect } = require('chai');

const SharedWalletFactory = artifacts.require('SharedWalletFactory');
const SharedWalletsStorage = artifacts.require('SharedWalletsStorage');
const SharedWallet = artifacts.require('SharedWallet');

contract('SharedWallet', function (accounts) {
    const [creator, newMember] = accounts;

    beforeEach(async function () {
        this.factory = await SharedWalletFactory.new();
        this.storage = await SharedWalletsStorage.at(await this.factory.walletsStorage());
    });

    it('should add/register members correctly', async function () {
        await this.factory.createNewSharedWallet();
        const newSharedWalletAddress = await this.factory.lastWalletCreated();
        this.wallet = await SharedWallet.at(newSharedWalletAddress);

        await this.wallet.createRequest(0, 0, newMember, { from: creator });
        const requestId = (await this.wallet.requestsCounter()) - 1;

        await this.wallet.acceptInvitation(requestId, { from: newMember });
        await this.wallet.acceptRequest(requestId, { from: creator });
        await this.wallet.addMember(requestId, { from: creator });

        expect((await this.wallet.members()).length).to.equal(2);
        expect(await this.storage.userWallets({ from: creator })).to.not.be.empty;
        expect(await this.storage.userWallets({ from: newMember })).to.not.be.empty;
        
    });
});
