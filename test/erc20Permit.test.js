const { expect } = require("chai");
const { ethers } = require("hardhat");


const amount = 1000;
const deadline = ethers.constants.MaxUint256;

const getPermitSignature = async (signer, token, spender, value, deadline) => {
  const [nonce, name, version, chainId] = await Promise.all([
    token.nonces(signer.address),
    token.name(),
    "1",
    signer.getChainId(),
  ]);

  return ethers.utils.splitSignature(
    await signer._signTypedData(
      {
        name,
        version,
        chainId,
        verifyingContract: token.address,
      },
      {
        Permit: [
          {
            name: "owner",
            type: "address",
          },
          {
            name: "spender",
            type: "address",
          },
          {
            name: "value",
            type: "uint256",
          },
          {
            name: "nonce",
            type: "uint256",
          },
          {
            name: "deadline",
            type: "uint256",
          },
        ],
      },
      {
        owner: signer.address,
        spender,
        value,
        nonce,
        deadline,
      }
    )
  );
};

describe("Erc20 Permit", () => {
    it("Should run permission and send token in one transaction", async () => {
        const accounts = await ethers.getSigners(1)
        const signer = accounts[0]

        const Token = await ethers.getContractFactory("UtilityToken")
        const token = await Token.deploy()
        await token.deployed()

        const Vault = await ethers.getContractFactory("Vault")
        const vault = await Vault.deploy(token.address)
        await vault.deployed()

        await token.mint(signer.address, amount)

        const {v, r, s} = await getPermitSignature(
            signer,
            token,
            vault.address,
            amount,
            deadline
        )

        await vault.depositWithPermit(
            amount,
            deadline,
            v,
            r,
            s
        )

        const balanceOfVault = await token.balanceOf(vault.address)
        const balanceOfSigner = await token.balanceOf(signer.address)

        expect(balanceOfVault.toString()).to.equal(amount.toString())
        expect(balanceOfSigner.toString()).to.equal("0")
    })
})
