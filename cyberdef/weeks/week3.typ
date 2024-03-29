#import "../../utils.typ": *

#section("Incident Response")
#align(
  center,
  [#image("../../Screenshots/2023_10_03_08_33_35.png", width: 100%)],
)

#subsection("First actions")
#columns(2, [
  #align(
    center,
    [#image("../../Screenshots/2023_10_03_08_46_30.png", width: 100%)],
  )
  #colbreak()
  - best not to act quickly
    - quick actions are likly not enough
    - attacker might see that you are aware of the attack
      - endblow might happen
      - attacker might change attack vector
])

#subsection("Indicator of Compromise IOC")
This is the "object" that has been compromised and needs to be checked. The IOC
is used to check this indicator across all PCs servers etc in an organization.
#align(center, [#image("../../Screenshots/2023_10_03_08_45_14.png", width: 80%)])
- IMPHASH\
  hash based on behavior
- MUTEX\
  a ransomware doesn't want to be ran twice as it might encrypt itself. Hence, the
  use of a "mutex", aka a check to see if this is the first time the malware runs
