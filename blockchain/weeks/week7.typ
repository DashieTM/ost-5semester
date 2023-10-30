#import "../../utils.typ": *

#section("Wallets")
- Hot wallets
  - connected to the internet
  - more features -> easy sending and recieving of tokens
- cold wallets
  - only a key
  - does not offer any features ootb
#align(
  center,
  [#image("../../Screenshots/2023_10_30_02_24_23.png", width: 30%)],
)

#subsection("Hierarchical Deterministic (HD) Wallets")
- most cryptowallets are HD wallets
- based on the BIP32/BIP44 protocol
  - BIP32 -> Bitcoin Improvoement Proposal 32:\
    introduces the concept of hierarchical deterministic wallets
  - BIP 44: adds structure for multiple coin types and accounts
- allows creation of *derived keys from the master seed*
- features
  - generation of multiple cryptocurrency addresses
  - simplifies management and backup
  - each transaction could use a unique address for enhanced privacy -> technically
    no tracking
- Master Seed is based on the BIP39 mnemonic phrase
  - seed phrase: series of words from a defined list
  - essential for wallets backup and restoration
  - typically 12 or 24 words
  - encoding of 128bit or 256bit
- user experience: many users forget phrase -> they think it is not important ->
  wallet lost

#subsubsection("BIP39")
- 256bit encoding, 8bit checksum
- seed extension
  - 13th/25th word
- from mnemonic phrase to seed
  - PBKDF2 function with mnemonic sentence as password, string "mnemonic" +
    passphrase as salt
  - example: salt = PBKDF2("wisdom tortiose relief", "mnemonicyourpassphrase",
    2048);
- seed can be used for BIP-32
#align(
  center,
  [#image("../../Screenshots/2023_10_30_02_32_01.png", width: 100%)],
)

#subsubsection("ECC")
#align(
  center,
  [#image("../../Screenshots/2023_10_30_02_37_40.png", width: 30%)],
)
