#import "../../utils.typ": *

#subsection([Strategy])
*Problem* | You need different algorithms depending on various factors.\
*Solution* | Make the algorithms modular.\
*Example* | A list can use various sorting algorithms.\
// images
#align(center, [#image("../uml/strategy.jpg", width: 100%)])
```java
/* Encapsulated family of Algorithms
 * Interface and its implementations
 */
public interface IBrakeBehavior {
    public void brake();
}

public class BrakeWithABS implements IBrakeBehavior {
    public void brake() {
        System.out.println("Brake with ABS applied");
    }
}

public class Brake implements IBrakeBehavior {
    public void brake() {
        System.out.println("Simple Brake applied");
    }
}

/* Client that can use the algorithms above interchangeably */
public abstract class Car {
    private IBrakeBehavior brakeBehavior;

    public Car(IBrakeBehavior brakeBehavior) {
      this.brakeBehavior = brakeBehavior;
    }

    public void applyBrake() {
        brakeBehavior.brake();
    }

    public void setBrakeBehavior(IBrakeBehavior brakeType) {
        this.brakeBehavior = brakeType;
    }
}

/* Client 1 uses one algorithm (Brake) in the constructor */
public class Sedan extends Car {
    public Sedan() {
        super(new Brake());
    }
}

/* Client 2 uses another algorithm (BrakeWithABS) in the constructor */
public class SUV extends Car {
    public SUV() {
        super(new BrakeWithABS());
    }
}

/* Using the Car example */
public class CarExample {
    public static void main(final String[] arguments) {
        Car sedanCar = new Sedan();
        sedanCar.applyBrake();  // This will invoke class "Brake"

        Car suvCar = new SUV();
        suvCar.applyBrake();    // This will invoke class "BrakeWithABS"

        // set brake behavior dynamically
        suvCar.setBrakeBehavior( new Brake() );
        suvCar.applyBrake();    // This will invoke class "Brake"
    }
}
```

#columns(2, [
  #text(green)[Benefits]
  - flexibility
  #colbreak()
  #text(red)[Liabilities]
  - overhead -> indirection
])

#subsection([Observable])
*Problem* | You need updates from another service, which is independent, without
relying on polling.\
*Solution* | The client pushes updates to something that is available to you.\
*Example* | list of transactions -> update pushed to list.\
*Participants* | Subject -> Observable, Observer -> oversees state of subject
// images
#align(center, [#image("../uml/observer.jpg", width: 100%)])
```java
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

interface Observer {
    void update(String event);
}

class EventSource {
    List<Observer> observers = new ArrayList<>();

    public void notifyObservers(String event) {
        observers.forEach(observer -> observer.update(event));
    }

    public void addObserver(Observer observer) {
        observers.add(observer);
    }

    public void scanSystemIn() {
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            notifyObservers(line);
        }
    }
}

public class ObserverDemo {
    public static void main(String[] args) {
        System.out.println("Enter Text: ");
        EventSource eventSource = new EventSource();

        eventSource.addObserver(event -> System.out.println("Received response: " + event));

        eventSource.scanSystemIn();
    }
}
```

Explanation: One subject can have multiple observers, these observers will
execute an update function for each state change in the subject. (usually via
injection)

#columns(2, [
  #text(green)[Benefits]
  - flexibility
  - reduced communication -> no poll
  #colbreak()
  #text(red)[Liabilities]
  - indirection
  - memory increase
])

#subsection([Decorator])
*Problem* | Specific object should have various behavior at runtime.\
*Solution* | Create wrappers for object that can be used as said object and adds
behavior on top.\
*Example* | protocol V1 -> protocol V1.5, aka protocol 1 plus some stuff\
// images
#align(center, [#image("../uml/decorator.jpg", width: 100%)])
```cs
namespace WikiDesignPatterns;

public interface IBike
{
    string GetDetails();
    double GetPrice();
}

public class AluminiumBike : IBike
{
    public double GetPrice() =>
        100.0;

    public string GetDetails() =>
        "Aluminium Bike";
}

public class CarbonBike : IBike
{
    public double GetPrice() =>
        1000.0;

    public string GetDetails() =>
        "Carbon";
}


public abstract class BikeAccessories : IBike
{
    private readonly IBike _bike;

    public BikeAccessories(IBike bike)
    {
        _bike = bike;
    }

    public virtual double GetPrice() =>
        _bike.GetPrice();


    public virtual string GetDetails() =>
        _bike.GetDetails();
}

public class SecurityPackage : BikeAccessories
{
    public SecurityPackage(IBike bike):base(bike)
    {

    }

    public override string GetDetails() =>
        base.GetDetails() + " + Security Package";

    public override double GetPrice() =>
        base.GetPrice() + 1;
}

public class SportPackage : BikeAccessories
{
    public SportPackage(IBike bike) : base(bike)
    {

    }

    public override string GetDetails() =>
        base.GetDetails() + " + Sport Package";

    public override double GetPrice() =>
        base.GetPrice() + 10;
}

public class BikeShop
{
    public static void UpgradeBike()
    {
        var basicBike = new AluminiumBike();
        BikeAccessories upgraded = new SportPackage(basicBike);
        upgraded = new SecurityPackage(upgraded);

        Console.WriteLine($"Bike: '{upgraded.GetDetails()}' Cost: {upgraded.GetPrice()}");

    }
}
```
Explanation: Decorators are simply wrappers around an object that can be used as
said object. Wrapping can be done indefinitely, therefore providing unlimited
expansion options.

#columns(2, [
  #text(green)[Benefits]
  - flexibility
  - expandability
  #colbreak()
  #text(red)[Liabilities]
  - indirection
  - memory usage -> object in object
])

#subsection([Factory Method])
*Problem* | Creation of objects without needing to pass default parameters and
runtime change of what is instantiated.\
*Solution* | Creation class that handles default initialization etc.\
// images
#align(center, [#image("../uml/factory.jpg", width: 100%)])
```cs
// Empty vocabulary of actual object
public interface IPerson
{
    string GetName();
}

public class Villager : IPerson
{
    public string GetName()
    {
        return "Village Person";
    }
}

public class CityPerson : IPerson
{
    public string GetName()
    {
        return "City Person";
    }
}

public enum PersonType
{
    Rural,
    Urban
}

/// <summary>
/// Implementation of Factory - Used to create objects.
/// </summary>
public class PersonFactory
{
    public IPerson GetPerson(PersonType type)
    {
        switch (type)
        {
            case PersonType.Rural:
                return new Villager();
            case PersonType.Urban:
                return new CityPerson();
            default:
                throw new NotSupportedException();
        }
    }
}
```

#columns(2, [
  #text(green)[Benefits]
  - ease of use
  - factories can be swapped -> polymorphism
  #colbreak()
  #text(red)[Liabilities]
  - enum and types have to be added separately
  - possible over-abstraction
])

#subsubsection([Abstract Factory Method])
*Explanation* | Name is dumb, what it actually does, it creates groups of
objects the factory creates which are not defined, e.g. the implementations have
to define it, hence the need for abstract.\
*Example* | *two* or more *types* of objects need to be created with one
factory.
// images
#align(center, [#image("../uml/abstractfactory.jpg", width: 100%)])
```cs
public interface IProduct
{
    string GetName();
    bool SetPrice(double price);
}

public class Phone : IProduct
{
    private double _price;

    public string GetName()
    {
        return "Apple TouchPad";
    }

    public bool SetPrice(double price)
    {
        _price = price;
        return true;
    }
}

/* Almost same as Factory, just an additional exposure to do something with the created method */
public abstract class ProductAbstractFactory
{
    protected abstract IProduct MakeProduct();

    public IProduct GetObject() // Implementation of Factory Method.
    {
        return this.MakeProduct();
    }
}

public class PhoneConcreteFactory : ProductAbstractFactory
{
    protected override IProduct MakeProduct()
    {
        IProduct product = new Phone();
        // Do something with the object after you get the object.
        product.SetPrice(20.30);
        return product;
    }
}
```

compared to regular factory
#columns(2, [
  #text(green)[Benefits]
  - Grouping of objects without duplication
  #colbreak()
  #text(red)[Liabilities]
])

#subsection([Adapter])
*Problem* | How can i make incompatible interfaces compatible?\
*Solution* | Put a wrapper around the object, which implements the incompatible
endpoint. On these functions, you can then convert whatever you already have to
the endpoint.\

#align(center, [#image("../uml/adapter.jpg", width: 100%)])
```java
interface ILightningPhone {
    void recharge();
    void useLightning();
}

interface IMicroUsbPhone {
    void recharge();
    void useMicroUsb();
}

class Iphone implements ILightningPhone {
    private boolean connector;

    @Override
    public void useLightning() {
        connector = true;
        System.out.println("Lightning connected");
    }

    @Override
    public void recharge() {
        if (connector) {
            System.out.println("Recharge started");
            System.out.println("Recharge finished");
        } else {
            System.out.println("Connect Lightning first");
        }
    }
}

class Android implements IMicroUsbPhone {
    private boolean connector;

    @Override
    public void useMicroUsb() {
        connector = true;
        System.out.println("MicroUsb connected");
    }

    @Override
    public void recharge() {
        if (connector) {
            System.out.println("Recharge started");
            System.out.println("Recharge finished");
        } else {
            System.out.println("Connect MicroUsb first");
        }
    }
}
/* exposing the target interface while wrapping source object */
class LightningToMicroUsbAdapter implements IMicroUsbPhone {
    private final ILightningPhone lightningPhone;

    public LightningToMicroUsbAdapter(ILightningPhone lightningPhone) {
        this.lightningPhone = lightningPhone;
    }

    @Override
    public void useMicroUsb() {
        System.out.println("MicroUsb connected");
        lightningPhone.useLightning();
    }

    @Override
    public void recharge() {
        lightningPhone.recharge();
    }
}

public class AdapterDemo {
    static void rechargeMicroUsbPhone(IMicroUsbPhone phone) {
        phone.useMicroUsb();
        phone.recharge();
    }

    static void rechargeLightningPhone(ILightningPhone phone) {
        phone.useLightning();
        phone.recharge();
    }

    public static void main(String[] args) {
        Android android = new Android();
        Iphone iPhone = new Iphone();

        System.out.println("Recharging android with MicroUsb");
        rechargeMicroUsbPhone(android);

        System.out.println("Recharging iPhone with Lightning");
        rechargeLightningPhone(iPhone);

        System.out.println("Recharging iPhone with MicroUsb");
        rechargeMicroUsbPhone(new LightningToMicroUsbAdapter (iPhone));
    }
}
```
#columns(2, [
  #text(green)[Benefits]
  - flexibility
  #colbreak()
  #text(red)[Liabilities]
  - indirection
])

#subsection([Facade])
*Problem* | How can I hide complex logic from users and provide a simpler
interface?\
*Solution* | Create a facade that will be used by clients instead of the
underlying system.\

#align(center, [#image("../uml/facade.png", width: 100%)])
```cpp
struct CPU {
  void Freeze();
  void Jump(long position);
  void Execute();
};

struct HardDrive {
  char* Read(long lba, int size);
};

struct Memory {
  void Load(long position, char* data);
};

class ComputerFacade {
 public:
  void Start() {
    cpu_.Freeze();
    memory_.Load(kBootAddress, hard_drive_.Read(kBootSector, kSectorSize));
    cpu_.Jump(kBootAddress);
    cpu_.Execute();
  }

 private:
  CPU cpu_;
  Memory memory_;
  HardDrive hard_drive_;
};

int main() {
  ComputerFacade computer;
  computer.Start();
}
```

#columns(2, [
  #text(green)[Benefits]
  - easier to read and use
  - generalization or context specific usage with different facades
  - allows for a non-specific base implementation
  #colbreak()
  #text(red)[Liabilities]
  - indirection
  - can be too much -> black magic
])

#subsection([Proxy])
*Problem* | How can I manage access to a resource indirectly?\
*Context* | Often access should not happen directly for security reasons, or for
potential unavailability -> remote resource.\
*Solution* | Introduce a proxy that will interact with the resource on your
behalf.\

#align(center, [#image("../uml/proxy.jpg", width: 100%)])
```java
// Internet interface
public interface Internet
{
    public void connectTo(String serverhost) throws Exception;
}

// Implementation
public class RealInternet implements Internet
{
    @Override
    public void connectTo(String serverhost)
    {
        System.out.println("Connecting to "+ serverhost);
    }
}

// Proxy
import java.util.ArrayList;
import java.util.List;
public class ProxyInternet implements Internet
{
    private Internet internet = new RealInternet();
    private static List<String> bannedSites;

    static
    {
        bannedSites = new ArrayList<String>();
        bannedSites.add("abc.com");
        bannedSites.add("def.com");
        bannedSites.add("ijk.com");
        bannedSites.add("lnm.com");
    }

    @Override
    public void connectTo(String serverhost) throws Exception
    {
        if(bannedSites.contains(serverhost.toLowerCase()))
        {
            throw new Exception("Access Denied");
        }

        internet.connectTo(serverhost);
    }

}

// usage in client
public class Client
{
    public static void main (String[] args)
    {
        Internet internet = new ProxyInternet();
        try
        {
            internet.connectTo("geeksforgeeks.org");
            internet.connectTo("abc.com");
        }
        catch (Exception e)
        {
            System.out.println(e.getMessage());
        }
    }
}
```

Variations:\
- *Remote Proxy*: Proxy that ensures remote point is either available or proper
  error handling is used instead.
- *Virtual Proxy*: Proxy that ensures efficient access to a resource that is
  costly to interact with.
- *Protection Proxy*: Ensures authentication and authorization for a certain
  resource.

#columns(2, [
  #text(green)[Benefits]
  - ease of use
    - example: no need to know about security or availability
  #colbreak()
  #text(red)[Liabilities]
  - indirection
])

#subsection([Bridge])
*Problem* | How can I make interfaces for objects interchangeable?\
*Solution* | Create an interface for the object and another for the behavior.
Then the object will hold a reference to the implementation, which can be
exchanged at will.\
*Example* | interface animal has a behavior. Monkey -> Monkeybehavior, Peng ->
pengereng\
#align(center, [#image("../uml/bridge.jpg", width: 100%)])
```cs
// Helps in providing truly decoupled architecture
public interface IBridge
{
    void Function1();
    void Function2();
}

public class Bridge1 : IBridge
{
    public void Function1()
    {
        Console.WriteLine("Bridge1.Function1");
    }

    public void Function2()
    {
        Console.WriteLine("Bridge1.Function2");
    }
}

public class Bridge2 : IBridge
{
    public void Function1()
    {
        Console.WriteLine("Bridge2.Function1");
    }

    public void Function2()
    {
        Console.WriteLine("Bridge2.Function2");
    }
}

public interface IAbstractBridge
{
    void CallMethod1();
    void CallMethod2();
}

public class AbstractBridge : IAbstractBridge
{
    public IBridge bridge;

    public AbstractBridge(IBridge bridge)
    {
        this.bridge = bridge;
    }

    public void CallMethod1()
    {
        this.bridge.Function1();
    }

    public void CallMethod2()
    {
        this.bridge.Function2();
    }
}
```

#columns(
  2, [
    #text(green)[Benefits]
    - flexibility -> objects can exchange interfaces at will
      - similar to pointer to implementation -> can also be exchanged
    - Reduces the amount of objects necessary to implement all combinations
      - each animal to each behavior, etc.
    #colbreak()
    #text(red)[Liabilities]
    - indirection
    - unclear what the behavior will do exactly
      - you would need to know the exact implementation
  ],
)

#subsection([Composite])
*Problem* | How can I model the existance of subnodes within classes?\
*Solution* | One interface, 2 implementations, one is the leaf, the other is the
node(composite).\
*Example* | Representation of tree structures\
#align(center, [#image("../uml/composite.jpg", width: 100%)])
#align(center, [#image("../uml/composite2.jpg", width: 100%)])
```cpp
#include <iostream>
#include <string>
#include <list>
#include <memory>
#include <stdexcept>

typedef double Currency;

// declares the interface for objects in the composition.
class Equipment { // Component
public:
  // implements default behavior for the interface common to all classes, as appropriate.
  virtual const std::string& getName() {
    return name;
  }
  virtual void setName(const std::string& name_) {
    name = name_;
  }
  virtual Currency getNetPrice() {
    return netPrice;
  }
  virtual void setNetPrice(Currency netPrice_) {
    netPrice = netPrice_;
  }
  // declares an interface for accessing and managing its child components.
  virtual void add(std::shared_ptr<Equipment>) = 0;
  virtual void remove(std::shared_ptr<Equipment>) = 0;
  virtual ~Equipment() = default;
protected:
  Equipment() :name(""), netPrice(0) {}
  Equipment(const std::string& name_) :name(name_), netPrice(0) {}
private:
  std::string name;
  Currency netPrice;
};

// defines behavior for components having children.
class CompositeEquipment : public Equipment { // Composite
public:
  // implements child-related operations in the Component interface.
  virtual Currency getNetPrice() override {
    Currency total = Equipment::getNetPrice();
    for (const auto& i:equipment) {
      total += i->getNetPrice();
    }
    return total;
  }
  virtual void add(std::shared_ptr<Equipment> equipment_) override {
    equipment.push_front(equipment_.get());
  }
  virtual void remove(std::shared_ptr<Equipment> equipment_) override {
    equipment.remove(equipment_.get());
  }
protected:
  CompositeEquipment() :equipment() {}
  CompositeEquipment(const std::string& name_) :equipment() {
    setName(name_);
  }
private:
  // stores child components.
  std::list<Equipment*> equipment;
};

// represents leaf objects in the composition.
class FloppyDisk : public Equipment { // Leaf
public:
  FloppyDisk(const std::string& name_) {
    setName(name_);
  }
  // A leaf has no children.
  void add(std::shared_ptr<Equipment>) override {
    throw std::runtime_error("FloppyDisk::add");
  }
  void remove(std::shared_ptr<Equipment>) override {
    throw std::runtime_error("FloppyDisk::remove");
  }
};

class Chassis : public CompositeEquipment {
public:
  Chassis(const std::string& name_) {
    setName(name_);
  }
};

int main() {
  // The smart pointers prevent memory leaks.
  std::shared_ptr<FloppyDisk> fd1 = std::make_shared<FloppyDisk>("3.5in Floppy");
  fd1->setNetPrice(19.99);
  std::cout << fd1->getName() << ": netPrice=" << fd1->getNetPrice() << '\n';

  std::shared_ptr<FloppyDisk> fd2 = std::make_shared<FloppyDisk>("5.25in Floppy");
  fd2->setNetPrice(29.99);
  std::cout << fd2->getName() << ": netPrice=" << fd2->getNetPrice() << '\n';

  std::unique_ptr<Chassis> ch = std::make_unique<Chassis>("PC Chassis");
  ch->setNetPrice(39.99);
  ch->add(fd1);
  ch->add(fd2);
  std::cout << ch->getName() << ": netPrice=" << ch->getNetPrice() << '\n';

  fd2->add(fd1);
}
```

Note:\
#text(
  orange,
)[A composite is essentially just a class with one or more of the same class
  within it. -> aka composition]

#columns(2, [
  #text(green)[Benefits]
  - nodes and leafs can be interchanged
  #colbreak()
  #text(red)[Liabilities]
])

#subsection([Template Method])
*Problem* | How can I create a template for a class so that users can easily
implement what is needed?\
*Solution* | Create an interface......\
#align(center, [#image("../uml/template.jpg", width: 100%)])
```cpp
#include <iostream>
#include <memory>

class View { // AbstractClass
public:
  // defines abstract primitive operations that concrete subclasses define to implement steps of an algorithm.
  virtual void doDisplay() {}
  // implements a template method defining the skeleton of an algorithm. The template method calls primitive operations as well as operations defined in AbstractClass or those of other objects.
  void display() {
    setFocus();
    doDisplay();
    resetFocus();
  }
  virtual ~View() = default;
private:
  void setFocus() {
    std::cout << "View::setFocus\n";
  }
  void resetFocus() {
    std::cout << "View::resetFocus\n";
  }
};

class MyView : public View { // ConcreteClass
  // implements the primitive operations to carry out subclass-specific steps of the algorithm.
  void doDisplay() override {
    // render the view's contents
    std::cout << "MyView::doDisplay\n";
  }
};

int main() {
  std::unique_ptr<View> myview = std::make_unique<MyView>();
  myview->display();
}
```

Note:\
#text(
  orange,
)[Note, this can also be done with traits in rust, or interfaces for languages
  that allow default implementations. For something like jafuck, this is not
  applicable as it doesn't allow default implementations. Hence, for java you
  *need* to use subclassing to achieve template method pattern.]

#columns(2, [
  #text(green)[Benefits]
  - templated classes
  - users know what needs to be implemented
  #colbreak()
  #text(red)[Liabilities]
  - template has required functions
])

#subsection([Builder])
*Problem* | How can a class (the same construction process) create different
representations of a complex object?\
*Solution* | Encapsulate creating and assembling the parts of a complex object
in a separate Builder object.\
*Intent* |The intent of the Builder design pattern is to separate the
construction of a complex object from its representation. By doing so, the same
construction process can create different representations.\
#align(center, [#image("../uml/builder.jpg", width: 100%)])
```cs
/// <summary>
/// Represents a product created by the builder.
/// </summary>
public class Bicycle
{
    public Bicycle(string make, string model, string colour, int height)
    {
        Make = make;
        Model = model;
        Colour = colour;
        Height = height;
    }

    public string Make { get; set; }
    public string Model { get; set; }
    public int Height { get; set; }
    public string Colour { get; set; }
}

/// <summary>
/// The builder abstraction.
/// </summary>
public interface IBicycleBuilder
{
    Bicycle GetResult();

    string Colour { get; set; }
    int Height { get; set; }
}

/// <summary>
/// Concrete builder implementation.
/// </summary>
public class GTBuilder : IBicycleBuilder
{
    public Bicycle GetResult()
    {
        return Height == 29 ? new Bicycle("GT", "Avalanche", Colour, Height) : null;
    }

    public string Colour { get; set; }
    public int Height { get; set; }
}

/// <summary>
/// The director.
/// </summary>
public class MountainBikeBuildDirector
{
    private IBicycleBuilder _builder;

    public MountainBikeBuildDirector(IBicycleBuilder builder)
    {
        _builder = builder;
    }

    public void Construct()
    {
        _builder.Colour = "Red";
        _builder.Height = 29;
    }

    public Bicycle GetResult()
  {
    return this._builder.GetResult();
  }
}

public class Client
{
    public void DoSomethingWithBicycles()
    {
        var director = new MountainBikeBuildDirector(new GTBuilder());
        // Director controls the stepwise creation of product and returns the result.
        director.Construct();
        Bicycle myMountainBike = director.GetResult();
    }
}
```

#columns(2, [
  #text(green)[Benefits]
  - Allows you to vary a product's internal representation.
  - Encapsulates code for construction and representation.
  - Provides control over the steps of the construction process.
  #colbreak()
  #text(red)[Liabilities]
  - A distinct ConcreteBuilder must be created for each type of product.
  - Builder classes must be mutable.
  - May hamper/complicate dependency injection.
])

#subsection([Prototype])
*Problem* | How can I have rust functionality without using rust? (clone
function)\
*Solution* | Implement a "prototype" interface with the clone method in it. Then
implement the clone method for all classes that should be cloneable.\
#align(center, [#image("../uml/prototype.jpg", width: 100%)])
```cpp
#include <iostream>

enum Direction {North, South, East, West};

class MapSite {
public:
  virtual void enter() = 0;
  virtual MapSite* clone() const = 0;
  virtual ~MapSite() = default;
};

class Room : public MapSite {
public:
  Room() :roomNumber(0) {}
  Room(int n) :roomNumber(n) {}
  void setSide(Direction d, MapSite* ms) {
    std::cout << "Room::setSide " << d << ' ' << ms << '\n';
  }
  virtual void enter() {}
  virtual Room* clone() const { // implements an operation for cloning itself.
    return new Room(*this);
  }
  Room& operator=(const Room&) = delete;
private:
  int roomNumber;
};

class Wall : public MapSite {
public:
  Wall() {}
  virtual void enter() {}
  virtual Wall* clone() const {
    // copy constructor on clone
    return new Wall(*this);
  }
};

class Door : public MapSite {
public:
  Door(Room* r1 = nullptr, Room* r2 = nullptr)
    :room1(r1), room2(r2) {}
  Door(const Door& other)
    :room1(other.room1), room2(other.room2) {}
  virtual void enter() {}
  virtual Door* clone() const {
    return new Door(*this);
  }
  virtual void initialize(Room* r1, Room* r2) {
    room1 = r1;
    room2 = r2;
  }
  Door& operator=(const Door&) = delete;
private:
  Room* room1;
  Room* room2;
};

class Maze {
public:
  void addRoom(Room* r) {
    std::cout << "Maze::addRoom " << r << '\n';
  }
  Room* roomNo(int) const {
    return nullptr;
  }
  virtual Maze* clone() const {
    return new Maze(*this);
  }
  virtual ~Maze() = default;
};

class MazeFactory {
public:
  MazeFactory() = default;
  virtual ~MazeFactory() = default;

  virtual Maze* makeMaze() const {
    return new Maze;
  }
  virtual Wall* makeWall() const {
    return new Wall;
  }
  virtual Room* makeRoom(int n) const {
    return new Room(n);
  }
  virtual Door* makeDoor(Room* r1, Room* r2) const {
    return new Door(r1, r2);
  }
};

class MazePrototypeFactory : public MazeFactory {
public:
  MazePrototypeFactory(Maze* m, Wall* w, Room* r, Door* d)
    :prototypeMaze(m), prototypeRoom(r),
     prototypeWall(w), prototypeDoor(d) {}
  virtual Maze* makeMaze() const {
    // creates a new object by asking a prototype to clone itself.
    return prototypeMaze->clone();
  }
  virtual Room* makeRoom(int) const {
    return prototypeRoom->clone();
  }
  virtual Wall* makeWall() const {
    return prototypeWall->clone();
  }
  virtual Door* makeDoor(Room* r1, Room* r2) const {
    Door* door = prototypeDoor->clone();
    door->initialize(r1, r2);
    return door;
  }
  MazePrototypeFactory(const MazePrototypeFactory&) = delete;
  MazePrototypeFactory& operator=(const MazePrototypeFactory&) = delete;
private:
  Maze* prototypeMaze;
  Room* prototypeRoom;
  Wall* prototypeWall;
  Door* prototypeDoor;
};

// If createMaze is parameterized by various prototypical room, door, and wall objects, which it then copies and adds to the maze, then you can change the maze's composition by replacing these prototypical objects with different ones. This is an example of the Prototype (133) pattern.

class MazeGame {
public:
  Maze* createMaze(MazePrototypeFactory& m) {
    Maze* aMaze = m.makeMaze();
    Room* r1 = m.makeRoom(1);
    Room* r2 = m.makeRoom(2);
    Door* theDoor = m.makeDoor(r1, r2);
    aMaze->addRoom(r1);
    aMaze->addRoom(r2);
    r1->setSide(North, m.makeWall());
    r1->setSide(East, theDoor);
    r1->setSide(South, m.makeWall());
    r1->setSide(West, m.makeWall());
    r2->setSide(North, m.makeWall());
    r2->setSide(East, m.makeWall());
    r2->setSide(South, m.makeWall());
    r2->setSide(West, theDoor);
    return aMaze;
  }
};

int main() {
  MazeGame game;
  MazePrototypeFactory simpleMazeFactory(new Maze, new Wall, new Room, new Door);
  game.createMaze(simpleMazeFactory);
}
```
Note:\
#text(
  orange,
)[cloning can lead to performance hits, so use it only when needed.]

#columns(2, [
  #text(green)[Benefits]
  - both shallow and deep copy possible
  - can be implemented for every class
  #colbreak()
  #text(red)[Liabilities]
  - needs an implementation for something simple
    - rust doesn't, hehe, derive kekw
])
