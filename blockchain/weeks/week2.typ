#import "../../utils.typ": *

#section("Ethereum")
- Generalized Blokchain
- turing complete programming language for smart contracts etc.
- proof of work previously, soon proof of stake
- block creation time 14-15s
  - during forks -> (updates) chain will be made read-only
  - read-only via making new blocks *extremely expensive*
#subsection("GAS")
This refers to the *fees* that you pay when using transactions or smart
contracts.\
GAS is handled by time, which means you have to pay a certain amount of ETH to
make a contract work.\
Should you not be able to pay enough GAS for the transaction or smart contract
to complete, then your transaction is lost and no ETH will be refunded.

#subsection("Bitcoin UTXO vs Ethereum Account")
#align(
  center,
  [#image("../../Screenshots/2023_09_25_02_05_56.png", width: 70%)],
)
- ETH works like a bank account -> enough balance, then it's fine
- Bitcoin works with a flag in the bitcoin -> spent flag

#section("Smart Contract")
- *program must be deterministic*, each block must calculate the same result
  - random numbers via current time can't be used
  - special ways of using random numbers exist
- blockchain specific language, or compatible must be used
- either develop everything yourself (not recommended)
- or use *standards* in order to provide interblockchain functionality as well
  - ERC (Ethereum Request for Comments)\
    Standards for ethereum with which you can also create your own cryptocurrency
    via ethereum.\
    Aka the root of all shitcoins\
    *solidity* is made with this

Example for a smart contract using *solidity* for ethereum ```sol
pragma solidity ^0.8.21;

contract Notary {

 mapping (address => mapping (bytes32 => uint256)) stamps;

 function store(bytes32 hash) public {
 stamps[msg.sender][hash] = block.timestamp;
 }

 function verify(address recipient, bytes32 hash) public view returns (uint) {
 return stamps[recipient][hash];
 }
}
```

#subsection("Non Fungible Token (NFT)")
- defined in ERC21
- unique in the blockchain
  - guarantees that a digital asset is unique and not interchangeable
  - Can be any digital data that can be hashed -> only hash is stored on the chain
  - with NFT: proof of ownership (you can copy the data, but the ownership remains)
