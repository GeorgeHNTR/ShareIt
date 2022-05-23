const { expect } = require('chai');

const SharedWallet = artifacts.require('SharedWallet');
const SharedWalletFactory = artifacts.require('SharedWalletFactory');

contract('Voting', async function (accounts) {
  const [creator, notMember, testAddr, testAddr2, randomAddr] = accounts;
  const nullAddress = "0x0000000000000000000000000000000000000000";
  const name = "test";

  beforeEach(async function () {
    this.factory = await SharedWalletFactory.new({ from: creator });
    await this.factory.createNewSharedWallet(name);
    let promiseResolver;
    const walletAddrPromise = new Promise((resolve, reject) => {
      promiseResolver = resolve;
    });
    this.factory.WalletCreated()
      .on('data', event => {
        promiseResolver(event.args.wallet);
      });
    await this.factory.createNewSharedWallet(name, { from: creator });
    this.walletAddr = await walletAddrPromise;
    this.wallet = await SharedWallet.at(this.walletAddr);

    this.fetchRequestDetails = async (_requestId) => {
      const [details, hasVoted] = await Promise.all([
        this.wallet.getRequestDetails(_requestId),
        this.wallet.checkMemberHasVotedById(_requestId)
      ]);
      return {
        author: details[0],
        type: details[1],
        data: details[2],
        invitationAccepted: details[3],
        isApproved: details[4],
        proVotersCount: details[5],
        hasVoted
      };
    };
  });

  describe('Only Members', function () {
    it('should be able to create requests', async function () {
      try {
        await this.wallet.createRequest(0, testAddr, { from: creator });
      } catch (err) {
        expect.fail(err.message);
      }

      try {
        await this.wallet.createRequest(0, testAddr, { from: notMember });
        expect.fail();
      } catch (err) { }

    });

    it('should be able to accept requests', async function () {
      // add one more member
      await this.wallet.createRequest(0, testAddr, { from: creator });
      const request1Id = (await this.wallet.requestsCounter()) - 1;
      await this.wallet.acceptInvitation(request1Id, { from: testAddr });

      await this.wallet.createRequest(0, randomAddr, { from: creator });
      const request2Id = (await this.wallet.requestsCounter()) - 1;

      try {
        await this.wallet.acceptRequest(request2Id, { from: notMember });
        expect.fail();
      } catch (err) { }

      try {
        await this.wallet.acceptRequest(request2Id, { from: testAddr });
      } catch (err) {
        expect.fail(err.message);
      }

    });
  });

  describe('Requests counter', function () {
    it('should start from 0', async function () {
      const initialCounter = await this.wallet.requestsCounter();
      expect(initialCounter.words[0]).to.equal(0);
    });

    it('should increment by 1 when request is created', async function () {
      await this.wallet.createRequest(0, testAddr, { from: creator });
      const initialCounter = await this.wallet.requestsCounter();
      expect(initialCounter.words[0]).to.equal(1);
    });
  });

  describe('Creating a request', function () {
    describe('Validation:', async function () {
      it('should throw when invalid request type index is passed', async function () {
        try {
          await this.wallet.createRequest(-1, 0);
          expect.fail();
        } catch (err) { }

        try {
          await this.wallet.createRequest(4, 0);
          expect.fail();
        } catch (err) { }
      });

      it('should throw if trying to withdraw 0 wei', async function () {
        try {
          await this.wallet.createRequest(2, 0);
          expect.fail();
        } catch (err) { }
      });

      it('should throw if trying to add/remove/destroy, but 0x0 address is provided', async function () {
        try {
          await this.wallet.createRequest(0, nullAddress);
          expect.fail();
        } catch (err) { }

        try {
          await this.wallet.createRequest(1, nullAddress);
          expect.fail();
        } catch (err) { }

        try {
          await this.wallet.createRequest(3, nullAddress);
          expect.fail();
        } catch (err) { }

      });
    });

    describe('Functionality:', async function () {
      beforeEach(async function () {
        // add new member so requests doesn't pass immediately
        await this.wallet.createRequest(0, testAddr, { from: creator });
        let requestId = (await this.wallet.requestsCounter()) - 1;
        await this.wallet.acceptInvitation(requestId, { from: testAddr });
      });

      it('should save request with correct properties - add member request type', async function () {
        await this.wallet.createRequest(0, testAddr2, { from: creator });
        const requestId = (await this.wallet.requestsCounter()) - 1;

        const {
          author: requestAuthor,
          type: requestType,
          data,
          invitationAccepted: isAccepted,
          isApproved,
          proVotersCount: requestProVotersCount,
          hasVoted
        }
          = await this.fetchRequestDetails(requestId);
        const requestAddr = '0x' + data.toString(16).padStart(40, '0');

        expect(requestAuthor).to.equal(creator);
        expect(requestType.words[0]).to.equal(0);
        expect(requestAddr).to.equal(testAddr2.toLowerCase());
        expect(requestProVotersCount.words[0]).to.equal(1);

        expect(isApproved).to.be.false;
        expect(hasVoted).to.be.true;
        expect(isAccepted.words[0]).to.equal(1);

      });

      it('should save request with correct properties - remove member request type', async function () {
        await this.wallet.createRequest(1, testAddr, { from: creator });
        const requestId = (await this.wallet.requestsCounter()) - 1;

        const {
          author: requestAuthor,
          type: requestType,
          data,
          invitationAccepted: isAccepted,
          isApproved,
          proVotersCount: requestProVotersCount,
          hasVoted
        }
          = await this.fetchRequestDetails(requestId);
        const requestAddr = '0x' + data.toString(16).padStart(40, '0');

        expect(requestAuthor).to.equal(creator);
        expect(requestType.words[0]).to.equal(1);
        expect(requestAddr).to.equal(testAddr.toLowerCase());
        expect(requestProVotersCount.words[0]).to.equal(1);

        expect(isApproved).to.be.false;
        expect(hasVoted).to.be.true;
        expect(isAccepted.words[0]).to.equal(0);

      });

      it('should save request with correct properties - withdraw request type', async function () {
        await this.wallet.deposit({ from: creator, value: 1 });
        await this.wallet.createRequest(2, 1, { from: creator });
        const requestId = (await this.wallet.requestsCounter()) - 1;

        const {
          author: requestAuthor,
          type: requestType,
          data,
          invitationAccepted: isAccepted,
          isApproved,
          proVotersCount: requestProVotersCount,
          hasVoted
        }
          = await this.fetchRequestDetails(requestId);
        const requestValue = data.toString();

        expect(requestAuthor).to.equal(creator);
        expect(requestType.words[0]).to.equal(2);
        expect(requestValue).to.equal('1');
        expect(requestProVotersCount.words[0]).to.equal(1);

        expect(isApproved).to.be.false;
        expect(hasVoted).to.be.true;
        expect(isAccepted.words[0]).to.equal(0);

      });

      it('should save request with correct properties - destroy request type', async function () {
        await this.wallet.createRequest(3, testAddr, { from: creator });
        const requestId = (await this.wallet.requestsCounter()) - 1;

        const {
          author: requestAuthor,
          type: requestType,
          data,
          invitationAccepted: isAccepted,
          isApproved,
          proVotersCount: requestProVotersCount,
          hasVoted
        }
          = await this.fetchRequestDetails(requestId);
        const requestAddr = '0x' + data.toString(16).padStart(40, '0');

        expect(requestAuthor).to.equal(creator);
        expect(requestType.words[0]).to.equal(3);
        expect(requestAddr).to.equal(testAddr.toLowerCase());
        expect(requestProVotersCount.words[0]).to.equal(1);

        expect(isApproved).to.be.false;
        expect(hasVoted).to.be.true;
        expect(isAccepted.words[0]).to.equal(0);

      });
    });

  });

  describe('Accepting a request', function () {
    describe('Add member request type:', async function () {
      beforeEach(async function () {
        await this.wallet.createRequest(0, testAddr, { from: creator }); // automatically accepted by creator
        const requestId = (await this.wallet.requestsCounter()) - 1;
        await this.wallet.acceptInvitation(requestId, { from: testAddr }); // now there are two members in this wallet
      });

      it('should not set request to approved when new member did not accept invitation although +51% accept it', async function () {
        await this.wallet.createRequest(0, randomAddr, { from: creator }); // 50% accepted
        this.requestId = (await this.wallet.requestsCounter()) - 1;

        await this.wallet.acceptRequest(this.requestId, { from: testAddr }); // 100% accepted, but not accepting invitation

        const { isApproved } = await this.fetchRequestDetails(this.requestId);
        expect(isApproved).to.be.false;
      });

      it('should not set request to approved when new member accepted invitation, but -51% accept it', async function () {

        await this.wallet.createRequest(0, randomAddr, { from: creator });
        this.requestId = (await this.wallet.requestsCounter()) - 1;
        await this.wallet.acceptInvitation(this.requestId, { from: randomAddr }); // invitation accepted, but request not

        const { isApproved } = await this.fetchRequestDetails(this.requestId);
        expect(isApproved).to.be.false;
      });

      it('should set request to approved when new member accepted invitation and +51% accept it', async function () {
        await this.wallet.createRequest(0, randomAddr, { from: creator }); // 50% accepted
        this.requestId = (await this.wallet.requestsCounter()) - 1;

        await this.wallet.acceptRequest(this.requestId, { from: testAddr }); // 100% accepted

        await this.wallet.acceptInvitation(this.requestId, { from: randomAddr });

        const { isApproved } = await this.fetchRequestDetails(this.requestId);
        expect(isApproved).to.be.true;
      });
    });

    describe('All request types:', async function () {
      beforeEach(async function () {
        // add new member so the requests doesn't pass immediately
        await this.wallet.createRequest(0, testAddr, { from: creator });
        const requestId = (await this.wallet.requestsCounter()) - 1;
        await this.wallet.acceptInvitation(requestId, { from: testAddr });

        // create withdrawal request
        await this.wallet.deposit({ value: 1, from: creator });
        await this.wallet.createRequest(2, 1, { from: creator });
        this.requestId = (await this.wallet.requestsCounter()) - 1;

      });

      describe('Validation:', function () {
        it('should throw if request is already approved', async function () {
          await this.wallet.acceptRequest(this.requestId, { from: testAddr });
          try {
            await this.wallet.acceptRequest(this.requestId, { from: creator });
            expect.fail();
          } catch (err) { }
        });

        it('should throw if member already accepted a specific request', async function () {
          try {
            await this.wallet.acceptRequest(this.requestId, { from: creator });
            expect.fail();
          } catch (err) { }
        });
      });

      describe('Functionality:', async function () {
        it('should set request to approved when +51% accept it', async function () {
          await this.wallet.acceptRequest(this.requestId, { from: testAddr });

          const { isApproved } = await this.fetchRequestDetails(this.requestId);
          expect(isApproved).to.equal(true);
        });

        it('should increment request\'s pro voters count', async function () {
          await this.wallet.acceptRequest(this.requestId, { from: testAddr });

          const { proVotersCount } = await this.fetchRequestDetails(this.requestId);
          expect(proVotersCount.words[0]).to.equal(2);
        });

        it('should save the member\'s vote', async function () {
          const { hasVoted } = await this.fetchRequestDetails(this.requestId);

          expect(hasVoted).to.be.true;
        });
      });
    });
  });

  describe('Accepting an invitation', function () {
    beforeEach(async function () {
      await this.wallet.createRequest(0, testAddr, { from: creator });
      this.requestId = (await this.wallet.requestsCounter()) - 1;
    });

    describe('Validation:', function () {
      it('should throw if invalid address', async function () {
        try {
          await this.wallet.acceptInvitation(this.requestId, { from: randomAddr });
          expect.fail();
        } catch (err) { }
      });

      it('should throw if invitation already accepted', async function () {
        await this.wallet.acceptInvitation(this.requestId, { from: testAddr });
        try {
          await this.wallet.acceptInvitation(this.requestId, { from: testAddr });
          expect.fail();
        } catch (err) { }
      });

      it('should throw if invitation already rejected', async function () {
        await this.wallet.rejectInvitation(this.requestId, { from: testAddr });
        try {
          await this.wallet.acceptInvitation(this.requestId, { from: testAddr });
          expect.fail();
        } catch (err) { }
      });

      it('should throw if invalid request id is passed', async function () {
        try {
          await this.wallet.acceptInvitation(-1, { from: testAddr });
          expect.fail();
        } catch (err) { }

        try {
          await this.wallet.acceptInvitation(2, { from: testAddr });
          expect.fail();
        } catch (err) { }
      });
    });

    describe('Functionality:', function () {
      it('should set request accepted property to 2 (Accepted)', async function () {
        await this.wallet.acceptInvitation(this.requestId, { from: testAddr });
        const { invitationAccepted: isAccepted } = await this.fetchRequestDetails(this.requestId);
        expect(isAccepted.words[0]).to.equal(2);
      });

      it('should not set request approved property to true if not +51% have already accepted it', async function () {
        await this.wallet.acceptInvitation(this.requestId, { from: testAddr });
        await this.wallet.createRequest(0, randomAddr, { from: creator });
        const requestId = (await this.wallet.requestsCounter()) - 1;
        await this.wallet.acceptInvitation(requestId, { from: randomAddr });

        const { isApproved } = await this.fetchRequestDetails(requestId);
        expect(isApproved).to.be.false;
      });

      it('should set request approved property to true if +51% have already accepted it', async function () {
        await this.wallet.acceptInvitation(this.requestId, { from: testAddr });
        const { isApproved } = await this.fetchRequestDetails(this.requestId);

        expect(isApproved).to.be.true;
      });
    });
  });

  describe('Rejecting an invitation', function () {
    beforeEach(async function () {
      await this.wallet.createRequest(0, testAddr, { from: creator });
      this.requestId = (await this.wallet.requestsCounter()) - 1;
    });

    describe('Validation:', function () {
      it('should throw if invalid address', async function () {
        try {
          await this.wallet.acceptInvitation(this.requestId, { from: randomAddr });
          expect.fail();
        } catch (err) { }
      });

      it('should throw if invitation already accepted', async function () {
        await this.wallet.acceptInvitation(this.requestId, { from: testAddr });
        try {
          await this.wallet.rejectInvitation(this.requestId, { from: testAddr });
          expect.fail();
        } catch (err) { }
      });

      it('should throw if invitation already rejected', async function () {
        await this.wallet.rejectInvitation(this.requestId, { from: testAddr });
        try {
          await this.wallet.rejectInvitation(this.requestId, { from: testAddr });
          expect.fail();
        } catch (err) { }
      });

      it('should throw if invalid request id is passed', async function () {
        try {
          await this.wallet.rejectInvitation(-1, { from: testAddr });
          expect.fail();
        } catch (err) { }

        try {
          await this.wallet.rejectInvitation(2, { from: testAddr });
          expect.fail();
        } catch (err) { }
      });
    });

    describe('Functionality:', function () {
      it('should set request accepted property to 3 (Rejected)', async function () {
        await this.wallet.rejectInvitation(this.requestId, { from: testAddr });
        const { invitationAccepted: isAccepted } = await this.fetchRequestDetails(this.requestId);
        expect(isAccepted.words[0]).to.equal(3);
      });

      it('should set request approved property to true not matter of members\' votes', async function () {
        await this.wallet.acceptInvitation(this.requestId, { from: testAddr });
        await this.wallet.createRequest(0, randomAddr, { from: creator });
        const requestId = (await this.wallet.requestsCounter()) - 1;
        await this.wallet.rejectInvitation(requestId, { from: randomAddr });

        const { isApproved } = await this.fetchRequestDetails(requestId);
        expect(isApproved).to.be.true;
      });

    });
  });

});
