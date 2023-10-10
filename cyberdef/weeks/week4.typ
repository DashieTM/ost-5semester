#import "../../utils.typ": *

#section("Shell Exploit")
#subsection("Bind Shell")
#align(
  center,
  [#image("../../Screenshots/2023_10_10_09_13_33.png", width: 80%)],
)
#subsection("Reverse Shell")
#align(
  center,
  [#image("../../Screenshots/2023_10_10_09_14_19.png", width: 80%)],
)
#subsection("Reuse Web Shell")
#align(
  center,
  [#image("../../Screenshots/2023_10_10_09_14_38.png", width: 80%)],
)

#section("MetaSploit")
This is a framework to test exploits.
- payloads
  - bash shell
  - *Meterpreter*\
    Meterpreter is an advanced, dynamically extensible payload that uses in-memory
    DLL injection stagers and is extended over the network at runtime. It
    communicates over the stager socket and provides a comprehensive client-side
    Ruby API. It features command history, tab completion, channels, and more.
    - 3 stage payload
      - works on winshit and penguinOS
      - can execute commands
      - take screenshots
      - load code
    - can handle multiple connections
    - all forms of shell exploits
#align(
  center,
  [#image("../../Screenshots/2023_10_10_09_19_26.png", width: 70%)],
)
