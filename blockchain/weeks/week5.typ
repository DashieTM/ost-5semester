#import "../../utils.typ": *

#section("Dezentralized Finance (DEFI)")

#subsection("Centralized Finance (CEFI)")
- fiat currencies -> USD, CHF etc
- gold, percious metals etc.
- perls
- first seen in mesopotamia -> clay tokens

#subsection("DEFI differences")
- trade of assets without intermediary -> the blockchain handles trust
- transparency
  - public rules and protocols
  - avoid private agreements, back deals and centralization
- control
  - DeFi gives more control to its users. No-one should be able to censor, move or
    destroy users assets
- accessibility
  - anyone with a computer, internet connection and know-how can use or create DeFi
    products
    - mainly referred to creating DeFi -> much easier than creating a bank

#subsubsection("Flash Loan")
A small interest free loan meant for use inside of a contract by developers ->
take a loan, do the transaction of the contract, then pay the money back.

Flash loans are always paid back, if the transaction fails, then the tokens are
returned, this is because of atomicity of a contract.

#subsubsection("Truly DeFi?")
#align(
  center,
  [#image("../../Screenshots/2023_10_16_11_23_07.png", width: 80%)],
)

#subsubsection("High-Level Overview")
#align(
  center,
  [#image("../../Screenshots/2023_10_16_11_30_34.png", width: 100%)],
)
- Bear Raid: spreading FUD -> spreading bullshit in order to crash the market
- market cornering: Essentially majority stake in the market -> position to raise
  its own prices

#subsection("DeFi Key Featurs")
+ *Public Verifiability*
  - while the DeFi platform doesn't need to be open-source, the execution and
    bytecode must be publicy verifiable on a blockchain
+ *Custody*
  - you can buy or sell your coins at any time if you hold them yourselves, you are
    not necessarily beholden to a platform.
  - note, if you hold them yourself and you lose them, well shit
+ *Privacy*
  - DeFi can be anonymous or not
  - Blockchains offer pseudonimity -> not real privacy
    - If I know what you buy from some twitter post, I might be able to find the
      according transaction and hence your wallet.
  - centralized exchanges do not offer privacy -> usually data is enforced by
    government
+ *Atomicity*
  - legal agreements can enforce atomicity for CeFi
    - shop is forced to ship product by law when you paid for it
  - multiple transactions can be made into one -> they appear atomic
  - flash loan is a good example -> contract including flash loan is one single
    thing
+ *Execution Order Malleability*
  - transaction order can be manipulated by paying more for the transaction ->
    higher gas price
    - used with frontrunning -> by voting your transaction before a big transaction,
      you can short-term pump and dump the coin to gain money. Usually, you need
      knowledge of a future transaction, but by voting, you can change the transaction
      order, removing this need.
  - CeFi transaction order is set by law
+ *Transaction Costs*
  - essential to prevent spam
  - CeFi are usually without overhead other than tax
  - fees can vary, making some blockchains unusable for selling/buying products
+ *Anonymous Development and Deployment*
+ *Non-Stop Market Hours*
  - as long as the blockchain exists, you can do whatever
  - for centralized exchanges, you are beholden to their hours

#subsection("Regulations")
- regulatory state is still unclear
  - is there liability for code?
- blacklisting possible
  - addresses who engage in malicious behavior can be blacklisted
  - USDT and USDC have such blacklists
    - USDT and USDC is controlled by the USA -> they can block your account and
      destroy your tokens
- miners can choose what to mine on
  - transactions can hence be censored by not mining the block with it
  - USA has a lot of miners under its influence -> USA can potentially block
    transactions by imposing restrictions on these miners

#subsection("Centralized Exchange Rate (CEX)")
- Centralized (CEX): ask/bid, sell/buy, the last trade, e.g., 200 DAI for 1 ETH →
  price (order book)
- Workflow: create order, publish on exchange, wait to get filled. Browse orders,
  start fill order.
- Prince changes if trade happens, ask was same or lower than bid. Ask/bid
  submitted by users – add/remove orders
- *Slippage*: you see a price, submit, and until its executed, price can change.
  - Set limits, order may stay in the orderbook

#subsection("Decentralized Exchange Rate (CEX)")
- Decentralized (DEX): ratio of pairs (automatic market making)
- Workflow: exchange pairs
- *Slippage*: the “same” - sometimes (mis)used as price impact
  - difference from now to actual execution of transaction
- Example amount in pool: DAI 200, ETH 1 → price 200DAI/1ETH

#align(
  center,
  [#image("../../Screenshots/2023_10_16_12_12_48.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_16_12_13_18.png", width: 70%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_16_12_39_50.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_16_12_40_21.png", width: 100%)],
)

#subsubsection("Arbitrage Bots")
- they normalize costs after a transaction to keep prices in line with other
  exchanges
- Dex would not work without it!
- essential part of the ecosystem
- Swapping in multiple pools or CEX, if a bootsees e.g., a trading opportunity,
  - Example: Pool 1: 250 DAI for 1 ETH, pool 2: 200 DAI for 1 ETH
  - Arbitrage bot has 1 ETH (not considering price impact in this example)
  - Buy for 1 ETH 250 DAI in pool 1
  - Sell 250 DAI for 1.25 ETH in pool 2, profit = 0.25 ETH

#subsubsection("Liquidity Providing")
Someone needs to fill the pool of a DeX, this means providing tokens for the
exchange.
- adding liquidity may not change price -> all pools must be increased so that all
  exchange rates stay the same
- LP token is recieved for providing liquidity -> fees are collected
  - can be seen as interest
- with more liquidity providers, you will receive less
- problem: "impermantent loss"
#align(
  center,
  [#image("../../Screenshots/2023_10_16_12_55_50.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_16_12_58_44.png", width: 100%)],
)
