const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Verify Signature", () => {
  it("Should return the right hash and signature", async () => {
    const accounts = await ethers.getSigners(2);
    const VerifySignature = await ethers.getContractFactory("VerifySignature");

    const contract = await VerifySignature.deploy();
    await contract.deployed();

    const signer = accounts[0];
    const to = accounts[1];
    const amount = 999;
    const message = "Hello";
    const nonce = 123;

    const hash = await contract.getMessageHash(
      to.address,
      amount,
      message,
      nonce
    );

    const sig = await signer.signMessage(ethers.utils.arrayify(hash));

    const ethHash = await contract.getSignedMessageHash(hash);
    const recoverSigner = await contract.recoverSigner(ethHash, sig);

    expect(recoverSigner == signer.address);

    expect(
      await contract.verify(
        signer.address,
        to.address,
        amount,
        message,
        nonce,
        sig
      )
    ).to.equal(true);

    // Ascertain that any alteration to the component of a signature will return false.
    expect(
      await contract.verify(
        signer.address,
        to.address,
        amount,
        message,
        nonce + 1,
        sig
      )
    ).to.equal(false);
  });
});
