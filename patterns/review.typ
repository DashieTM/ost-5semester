#import "../utils.typ": *

#set columns(gutter: 5pt)
#set page(
  "a4", header: none, footer: none, margin: 10pt, flipped: true, columns: 4,
)
#set text(size: 8pt)

#section([Strategy])
*Problem* | You need different algorithms depending on various factors.\
*Solution* | Make the algorithms modular.\
*Example* | A list can use various sorting algorithms.\
// images
#set text(size: 5pt)
#align(center, [#image("uml/strategy.jpg", width: 100%)])
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

#set text(size: 8pt)
#columns(2, [
  #text(green)[Benefits]
  - flexibility
  #colbreak()
  #text(red)[Liabilities]
  - overhead -> indirection
])

#section([Observable])
*Problem* | You need updates from another service, which is independent, without
relying on polling.\
*Solution* | The client pushes updates to something that is available to you.\
*Example* | list of transactions -> update pushed to list.\
*Participants* | Subject -> Observable, Observer -> oversees state of subject
// images
#set text(size: 5pt)
#align(center, [#image("uml/observer.jpg", width: 100%)])
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
#set text(size: 8pt)

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

#section([Decorator])
*Problem* | Specific object should have various behavior at runtime.\
*Solution* | Create wrappers for object that can be used as said object and adds
behavior on top.\
*Example* | protocol V1 -> protocol V1.5, aka protocol 1 plus some stuff\
// images
#set text(size: 5pt)
#align(center, [#image("uml/decorator.jpg", width: 100%)])
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
#set text(size: 8pt)
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

#section([Factory Method])
*Problem* | Creation of objects without needing to pass default parameters and
runtime change of what is instantiated.\
*Solution* | Creation class that handles default initialization etc.\
// images
#set text(size: 5pt)
#align(center, [#image("uml/factory.jpg", width: 100%)])
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
#set text(size: 8pt)

#columns(2, [
  #text(green)[Benefits]
  - ease of use
  - factories can be swapped -> polymorphism
  #colbreak()
  #text(red)[Liabilities]
  - enum and types have to be added separately
  - possible over-abstraction
])

#subsection([Abstract Factory Method])
*Explanation* | Name is dumb, what it actually does, it creates groups of
objects the factory creates which are not defined, e.g. the implementations have
to define it, hence the need for abstract.\
*Example* | *two* or more *types* of objects need to be created with one
factory.
// images
#set text(size: 5pt)
#align(center, [#image("uml/abstractfactory.jpg", width: 100%)])
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
#set text(size: 8pt)

compared to regular factory
#columns(2, [
  #text(green)[Benefits]
  - Grouping of objects without duplication
  #colbreak()
  #text(red)[Liabilities]
])

#section([Singleton])
*Problem* | Require global, single instance -> Database\
*Solution* | create class with static access to connection to database.\
#set text(size: 5pt)
```lang
public class Singleton {
  private static class InstanceHolder {
    // lazy instantiation, happens once
    private static final Singleton INSTANCE = new Singleton();
  }
  public static Singleton getInstance() {
    return InstanceHolder.INSTANCE;
  }
  protected Singleton() { } // allow subclassing
}
```
#set text(size: 8pt)

#columns(2, [
  #text(green)[Benefits]
  - one global instance
  - no namespace pollution
  - lazy or eager loading possible
  #colbreak()
  #text(red)[Liabilities]
  - no polymorphism
    - unit testing? how? you dont :)
  - global state
    - instance will always be alive until program ends
  - unlimited instances -> all use the same state
  - multithreading issues -> read/lock
])

#subsection([Singleton Registry])
*Explanation* | Same as singleton, but with a registry that stores names. This
allows you to use a test singleton for unit testing -> mock.\

#align(center, [#image("uml/registry.png", width: 100%)])
#align(center, [#image("uml/registry2.png", width: 100%)])

#columns(2, [
  #text(green)[Benefits]
  - testing possible
  #colbreak()
  #text(red)[Liabilities]
  - IPC style fetching
    - no error in editor, but in runtime
  - issues with global state still apply
])

#subsection([Monostate(Killing)])
*Problem* | Given code that uses a singleton, you need to remove the singleton
for your tests...\
*Solution* | Wrap the singleton access into monostate, which can either return
the singleton, or a stub.\
#set text(size: 5pt)
```lang
// this is a regular monostate
public class Monostate {
  private static int x;
  private static int y;
  public int getX() { return x; }
  public int getY() { return y; }
}
// this can instead be used to access the singleton OR a stub:
public interface Monostate {
  int getX();
  int getY();
}
public class MonostateImpl implements Monostate {
  public int getX() {
    return Singleton.getInstance().getX();
  }
  public int getY() {
    return Singleton.getInstance().getY();
  }
}
public class MonostateMockImpl implements Monostate {
  private static MockSingleton = new MockSingleton();
  public int getX() {
    return MockSingleton.getX();
  }
  public int getY() {
    return MockSingleton.getY();
  }
}
// both can now be used
```
#set text(size: 8pt)

compared to regular singleton
#columns(2, [
  #text(green)[Benefits]
  - testing, polymorphism
  #colbreak()
  #text(red)[Liabilities]
])

regular monostate
#columns(2, [
  #text(green)[Benefits]
  - transparency -> no need to know about monostate
  - well defined creation and destruction for static members
  #colbreak()
  #text(red)[Liabilities]
  - monostate objects are real -> use memory
  - monostate can lead to unexpected behavior -> static data
  - monostate data is always allocated
  - monostate may not use internal state -> non static state
])

#section([Service Locator])
*Problem* | Need a way to get services for something -> how to get the service\
*Solution* | Global service locator\
*Example* | Authentication -> authentication service\
#set text(size: 5pt)
#align(center, [#image("uml/locator.png", width: 100%)])
#set text(size: 8pt)

#columns(2, [
  #text(green)[Benefits]
  - exactly one singleton in the system -> service locator
  - everything else is abstract
  #colbreak()
  #text(red)[Liabilities]
  - clients still rely on a singleton
    - not possible to exchange service locator
])

#section([Command])
*Problem* | decouple the execution itself from when to execute.\
#set text(size: 11pt)
*Solution* | How can *commands be encapsulated*, so that they can be
*parameterized, schedules, logged and/or undone*? Can also be seen as mapping a
function to something like a button on a controller -> SpiritOfMars!
#set text(size: 5pt)
#align(
  center,
  [#image("../Screenshots/2023_10_06_08_45_09.png", width: 80%)],
)

```lang
```
#set text(size: 8pt)

#columns(2, [
  #text(green)[Benefits]
  -
  #colbreak()
  #text(red)[Liabilities]
  -
])

#section([])
*Problem* |\
*Solution* |\
*Example* |\
#set text(size: 5pt)
```lang
```
#set text(size: 8pt)

#columns(2, [
  #text(green)[Benefits]
  -
  #colbreak()
  #text(red)[Liabilities]
  -
])

