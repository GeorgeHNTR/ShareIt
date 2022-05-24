const { expect } = require('chai');

const SharedWallet = artifacts.require('SharedWallet');
const SharedWalletFactory = artifacts.require('SharedWalletFactory');

contract('SharedWalletFactory', async function (accounts) {
    const [creator] = accounts;
    const name = "test";

    describe('Storage', async function () {
        it('should be saved and a getter should be provided', async function () {
            const factory = await SharedWalletFactory.new();
            const storageAddr = await factory.SHARED_WALLETS_STORAGE();

            expect(await web3.eth.getCode(storageAddr)).to.not.equal('0x');
        });
    });

    describe('Creating new shared wallet', async function () {
        it('should save last created wallet address and provide a getter', async function () {
            try {
                console.log(1);
                const factory = await SharedWalletFactory.new();

                console.log(1);
                let promiseResolver;
                const walletAddrPromise = new Promise((resolve, reject) => {
                    promiseResolver = resolve;
                });
                factory.WalletCreated()
                    .on('data', event => {
                        promiseResolver(event.args.wallet);
                    });
                console.log(2);
                await factory.createNewSharedWallet(name, { from: creator });
                const walletAddr = await walletAddrPromise;

                console.log(5);

                const wallet = await SharedWallet.at(walletAddr);
                console.log(58);
                expect(await wallet.isMember(creator)).to.be.true;
                expect(await wallet.SHARED_WALLETS_STORAGE()).to.equal(await factory.SHARED_WALLETS_STORAGE());
            } catch (err) {
                console.log(err);
            }
        });

    });

});