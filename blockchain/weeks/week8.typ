#import "../../utils.typ": *

#section("Fully Distributed Systems")
#subsection("Principles")
- location transparency
  - user should not know they are interacting with a distributed system
- access transparency
  - users should access resources in a single uniform way, no matter what server
    they are connecting to
- replication transparency
  - users should not be aware about replicas -> must seem like this is the regular
    data
- concurrent transparency
  - users should not be aware that other users are also accessing this right
    now(unless needed for collaboration)

#subsection("Distributed data")
How can users access the same data from different locations -> aka on different
servers?
- central server -> no distribution
- flooding search -> layer 2 broadcasting, wireless mesh networks, bitcoin
- distributed indexing -> tor, bittorrent, cassandra, dynamo

#subsubsection("Comparison")
#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_04_12.png", width: 100%)],
)

#subsubsection("Central Server")
#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_00_21.png", width: 100%)],
)

#columns(2, [
  #text(green)[Benefits]
  - simple and fast
  - complex and fuzzy queries are possible
  - search complexity is O(1) -> just one server!
  #colbreak()
  #text(red)[Liabilities]
  - no scalability -> problem starting with a certain amount of users
    - n users -> O(N) calls to server
    - O(N) node state in server
  - single point of failure
])
#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_03_09.png", width: 30%)],
)

#subsubsection("Flooding")
- fully distributed
  - opposite approach of central server -> no server
- retrieval of data:
  - no routing information for content
  - necessity to ask as many systems as possible/necessary
    - approach1: high degree search -> quick search trhough large areas
    - approach2: random walk
  - high traffic load on network, scalability issues -> spam
  - *no guarantee to reach all nodes*
#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_06_53.png", width: 100%)],
)

#subsubsection("Distributed Indexing")
#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_07_34.png", width: 100%)],
)
Essentially a middle ground between the 2, you have a certain amount of servers
that handle the data, but it isn't thousands, aka no spam, but also no DDOS...
#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_08_25.png", width: 100%)],
)

- Approach of distributed indexing schemes
  - Data and nodes are mapped into same address space
  - Nodes maintain routing information to other nodes
    - Definitive statement of existence of content
- Problems
  - Maintenance of routing information required
  - Fuzzy queries not primarily supported (e.g., wildcard searches)

#subsubsubsection("Distributed Hash Tables")
- Consistent hashing → nodes responsible for hash value intervals
- More peers = smaller responsible intervals
- Hash Table [link]
  - Modulo hashing
  - Bucket = hash(x) mod n
  - If n changes, remapping / bucket changes
  - N changes if capacity is reached
  - Remapping is expensive in DHT!
    - DHTs reassign responsibility

#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_15_15.png", width: 100%)],
)
+ Mapping of nodes and data into same address space
  - Peers and content are addressed using flat identifiers (IDs)
    - E.g., Address is public key (256bit) or SHA256 of public key. Content ID =
      SHA256(content)
  - Common address space for data and nodes
  - Nodes are responsible for data in certain parts of the address space
  - Association of data to nodes may change since nodes may disappear
+ Storing / Looking up data in the DHT
  - Store data = first, search for responsible node
    - Not necessarily known in advance
  - Search data = first, search for responsible node
#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_15_38.png", width: 100%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_17_29.png", width: 100%)],
)
- direct storage
  - small values
  - H("mydata") = 3107
- indirect storage
  - distributed
  - more steps than direct storage
  - mapped as tuple -> (key,value)

#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_28_31.png", width: 100%)],
)

#subsubsubsection("Kademlia")
- Several approaches to build DHT
  - Distance metric as key difference
  - Chord, Pastry: numerical closeness
  - CAN: multidimensional numerical closeness
- Parallel queries
  - For one query, α (alpha) concurrent lookups are sent
  - More traffic load, but lower response times
- Preference towards old contacts
  - Study has shown that the longer a node has been up, the more likely it is to
    remain up another hour
  - Resistance against DoS attacks by flooding the network with new nodes
- Network maintenance
  - In Chord: active fixing of fingers
  - In Kademlia: active maintenance
- DHT-based overlay network using the XOR distance metric
  - Symmetrical routing paths(A → B == B → A)
    - due to XOR(A,B) == XOR (B,A)
#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_41_42.png", width: 100%)],
)
#text(
  teal,
)[Note, the sha1 was used in 2002 when it was created, please for the love of
  pones, don't use this anymore, use sha-whateverelse -> sha256]
#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_32_43.png", width: 100%)],
)
#text(
  teal,
)[Note, the numbers in the tables are actually the binary numbers on the right,
  just converted to the conventional 10digit number system.]

#subsection("TomP2P")
- TomP2P is a P2P framework/library
  - Unmaintained ☹
  - Implements DHT (structured), broadcasts ([un]structured), direct messages (can
    implement super-peers)
  - NAT handling: UPNP, NATPMP, relays, hole punching (work in progress)
  - Direct / indirect (tracker / mesh) storage
  - Direct / indirect replication (churn prediction and ~rsync)

#subsection("Sybil attacks")
Creation of malicious/fake nodes -> if more fake nodes than real ones, they
control the network.\
Prevention:
- make node creation costly
- Always assume data from other nodes may be missing
  - Bitcoin – chain of block, if block is missing, you notice
- Chain of trust / reputation
#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_35_57.png", width: 50%)],
)
#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_56_04.png", width: 80%)],
)

#subsection("Redundancy")
#subsubsection("Replication")
- one originator and responsible node
- all others are peers
- main nodes goes offline -> TTL then value dropped and no longer available
#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_37_43.png", width: 100%)],
)

#subsubsection("Indirect Replication")
- one originator
- all others peers and responsible nodes -> hierarchical, responsible for parent
  node
  - Periodically checks if enough replicas exist
  - Detects if responsibility changes
- Requires cooperation between responsible peer and originator
- Multiple peers may think they are responsible for different versions →
  eventually solved
#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_39_56.png", width: 100%)],
)

#subsubsection("Replication and Consistency")
- DHTs have weak consistency
  - Peer A put X.1
  - Peer B gets X.1
  - Peer B modifies it puts B.2
- Same time (time in distributed systems):
  - Peer C gets X.1
  - Peer C modifies it puts C.2
- Replication makes it worse
  - Consistency: generic issue in distributed systems,requires typically coordinator
- Multi-Paxos, Raft, ZooKeeper → Leader Election

#align(
  center,
  [#image("../../Screenshots/2023_11_06_02_45_47.png", width: 50%)],
)
