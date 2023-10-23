#import "../../utils.typ": *

#section("Decentralized Autonomous Organizations DAO")
- *rules defined and executed by smart contracts*
- anyone can audit proposals
- voting is a right granted by the proposal creator
- DAO is governed entirely by it's members
  - technical upgrades
  - porject funding/treasury allocations

Example for rule: For a proposal to be valid, 50% of all members need to vote,
hence if there is a end date, if not 50% have voted, either the proposal is
void, or it's extended until 50% have voted -> guarantee thanks to blockchain.

#subsection("History")
- first DAO was a disaster financially
  - experiment was a success though
  - attacker drained 3.6 million eth
    - reentrancy attack
    - function called twice by utilizing a default function in solidity
  - blacklist introduced because of this attack

#columns(
  2,
  [
    #text(green)[Benefits]
    - decisions by individuals rather than a central authority
    - encourages participation
    - public: everything is transparent and visible
    - minimum requirement is to join, and internet ofc
    #colbreak()
    #text(red)[Downsides]
    - decisions and voting takes time
    - currently only tech-savy people participate
    - bridging blockchain with real world -> i can't transfer you a watermelon with a
      smart contract
    - security -> see "hack"...
  ],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_23_03_22_41.png", width: 80%)],
)

#align(
  center,
  [#image("../../Screenshots/2023_10_23_03_26_00.png", width: 100%)],
)

#section("Stable Coins")
- backed with another asset
  - fiat currencies
  - exchange commodities -> gold, silver etc.
  - crypto-collateralized
    - crypto asset backed stablecoins
    - algorithmic stablecoins -> don't work lmao
- used for payment -> other coins have high volatility
  - today you pay 10cardano, tomorrow 20
- fees...

#columns(
  2,
  [
    Asset-backed: CeFi
    - Coinbase, Binance, etc. need to buy fiat assets
    - central authority can blacklist addresses -> USDC
    - Example:
      - Current supply: 50 USDT, collateral 50 USD
      - User buys 20 USDT for 20 USD → stablecoin issuer mints 20 USDT, has now 70
      - USD in collateral, 70 USDT in circulation
      - User sells 30 USDT → stablecoin issuer destroys 30 USDT, transfers 30 USD
      - Problem if assets not liquid → bank-run, not enough liquidity
    #colbreak()
    Cryto-backed: DeFi
    - MakerDAO, based on other stablecoins
    - If other currencies used → need over-collaterization
    - Problem: Supply 50 DAI, collateral 1 ETH (1 ETH=50 DAI)
    - User buys 25 DAI for 0.5 ETH (collateral 1.5 ETH)
    - Price drops of ETH to 1 ETH = 10 DAI
    - User sells 15 DAI, gets 1.5 ETH (collateral 0 ETH, but 60 DAI in circulation)
    - DAI collaterization ratio: 134%
  ],
)

#subsection("Algorithmic Stablecoins")
- two currencies, one volatile, one stable
- If demand is higher for stable coin, stable coins
are minted, volatile coin can be bought back and destroyed.
- If demand is lower, then volatile coin needs to
be minted and sold to buy the stable coin. Stable coin is then destroyed.
- #text(
    red,
  )[Problem: for terraUSD, the volatile coin was massively minted and could no
    longer buy back the stable coin -> in other words, the stable coin no longer had
    a central bank to keep the price stable.]

#subsection("Collateral")
The idea is, I give someone 100ETH, which they will hold on to as a form of
guarantee, in exchange they give me another coin -> here the stable coin for
which I will also have to pay interest. Aka it is a loan, for which I also gave
them a guarantee -> instead of a report of what i earn, it's a cautionary
downpayment that i get back whenever the loan is paid off. The downpayment
however can still be staked, meaning i can still do limited amount of investing
with this money, just not sell it.

In crypto, usually when the collateral goes below a certain amount compared to
the loan, e.g. 170%, then it can be used to payback the loan and you recieve the
rest back. Problems arise when you hold on to this vault for too long and you
can't payback anymore. -> penalty applies when liquidation happens.

#align(
  center,
  [#image("../../Screenshots/2023_10_23_04_00_10.png", width: 50%)],
)

#subsection("Minting")
Creation of new blocks in the blockchain -> creating coins on the blockchain can
be considered minting -> highly minted means that a lot of coins are created.
(This can change the price of the coin) -> relevant for terraUSD problem

#section("Proof of Attendance protocol POAP")
#align(
  center,
  [#image("../../Screenshots/2023_10_23_04_14_49.png", width: 100%)],
)
