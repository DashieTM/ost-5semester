#import "../../utils.typ": *

#section("Monero")
- not really traceable
  - senders and receivers are obscure
  - ring signatures and stealth addresses
- focus on privacy
- decentralized
- launched in 2014 as a fork of bytecoin
- hard forks usually each 6 months
  - hard forks usually to improve privacy,efficiency,etc. -> ring confidential
    transactions (RingCT) or bulletproofs
- Proof of work
  - Uses RandomX, a PoW algorithm optimized for CPUs, resistance to ASIC mining

#subsection("XMR (A single monero coin)")
- key features
  - ring signatures
    - mix a users account keys with public keys from the blockchain -> impossible to
      identify sender
  - fungibility: Monero coin is interchangeable and indistinguishable from another
  - adaptive block size limit: Unlike bitcoin, monero has no predefined block size
    limit
- criticism
  - intractability also means illegal activities can't be traced
    - good for guaranteeing freedom
    - bad as it gives harder crimes(homocide etc.) a way to use money without risk
  - regulations essentially impossible

#subsection("Differences to other currencies")
- dynamic max block size instead of limited blocksize like bitcoin
  - privacy features can lead to larger transactions
- fungibility -> can't create tainted coins like with bitcoin

#subsection("Ring Signatures")
- conceal sender by mixing in public addresses of transactions
- outside observers can't tell which user initiated transaction

#subsection("Bulletproofs")
- non-interactive, zero-knowledge proof, to prove a number (transaction amount)
  without revealing it
  - e.g. hide transaction amount
- reduce transaction size(and hence fees) and improve speed

#subsection("Stealth Addresses")
- one-time addresses, generated randomly for each transaction on behalf of the
  recipient
  - ensures destination of transaction remains hidden
- combination of the sender's, the recipient's public keys and random data
  - made in a way that the transactions can only be found with the recipient's
    private keys

#subsection("Kovri")
- Similar to TOR, but focus on creating an anonymous internal network

#section("Cross-chain Atomic Swaps")
You can of course simply use a central exchange, but here is the problem that
you don't actually own the tokens, you own them indirectly with you owning a
value on the exchange.\
The problem here is that when the exhange goes down, you are fucked, aka your
money is gone. Also, you can never ensure what the exchange is doing is 100%
fair.\
So what is the solution? Atomic swaps, simply remove the exchange as a
midle-man.
#align(
  center,
  [#image("../../Screenshots/2023_11_20_03_24_12.png", width: 70%)],
)

#subsection("Swapping over hash")
The idea is that you hash a secret and store it in a smart contract. This smart
contract can the only be unlocked(hash lock) if the same secret is provided, or
rather if the same hash is provided. E.g. we put our coins into the smart
contract with the hash and unlock it when we both accept the transaction -> you
get my btc and i get your monero or whatever you want to swap.
#align(
  center,
  [#image("../../Screenshots/2023_11_20_03_38_02.png", width: 100%)],
)
#text(
  teal,
)[Important: Since this requires the transaction to be atomic, we need a way to
  reverse the transaction, hence we provide a timeout for the smart contract to
  automatically reverse.]
#align(
  center,
  [#image("../../Screenshots/2023_11_20_03_40_36.png", width: 100%)],
)
#subsubsection("Example")
#align(
  center,
  [#image("../../Screenshots/2023_11_20_03_46_11.png", width: 100%)],
)
#text(
  teal,
)[Note, both blockchains have their own smart contract! E.g. both can specify
  their timeout themselves. You essentially have to create a smart contract when
  you want to trade with another existing smart contract (aka the offer here from
  alice).]

#subsubsection("Worst Case Problem")
One problem exists with this method, since we have 2 smart contracts, both
parties need to access their secret that was provided by the other party, if
they don't, then the smart contract of the other party automatically expires,
e.g. the other party gets their money back and you in this case get nothing...
#align(
  center,
  [#image("../../Screenshots/2023_11_20_03_55_56.png", width: 100%)],
)

#subsection("Hashed Time Lock Contracts")
Essentially the stuff above but put into a "term".
#align(
  center,
  [#image("../../Screenshots/2023_11_20_03_45_24.png", width: 100%)],
)

#subsection("Scalability Issues")
- on-chain solutions
  - sharding: distribute storage
  - protocol improvements
- off-chain solutions
  - state channels(payment channels)
    - lightning network
  - sidechains/blockchain interoperability

#subsection("Direct Payment Channel with 2-of-2 Multisig Contracts")
#text(
  teal,
)[This essentially solves the issue from before where bob goes offline. However,
  this requires a payment channel! Aka might not work on swapping!]
#align(
  center,
  [#image("../../Screenshots/2023_11_20_04_06_10.png", width: 50%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_20_04_06_33.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_20_04_09_18.png", width: 100%)],
)

#subsection("Indirect Payment Channel with HTLC")
Send btc from alice to charlie with bob as middle-man:
#align(
  center,
  [#image("../../Screenshots/2023_11_20_04_10_16.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_20_04_11_02.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_20_04_11_17.png", width: 60%)],
)

