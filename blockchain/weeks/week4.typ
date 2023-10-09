#import "../../utils.typ": *

#section("Solidity Basics")
- always signify license -> \/\/ SPDX-License-Identifier: MIT
- classes are made as *contracts* -> state storage  //typstfmt::off
  ```sol
  contract SimpleStorage {
    uint256 storedData;
    // state variable
  }
  ```
  //typstfmt::on
- Functions are as normal  //typstfmt::off
  ```sol
  function bid() public {
    // ...
  }
  ```
  //typstfmt::on
- visibility
  - internal: like private but can be overriden by other functions
  - private: as usual
  - external: *only* callable from outside
  - public: as usual
- *Types*
  - pure\
    no state reading or writing -> functional kekw
  - view\
    no state view, but write
  - payable\
    can send or receive ETH
- returns\
  written as returns (type)

#subsection("Examples")
//typstfmt::off
```sol
contract Something {
  uint256 storedData = 1;
  function test() public returns (uint256) {
    storedData = 2;
    return 2;
  }
}
```
//typstfmt::on

#subsection("Modifiers")
Modifiers are essentially traits:
//typstfmt::off
```sol
modifier onlyOwner() {
  require(
    msg.sender == owner, "Only
owner allowed");
  _;
}
```
//typstfmt::on
Then you can use functions like this:
//typstfmt::off
```sol
function abort() public view
onlyOwner{
  // ...
}
```
//typstfmt::on

#subsubsection("Simle modifiers")
Modifiers are also what allows function overriding:
//typstfmt::off
```sol
contract Something {
  function first() public view virtual returns (bool) {}
}
contract Whatever is Something {
  function first() public view override returns (bool) {}
}
```
//typstfmt::on

#subsection("Events")
Events allow you to communicate to the outside.
//typstfmt::off
```sol
contract EventContract {
event TestEvent(string msg);
  function useevent() public {
    emit TestEvent("whatever");
  }
}
```
//typstfmt::on

#subsection("Errors")
Simple errors can be used like this:
//typstfmt::off
```sol
contract ErrorContract {
error TestError(string msg);
  function useevent() public pure {
    revert TestError("whatever");
  }
}
```
//typstfmt::on

You can also automatically use *require* in order to fail when something is not given:
//typstfmt::off
```sol
require(balance >= amount, "Not enough");
// fails when balance is not high enough
```
//typstfmt::on
You can also use *assert* to check for bugs in your contract or use *try/catch* with errors.

#subsection("Structs and Enums")
#text(red)[Can only be used within contracts!]
//typstfmt::off
```sol
contract TypeContract {
  struct Type {
    uint256 num;
    string name;
  }
  enum Enum {
    FIRST,
    SECOND,
    THIRD
  }
  Type something = Type(5,"globi");
  Enum someenum = Enum.FIRST;
}
```
//typstfmt::on

#subsection("Storage locations")
We can store parameters on 3 different ways, memory, which means as long as the contract lives, callData, which means gone when the function ends, or storage for persistent blockchain storage(expensive!)
//typstfmt::off
```sol
// memory -> heap
// calldata -> stack
// storage -> blockchain
function register(string memory name) internal {}
```
//typstfmt::on


#subsection("Address Type")
Obviously, this is a language for a blockchain, therefore it also offers an address type:
//typstfmt::off
```sol
contract AdressContract {
  address myledger = address(this);
  address payable wat = address(0x123);

  function whatever() public payable {
    if (wat.balance < 10 && myledger.balance >= 10) wat.transfer(10);
    // send does the same but without revert on gas failure!
  }

  function lel() public payable {
    bytes memory payload = abi.encodeWithSignature("register(string)", "MyName");
    (bool success, bytes memory returnData) = address(this).call(payload);
    // call function on address remotely
    require(success);
  }

  function register(string memory name) internal {}
  // function to call with payload
}


myLedger.call();
myLedger.delegatecall();
myLedger.staticcall();
```
//typstfmt::on

#subsection("Arrays and Maps")
//typstfmt::off
```sol
contract MapContract {
  mapping(address => uint) public balances;
  uint[] arr = new uint[](3);
  function update(uint newBalance) public {
    balances[msg.sender] = newBalance;
    arr[1] = newBalance;
  }
}
```
//typstfmt::on


#subsection("Integrated Variables")
- wei, gwei or ether
- seconds, minutes, hours, days and weeks
- blockhash, blocknumber
- block.prevrandao (new)
- block.timestamp
- msg.data
- *msg.sender*
- *msg.value*

#subsection("Creating Contracts (instantiation)")
//typstfmt::off
```sol
contract NewContract {}
contract InsideContract {
  function wat() public {
    NewContract gg = new NewContract();
    // inside
  }
}
InsideContract gg = web3.eth.InsideContract(); 
// this is a library, not builtin
```
//typstfmt::on

#subsection("Spawn Contract in contract (expensive!)")
//typstfmt::off
```sol
contract ChildContract {
    string public data;
    constructor(string memory _data) {
        data = _data;
    }
}
contract FactoryContract {
    // address of the last deployed ChildContract
    address public lastDeployedAddress;
    function deployChild(string memory _data) public {
        // Deploy a new instance of ChildContract
        ChildContract child = new ChildContract(_data);
        // Store the address of the deployed contract
        lastDeployedAddress = address(child);
    }
}
```
//typstfmt::on

#subsection("Unchecked")
This can save gas, only use if underflow or overflow is absolutely impossible!
//typstfmt::off
```sol
unchecked{}
// make variables under/overflow
```
//typstfmt::on



