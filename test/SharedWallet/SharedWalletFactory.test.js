const { expect } = require('chai');

const SharedWallet = artifacts.require('SharedWallet');
const SharedWalletFactory = artifacts.require('SharedWalletFactory');
const SharedWalletStorage = artifacts.require('SharedWalletStorage');

contract('SharedWalletFactory', async function (accounts) {
    const [creator] = accounts;
    const name = "test";

    describe('Deployment', async function () {
        it('should not fail', async function () {
            try {
                await SharedWalletFactory.new();
            } catch (err) {
                expect.fail(err.message);
            }
        });
    });

    describe('Storage', async function () {
        it('should be saved and a getter should be provided', async function () {
            const factory = await SharedWalletFactory.new();
            const storageAddr = await factory.walletsStorage();

            expect(await web3.eth.getCode(storageAddr)).to.not.equal('0x');
        });
    });

    describe('Creating new shared wallet', async function () {
        it('should save last created wallet address and provide a getter', async function () {
            const factory = await SharedWalletFactory.new();
            await factory.createNewSharedWallet(name, { from: creator });
            const walletAddr = await factory.lastWalletCreated();

            const wallet = await SharedWallet.at(walletAddr);
            expect(await wallet.isMember(creator)).to.be.true;
            expect(await wallet.walletsStorage()).to.equal(await factory.walletsStorage());
        });

    });

});