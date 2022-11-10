// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract VerifySignature {
    /**
     *@dev  get message hash
     *@param _to: address of message recipient
     *@param _amount: amount to be sent
     *@param _message: the message to be sent with transaction
     *@param _nonce: sender account transaction nonce
     */
    function getMessageHash(
        address _to,
        uint _amount,
        string memory _message,
        uint _nonce
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
    }

    /**
     *@dev  returns the hash of the signed message
     *@param _messageHash: the signed message to be hashed
     */
    function getSignedMessageHash(bytes32 _messageHash)
        public
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    _messageHash
                )
            );
    }

    /**
     *@dev verify transaction is signed by who said he signed it
     *@param _signer: signers address
     *@param _to: recipient address
     *@param _amount: amount sent with the transaction
     *@param _message: message sent with the transaction
     *@param _nonce: transaction nonce
     *@param signature: the signature to be verified
     */
    function verify(
        address _signer,
        address _to,
        uint _amount,
        string memory _message,
        uint _nonce,
        bytes memory signature
    ) public pure returns (bool) {
        bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);
        bytes32 ethSignedMessageHash = getSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, signature) == _signer;
    }

    /**
     *@dev recover signer address
     *@param _ethSignedMessageHash the onchain message hash
     *@param _signature: the signer signature
     */
    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
        public
        pure
        returns (address)
    {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig)
        public
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(sig.length == 65, "invalid signature length");

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }
}
