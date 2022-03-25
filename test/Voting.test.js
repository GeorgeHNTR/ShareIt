const { expect } = require('chai');

const SharedWalletFactory = artifacts.require('SharedWalletFactory');
const SharedWallet = artifacts.require('SharedWallet');

contract('SharedWallet', function (accounts) {
    const [creator, newMember] = accounts;

    beforeEach(async function () {
        this.factory = await SharedWalletFactory.new();
    });

    it('should add members without throwing', async function () {
        this.factory.newSharedWalletCreated()
            .on('data', async function (event) {
                const newSharedWalletAddress = event.returnValues.newSharedWalletAddress;
                const sharedWalletInstance = await SharedWallet.at(newSharedWalletAddress);

                sharedWalletInstance.RequestCreated()
                    .on('data', async function (event) {
                        await sharedWalletInstance.acceptInvitation(event.returnValues.requestId, { from: newMember });
                        await sharedWalletInstance.acceptRequest(event.returnValues.requestId, { from: creator });
                        await sharedWalletInstance.addMember(event.returnValues.requestId, { from: creator });
                        expect((await sharedWalletInstance.members()).length).to.equal(2);
                    });

                await sharedWalletInstance.createRequest(0, 0, newMember, { from: creator });

            });
            
        await this.factory.createNewSharedWallet();
        await new Promise((resolve, reject) => {
            setTimeout(() => {
                resolve();
            }, 60000);
        });
    });
});
