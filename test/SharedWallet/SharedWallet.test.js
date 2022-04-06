const { expect } = require('chai');

const SharedWallet = artifacts.require('SharedWallet');
const SharedWalletFactory = artifacts.require('SharedWalletFactory');
const SharedWalletStorage = artifacts.require('SharedWalletStorage');

contract('SharedWallet', function (accounts) {
    const [creator, testAddr, testAddr2, nonMember] = accounts;
    const name = 'test';
    const nullAddress = "0x0000000000000000000000000000000000000000";

    beforeEach(async function () {
        this.factory = await SharedWalletFactory.new();

        this.storageAddr = await this.factory.walletsStorage();
        this.storage = await SharedWalletStorage.at(this.storageAddr);

        await this.factory.createNewSharedWallet(name, { from: creator });
        this.walletAddr = await this.factory.lastWalletCreated();
        this.wallet = await SharedWallet.at(this.walletAddr);
    });

    describe('Upon creation', function () {
        it('should save creator as a member', async function () {
            expect((await this.wallet.members())[0]).to.equal(creator);
            expect(await this.wallet.isMember(creator)).to.be.true;
        });

        it('should save the properties passed by the factory contract and provide getters', async function () {
            expect(await this.wallet.name()).to.equal(name);
            expect(await this.wallet.walletsStorage()).to.equal(this.storageAddr);
        });

        it('should revert if empty string is passed as a name', async function () {
            try {
                await this.factory.createNewSharedWallet('', { from: creator });
                expect.fail();
            } catch (err) { }
        });
    });

    describe('Encapsulation', function () {
        it('should not provide direct access to add members option', async function () {
            try {
                await this.wallet._addMember(0);
                expect.fail();
            } catch (err) {
                expect(err.message).to.equal('this.wallet._addMember is not a function');
            }
        });

        it('should not provide direct access to remove members option', async function () {
            try {
                await this.wallet._removeMember(0);
                expect.fail();
            } catch (err) {
                expect(err.message).to.equal('this.wallet._removeMember is not a function');
            }
        });

        it('should not provide direct access to withdraw option', async function () {
            try {
                await this.wallet._withdraw(0);
                expect.fail();
            } catch (err) {
                expect(err.message).to.equal('this.wallet._withdraw is not a function');
            }
        });

        it('should not provide direct access to destroy option', async function () {
            try {
                await this.wallet._destroy(0);
                expect.fail();
            } catch (err) {
                expect(err.message).to.equal('this.wallet._destroy is not a function');
            }
        });
    });

    describe('Main functionality', function () {

        describe('Adding members', function () {
            it('should not add member who already exists', async function () {
                try {
                    await this.wallet.createRequest(0, creator, { from: creator });
                    expect.fail();
                } catch (err) { }
            });

            it('should register new member as a wallet member', async function () {
                await this.wallet.createRequest(0, testAddr, { from: creator });
                const requestId = (await this.wallet.requestsCounter()) - 1;
                await this.wallet.acceptInvitation(requestId, { from: testAddr });

                expect((await this.wallet.members())[1]).to.equal(testAddr);
                expect(await this.wallet.isMember(testAddr)).to.be.true;
                expect(await this.storage.userWallets({ from: testAddr })).to.include(this.walletAddr);
            });
        });

        describe('Removing members', function () {
            it('should not run if non-member address is passed', async function () {
                try {
                    await this.wallet.createRequest(1, nonMember, { from: creator });
                    expect.fail();
                } catch (err) { }
            });

            it('should remove member from contract and storage', async function () {
                await this.wallet.createRequest(1, creator, { from: creator });

                expect(await this.wallet.members()).to.have.lengthOf(0);
                expect(await this.wallet.isMember(creator)).to.be.false;
                expect(await this.storage.userWallets({ from: creator })).to.not.include(this.walletAddr);
            });
        });

        describe('Withdraw', function () {
            it('should not execute if asked for more money than balance', async function () {
                try {
                    await this.wallet.createRequest(2, 1, { from: creator });
                    expect.fail();
                } catch (err) { }
            });

            it('should transfer to request author', async function () {
                const walletInitialBalance = Number(await web3.eth.getBalance(this.walletAddr));
                const creatorInitialBalance = Number(await web3.eth.getBalance(creator));
                const testAddrInitialBalance = Number(await web3.eth.getBalance(testAddr));

                await this.wallet.deposit({ from: creator, value: web3.utils.toWei('1', 'ether') });

                // adding second member so he can withdraw what the creator has deposited
                await this.wallet.createRequest(0, testAddr, { from: creator });
                let requestId = (await this.wallet.requestsCounter()) - 1;
                await this.wallet.acceptInvitation(requestId, { from: testAddr });

                await this.wallet.createRequest(2, web3.utils.toWei('1', 'ether'), { from: testAddr });
                requestId = (await this.wallet.requestsCounter()) - 1;
                await this.wallet.acceptRequest(requestId, { from: creator });

                expect(Number(await web3.eth.getBalance(this.walletAddr))).to.equal(walletInitialBalance);
                expect(Number(await web3.eth.getBalance(creator))).to.be.lessThan(creatorInitialBalance);
                expect(Number(await web3.eth.getBalance(testAddr))).to.be.greaterThan(testAddrInitialBalance);
            });
        });

        describe('Destroy', function () {
            it('should delete contract code', async function () {
                await this.wallet.createRequest(3, testAddr, { from: creator });

                expect(await web3.eth.getCode(this.walletAddr)).to.equal('0x');
            });

            it('should send contract balance to request address', async function () {
                const testAddrInitialBalance = Number(await web3.eth.getBalance(testAddr));
                await this.wallet.deposit({ from: creator, value: web3.utils.toWei('1', 'ether') });
                await this.wallet.createRequest(3, testAddr, { from: creator });

                expect(Number(await web3.eth.getBalance(testAddr))).to.be.greaterThan(testAddrInitialBalance);
            });
        });

        describe('Leaving', function () {
            it('should not run if non-member calls', async function () {
                try {
                    await this.wallet.leave({ from: nonMember });
                    expect.fail();
                } catch (err) { }
            });

            it('should remove member from contract and storage', async function () {
                await this.wallet.leave({ from: creator });

                expect(await this.wallet.members()).to.have.lengthOf(0);
                expect(await this.wallet.isMember(creator)).to.be.false;
                expect(await this.storage.userWallets({ from: creator })).to.not.include(this.walletAddr);
            });
        });

    });

    describe('Validation', function () {
        beforeEach(async function () {
            // add second member so request doesn't pass immediately
            await this.wallet.createRequest(0, testAddr, { from: creator });
            this.requestId = (await this.wallet.requestsCounter()) - 1;
            await this.wallet.acceptInvitation(this.requestId, { from: testAddr });
        });

        it('should not add member if request is not approved', async function () {
            await this.wallet.createRequest(0, testAddr2, { from: creator });
            this.requestId = (await this.wallet.requestsCounter()) - 1;
            await this.wallet.acceptInvitation(this.requestId, { from: testAddr2 });
            // not accepted by 51% of member (only 50%) so it is still not approved

            expect(await this.wallet.members()).to.have.lengthOf(2); // only the creator and the first testAddr
            expect(await this.wallet.isMember(testAddr2)).to.be.false;
        });

        it('should not remove member if request is not approved', async function () {
            await this.wallet.createRequest(1, testAddr, { from: creator });
            // not accepted by 51% of member (only 50%) so it is still not approved

            // testAddr should not be removed yet
            expect(await this.wallet.members()).to.have.lengthOf(2);
            expect(await this.wallet.isMember(testAddr)).to.be.true;

        });

        it('should not withdraw if request is not approved', async function () {
            await this.wallet.deposit({ from: creator, value: 1 });
            await this.wallet.createRequest(2, 1, { from: creator });
            // not accepted by 51% of member (only 50%) so it is still not approved

            expect(await web3.eth.getBalance(this.walletAddr)).to.equal('1');
        });

        it('should not destroy if request is not approved', async function () {
            await this.wallet.createRequest(3, testAddr, { from: creator });
            // not accepted by 51% of member (only 50%) so it is still not approved

            expect(await web3.eth.getCode(this.walletAddr)).to.not.equal('0x');
        });
    });

    describe('Auto execution', function () {
        it('should auto execute add member option when voting of type 0 passes', async function () {
            await this.wallet.createRequest(0, testAddr, { from: creator });
            const requestId = (await this.wallet.requestsCounter()) - 1;
            await this.wallet.acceptInvitation(requestId, { from: testAddr }); // passes

            expect((await this.wallet.members())[1]).to.equal(testAddr);
        });

        it('should auto execute remove member option when voting of type 1 passes', async function () {
            await this.wallet.createRequest(1, creator, { from: creator });

            expect(await this.wallet.members()).to.have.lengthOf(0);
        });

        it('should auto execute withdraw option when voting of type 2 passes', async function () {
            await this.wallet.deposit({ from: creator, value: 1 });
            const balanceBeforeWithdrawal = Number(await web3.eth.getBalance(this.walletAddr));
            await this.wallet.createRequest(2, 1, { from: creator });
            const balanceAfterWithdrawal = Number(await web3.eth.getBalance(this.walletAddr));

            expect(balanceAfterWithdrawal).to.be.lessThan(balanceBeforeWithdrawal);
        });

        it('should auto execute destroy option when voting of type 3 passes', async function () {
            await this.wallet.createRequest(3, testAddr, { from: creator });
            expect(await web3.eth.getCode(this.walletAddr)).to.equal('0x');
        });
    });

    describe('Payments', function () {
        it('should accept payments from members', async function () {
            await this.wallet.deposit({ from: creator, value: 1 });
            expect(await web3.eth.getBalance(this.walletAddr)).to.equal('1');
        });

        it('should accept payments from non-members', async function () {
            await this.wallet.deposit({ from: nonMember, value: 1 });
            expect(await web3.eth.getBalance(this.walletAddr)).to.equal('1');
        });
    });

});