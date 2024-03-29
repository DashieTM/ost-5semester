#import "../../utils.typ": *

#section("Distributed Systems Repetition")
- Reasons for distributed systems
  - scaling Moores law can't go forever with big amounts of performance increases,\
    hence we need horizontal scaling -> more servers in order to properly scale
  - location When you want to access a service from japan, you don't want to talk to
    a japanese server as the ping is atrocious.\
    Instead, you talk to a server that is closer to you, e.g. Europe.
- Categories of distributed systems
  #columns(
    2,
    [
      - #text(red, size: 15pt)[controlled distributed systems]
        - 1 responsible organization
        - low churn (rate of joining and leaving in a system (ex. adding or removing
          servers))
        - examples: client/server systems, amazon dynamodb
        - relatively friendly environment (not too many bad actors expected)
        - high availability
        - can be homogeneous or heterogeneous
        - mechanisms that work well:
          - Master nodes, central coordinator
          - consistent hashing: Dynamodb, Cassandra
        - Network is under control or client/server, no NAT issues
        - Consistency
          - leader election (Zookeeper, Paxos, Raft)
        - Replication principles
          - more replicas: higher availability, higher reliability, higher performance,
            better scalability
          - requires maintaining consistency in replicas
        - transparency principles apply
      - #text(red, size: 15pt)[fully decentralized systems]
        - N responsible organizations
        - high churn
        - examples: blockchain, torrents
        - hostile environment
        - unpredictable availability
        - heterogeneous
        - mechanisms that work well:
          - consistent hashing: DHTs
          - flooding/broadcasting - Bitcoin
        - NAT connection problems
        - Consistency
          - weak consistency: DHTs
          - Nakamo Consensus ( Proof of Work )
          - Proof of Stake - leadership election, PBFT protocols
            - experts unsure
        - replication principles apply
        - transparency principles apply
    ],
  )

#subsection("Comparison to Blockchain")
In blockchain we are working with _loosely coupled_ systems that are _heterogeneous_, _decentralized_ and _large-scale systems_.\
This is the second category above.\

#subsection("Monorepo vs Polyrepo")
#columns(2, [
  #text(red, size: 15pt)[MonoRepo]
  - tight coupling of projects
    - code can easily be reused
  - everyone sees all code / commits
  - encourages code sharing within organization
  - scaling: large repos, specialized tooling (rather bad)
  #colbreak()
  #text(red, size: 15pt)[PolyRepo]
  - loose coupling
    - API etc. to access other projects, needs to be updated on both sides
  - fine-grained access control
  - encourages code sharing _across_ organizations
  - scaling: many projects, special coordination
])

#subsection("0RTT Connection")
Sends params directly with connection in order to avoid handshakes -> already
confirmed to be authentic.
#align(
  center,
  [#image("../../Screenshots/2023_09_18_02_40_35.png", width: 70%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_09_18_02_41_36.png", width: 70%)],
)

#section("Blockchain Introduction")
#subsection("Bitcoin")
- fully peer-2-peer
- maximum bitcoin is set to 21million BTC
- every transaction broadcasted to all peers
- smallest unit it 0.00000001 BTC (1 Satoshi)
- proof of work -> no double spending
- initiator is unknown -> has a nickname, called Satoshi Nakamoto
- *weak anonymity* (pseudonimity), unlike _Monero_ or others
  - all peers know transactions
  - clustering: e.g. if a transaction has multiple input addresses, assume those
    addresses belong to the same wallet
- decentralized, not controlled by a single entity
  - development community, no central bank, open source

#subsection("Wallets")
- public key is the wallet key (ECDSA 256 bit)
  - can be simplified with base58 encoding
- private key is the signing key for transactions

#subsection("Transaction")
- situation: Peer A wants to send BTC to peer B -> creates transaction message
- Transaction contains input/output
  - where BTC came from and where it goes
- Peer A broadcasts the transaction to all the peers in the network
- transaction is stored in blocks -> block is created / verified (takes around
  10min)
  - this is where the name blockchain comes from

#align(
  center,
  [#image("../../Screenshots/2023_09_25_01_39_47.png", width: 70%)],
)

#subsection("Bitcoin scripting language")
#align(
  center,
  [#image("../../Screenshots/2023_09_25_01_41_04.png", width: 100%)],
)
#text(
  teal,
)[Note, bitcoin does not support a turing complete language, this means every
  bitcoin program will halt.]

#subsubsection("Crypto Puzzles")
#align(
  center,
  [#image("../../Screenshots/2023_09_25_01_42_44.png", width: 70%)],
)
- Solved puzzles are included in transaction block
- creation of block is called mining -> uses specialized hardware these days
- each block has pointer to previous

#align(
  center,
  [#image("../../Screenshots/2023_09_25_01_45_56.png", width: 70%)],
)
#text(
  red,
)[Miner needs to change the *nonce* until the has over the entire section start
  with a *certain amount of 0s*]

#section("51% attack")
If you have 51% of the cpu power or stacking pool, you can start to manipulate
transactions in the blockchain.\
As long as *"honest chain"* is the largest, it will outcompete the other,
therefore removing the issue.\

The problem in summary:\
If you have 51% control, you can potentially change a transaction, but then
continue delivering all other transactions as normal.\
If you provide these blocks of transactions faster than the rest of the entire
blockchain, this means that the proper unchanged chain will be ignored and
eventually dropped due to your broadcasts.\
#align(
  center,
  [#image("../../Screenshots/2023_09_25_01_54_30.png", width: 70%)],
)
This attack is called *double spending*.\
#text(
  teal,
)[It is called double spending since the original transaction is also considered
  to be valid for this account, therefore, both transactions are considered until
  a certain point where your fraudulent chain is considered to be the only proper
  one. The deletion of old blocks is then called *chain reordering*]
