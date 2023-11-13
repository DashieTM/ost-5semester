#import "../../utils.typ": *

#section("DHT Algorithms")
#subsection("Searching in DHT")
In order to search a term in a DHT, you need to hash your term and store it in a
hashmap which will then be used to check for matches:
- DHT.get(h(«Institut für Software»))
- In order to find it: DHT.put(h(«Institut für Software»), value)
- drawbacks
  - only exact searches
  - not all keywords are good -> for, some, one etc are bad

#subsubsection("Combining results")
- OR
  - DHT.get(h("firstterm")), DHT.get(h("secondterm")), combine results
- AND variants
  + DHT.get(h("firstterm")), DHT.get(h("secondterm")) -> intersect results
  + DHT.get(h("firstterm") xor h("secondterm"))
    - In order to find it:
      - DHT.put(h(«Institut») xor h(«Software»), value),
      - DHT.put(h(«Institut») xor h(«für»), value)
      - DHT.put(h(«für») xor h(«Software»), value)
    - Combination needs to be known in advance
  + Bloom Filters
    - bf = DHT.getBF(h(«Institut»)) and DHT.get(h(«Software», bf))
    - Sequential (less network, slower) vs. parallel (more network, faster)

#subsection("Partial Search")
- FastSS -> made by thomas, krass
- Levenshtein distance
  - how far away is word 1 from word 2
#align(
  center,
  [#image("../../Screenshots/2023_11_13_11_17_17.png", width: 100%)],
)
#text(
  teal,
)[The value on the bottom right means that with 2 operations, you can get from
  word 1 to word 2.]
#align(
  center,
  [#image("../../Screenshots/2023_11_13_11_17_57.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_13_11_22_02.png", width: 100%)],
)
- multiple queries -> fest: est, fst, fet, fes
- matches because test also includes est
- d(test, fest) = 1 -> edit distance is 1, since it's on the same deletion
  position
  - deletion position 4 would mean distance 4

#subsubsection("Partial Search in documents")
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_11_13_11_43_32.png", width: 100%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_11_13_11_43_43.png", width: 100%)],
  )
])

#subsubsection("Range Queries")
- multiple things to query for
- can be in sequence or random
  - sequence: Insert 10 items: N = 5 → [0, 1, 2, 3, 4], [5, 6, 7, 8, 9] –
    sequential, 2 peers
  - random: Insert 10 items: N = 5 → [0], [5], [10], [15], [20], [25], [30], [35],
    [40], [45] – random, 10 peers
- Over-DHT optimizes range queries
  - PHT: trie (prefix tree); DST: segment → tree on top of DHT
  - Main idea: hash of tree-node (resp. for range) → DHT
  - PHT: Peer stores n data items, if n reached, splits data (moves data across
    peers)
  - DST: stores data on each level (redundancy) up to a threshold
    - No data splitting
  - like a tree: [#image("../../Screenshots/2023_11_13_11_50_55.png", width: 30%)],
Example:
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_11_13_11_51_58.png", width: 100%)],
  )
  #colbreak()
  #align(
    center,
    [#image("../../Screenshots/2023_11_13_11_52_16.png", width: 100%)],
  )
])

#section("P2P Algorithms")
#subsection("Bloom Filter")
- array of n bits
- uses k independent hash functions -> k is a chosen number
- each input is hashed with every hash function
- operations
  - Insertion
    - The bit A[hi(x)] for 1 < i < k are set to 1
    - aka each output of the hash function is set to 1
  - Query
    - Yes if all of the bits A[hi(x)] are 1, no otherwise
  - Deletion
    - Removing an element from this simple Bloom filter is
#align(
  center,
  [#image("../../Screenshots/2023_11_13_12_16_25.png", width: 50%)],
)
Example:
#align(
  center,
  [#image("../../Screenshots/2023_11_13_12_17_43.png", width: 100%)],
)

#columns(
  2,
  [
    #text(green)[benefits:]
    - space efficient
      - any bloom filter can represent the entire universe -> just with 100000 false
        positives...
    - no space constraints
      - never fails in the sense of not creating a filter
    - simple operations
    - no false negatives
    #colbreak()
    #text(red)[liabilities:]
    - false positives
    - simple bloom filter can't delete
  ],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_13_12_20_34.png", width: 50%)],
)

#subsubsection("Variants")
- Compressed Bloom Filters
  - when filter is intended to be passed as a message
  - false positive rate is optimized for the compressed bloom filter
  - compression/decompression -> more memory
- Generalized Bloom Filters
  - Two type of hash functions gi (reset bits to 0) and hj (set bits to 1)
  - Start with an arbitrary vector (bits can be either 0 or 1)
  - In case of collisions between gi and hj, bit is reset to 0
  - Store more info with low false positive
  - Produces either false positives or false negatives
  - #text(red)[false negative possible because of two types of hashes combined!]
- Counting Bloom Filters
  - Entry in the filter not be a single bit but a counter
  - Delete operation possible (decrementing counter)
  - Variable-Increment Counting Bloom Filter
- Scalable Bloom Filters
  - Adapt dynamically to number of elements, consist of regular Bloom filters
  - “A SBF is made up of a series of one or more (plain) Bloom Filters; when filters
    get full due to the limit on the fill ratio, a new one is added; querying is
    made by testing for the presence in each filter”

#subsection("Merkle Trees")
- binary hash tree containing leaf nodes
- constructed bottom-up
- used to summarize all transactions in a block
- To prove that a specific transaction is included in a block, a node only needs
  to produce hashes, constituting a merkle path connecting the specific
  transaction to the root of the tree.
#align(
  center,
  [#image("../../Screenshots/2023_11_13_12_28_23.png", width: 80%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_13_12_28_36.png", width: 80%)],
)

#subsection("BitTorrent")
#align(
  center,
  [#image("../../Screenshots/2023_11_13_12_30_20.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_13_12_30_35.png", width: 100%)],
)
