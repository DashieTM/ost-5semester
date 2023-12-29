#import "../../utils.typ": *

#subsection("Command Pattern")
#set text(size: 14pt)

Problem | decouple the execution itself from when to execute.\
Context | How can *commands be encapsulated*, so that they can be
*parameterized, schedules, logged and/or undone*? Can also be seen as mapping a
function to something like a button on a controller -> SpiritOfMars!
#align(
  center, [#image("../../Screenshots/2023_10_06_08_45_09.png", width: 80%)],
)
#set text(size: 11pt)
```cpp
#include <iostream>
#include <memory>

class Command {
public:
  // declares an interface for executing an operation.
  virtual void execute() = 0;
  virtual ~Command() = default;
protected:
  Command() = default;
};

template <typename Receiver>
class SimpleCommand : public Command { // ConcreteCommand
public:
  typedef void (Receiver::* Action)();
  // defines a binding between a Receiver object and an action.
  SimpleCommand(std::shared_ptr<Receiver> receiver_, Action action_) :
    receiver(receiver_.get()), action(action_) { }
  SimpleCommand(const SimpleCommand&) = delete; // rule of three
  const SimpleCommand& operator=(const SimpleCommand&) = delete;
  // implements execute by invoking the corresponding operation(s) on Receiver.
  virtual void execute() {
    (receiver->*action)();
  }
private:
  Receiver* receiver;
  Action action;
};

class MyClass { // Receiver
public:
  // knows how to perform the operations associated with carrying out a request. Any class may serve as a Receiver.
  void action() {
    std::cout << "MyClass::action\n";
  }
};

int main() {
  // The smart pointers prevent memory leaks.
  std::shared_ptr<MyClass> receiver = std::make_shared<MyClass>();
  // ...
  std::unique_ptr<Command> command = std::make_unique<SimpleCommand<MyClass> >(receiver, &MyClass::action);
  // ...
  command->execute();
}
```

#columns(
  2, [
    #text(green)[Benefits]
    - command can be activated from different sources
    - new commands can be introduced relatively quickly
    - command objects can be saved in history -> for example for undo
    - time and functionality are decoupled -> not done by the same thing
    #colbreak()
    #text(red)[Liabilities]
    - large design with many commands -> might need many small command classes
      - was also noticeable with SpiritOfMars
    - undo is not defined -> no explanation how, would need an additional pattern
  ],
)

#subsection("Command Processor Pattern")
#set text(size: 14pt)

Problem | Allow easy undo with the command pattern.\
Context | Kind of a combination between the command pattern and the memento
pattern.\
Participants :
- Command Processor
  - seperate object that handles executing and managing history
- command
  - functionality to execute
- controller/client
  - translates requests into command s and transfers commands to the command
    processor
#set text(size: 11pt)
#align(
  center, [#image("../../Screenshots/2023_10_06_08_52_25.png", width: 80%)],
)
#align(
  center, [#image("../../Screenshots/2023_10_06_08_54_50.png", width: 80%)],
)
```java
// CommandProcessor
import org.jetbrains.annotations.NotNull;
import java.util.Stack;
public class CommandProcessor {
  private final Stack<Command> commandStack = new Stack<>();

  public void doIt(@NotNull Command c) {
    commandStack.push(c);
    c.doCommand();
  }

  public void undoIt() {
    commandStack.pop().undoCommand();
  }
}

// Command
public interface Command {
  void doCommand();
  void undoCommand();
}

// Capitalize Command
public class CapitalizeCommand implements Command {
  @Override
  public void doCommand() {
    // getSelection()
    // capitalize()
  }

  @Override
  public void undoCommand() {
    // restoreText()
  }

}
```

#columns(
  2, [
    #text(green)[Benefits]
    - flexibility
    - command processor allows more than just execution -> logging, undo etc
    - enhances testability
    #colbreak()
    #text(red)[Liabilities]
    - efficiency loss due to indirection
  ],
)

#subsection("Visitor Pattern")
#set text(size: 14pt)

Problem |
- change functionality on classes without changing their code
- e.g. different algorithms needed to process an object tree
Context | Essentially just dynamic dispatch. Serialization -> The visitor struct
will be run over all nodes, using it's own visitor versions in order to
serialize to different formats.\
Double Dispatch | This is nothing more than the accepting of a visitor, which is
generic for the node, then using the visit method to use the visitor functin on
the node, which converts the visitor back to the original (sub)instance.\
Participants :
- Visitor
  - generic base
  - derivations will have specific functionality
- node
  - struct that will be changed by visitor
#set text(size: 11pt)
#align(
  center, [#image("../../Screenshots/2023_10_06_09_08_33.png", width: 80%)],
)
#align(
  center, [#image("../../Screenshots/2023_10_06_09_13_27.png", width: 80%)],
)

```java
// Leaf
import org.jetbrains.annotations.NotNull;
import ch.ost.pf.visitor.Visitor;
public class Leaf extends Component {
  @Override
  public void accept(@NotNull Visitor visitor) {
    visitor.visitLeafStart(this);
    visitor.visitLeafEnd(this);
  }
}

// Component
import org.jetbrains.annotations.NotNull;
import ch.ost.pf.visitor.Visitor;
public abstract class Component {
  @NotNull
  public String getName() {
    return getClass().getSimpleName();
  }

  public abstract void accept(@NotNull Visitor visitor);
}

// Composite
import java.util.ArrayList;
import java.util.List;
import org.jetbrains.annotations.NotNull;
import ch.ost.pf.visitor.Visitor;
public class Composite extends Component {
  private final ArrayList<Component> components = new ArrayList<>();

  @NotNull
  public List<Component> getChildren(){
    return components;
  }

  @Override
  public void accept(@NotNull Visitor visitor) {
    visitor.visitCompositeStart(this);
    getChildren().forEach((c) -> c.accept(visitor));
    visitor.visitCompositeEnd(this);
  }
}

// Visitor
import ch.ost.pf.visitor.tree.Composite;
import ch.ost.pf.visitor.tree.Leaf;
import org.jetbrains.annotations.NotNull;

public interface Visitor {
  void visitLeafStart(@NotNull Leaf leaf);
  void visitLeafEnd(@NotNull Leaf leaf);

  void visitCompositeStart(@NotNull Composite comp);
  void visitCompositeEnd(@NotNull Composite comp);
}
```

#columns(
  2, [
    #text(green)[Benefits]
    - adding new operations relatively easy
    - seperates operations from unrelated ones
    #colbreak()
    #text(red)[Liabilities]
    - changes in structure make the visitor pattern unviable
    - visitor can't change how structure is visited -> this is handled by the
      structure!
    - adding new nodes is hard
    - visiting sequence defined in nodes, not in visitor
    - visitor breaks logic apart
  ],
)

XML visitor example:
```java
import ch.ost.pf.visitor.tree.Component;
import ch.ost.pf.visitor.tree.Composite;
import ch.ost.pf.visitor.tree.Leaf;
import org.jetbrains.annotations.NotNull;

public class XmlVisitor implements Visitor {
  private final StringBuffer buffer = new StringBuffer();

  @Override
  public void visitLeafStart(@NotNull Leaf leaf) {
    visitComponentStart(leaf);
  }

  @Override
  public void visitLeafEnd(@NotNull Leaf leaf) {
    visitComponentEnd(leaf);
  }

  @Override
  public void visitCompositeStart(@NotNull Composite comp) {
    if (comp.getChildren().size() != 0) {
      buffer.append("<");
      buffer.append(comp.getName());
      buffer.append(">\n");
    }
    else {
      visitComponentStart(comp);
    }
  }

  @Override
  public void visitCompositeEnd(@NotNull Composite comp) {
    if (comp.getChildren().size() != 0) {
      buffer.append("</");
      buffer.append(comp.getName());
      buffer.append(">\n");
    }
    else {
      visitComponentEnd(comp);
    }
  }

  @Override
  public String toString() {
    return buffer.toString();
  }

  private void visitComponentStart(Component comp) {
    buffer.append("<");
    buffer.append(comp.getName());
  }

  private void visitComponentEnd(Component comp) {
    buffer.append(" />\n");
  }
}
```

#subsection([External Iterator Pattern])

#set text(size: 14pt)

Problem | Iteration depends on the target implementation -> should be separate
to allow multiple iteration strategies. (aka iterator should be a separate
struct)\
Context | Bounded buffer represented with pointers -> separate iterator struct
in order to not change structure directly.\
Participants :
- Base struct
- Iterator
#set text(size: 11pt)
// images
#align(
  center, [#image("../../Screenshots/2023_10_06_09_31_54.png", width: 80%)],
)
#align(center, [#image("../uml/iterator.jpg", width: 100%)])
```java
// A Java program to demonstrate implementation
// of iterator pattern with the example of
// notifications

// A simple Notification class
class Notification
{
    // To store notification message
    String notification;

    public Notification(String notification)
    {
        this.notification = notification;
    }
    public String getNotification()
    {
        return notification;
    }
}

// Collection interface
interface Collection
{
    public Iterator createIterator();
}

// Collection of notifications
class NotificationCollection implements Collection
{
    static final int MAX_ITEMS = 6;
    int numberOfItems = 0;
    Notification[] notificationList;

    public NotificationCollection()
    {
        notificationList = new Notification[MAX_ITEMS];

        // Let us add some dummy notifications
        addItem("Notification 1");
        addItem("Notification 2");
        addItem("Notification 3");
    }

    public void addItem(String str)
    {
        Notification notification = new Notification(str);
        if (numberOfItems >= MAX_ITEMS)
            System.err.println("Full");
        else
        {
            notificationList[numberOfItems] = notification;
            numberOfItems = numberOfItems + 1;
        }
    }

    public Iterator createIterator()
    {
        return new NotificationIterator(notificationList);
    }
}

// We could also use Java.Util.Iterator
interface Iterator
{
    // indicates whether there are more elements to
    // iterate over
    boolean hasNext();

    // returns the next element
    Object next();
}

// Notification iterator
class NotificationIterator implements Iterator
{
    Notification[] notificationList;

    // maintains curr pos of iterator over the array
    int pos = 0;

    // Constructor takes the array of notificationList are
    // going to iterate over.
    public  NotificationIterator (Notification[] notificationList)
    {
        this.notificationList = notificationList;
    }

    public Object next()
    {
        // return next element in the array and increment pos
        Notification notification =  notificationList[pos];
        pos += 1;
        return notification;
    }

    public boolean hasNext()
    {
        if (pos >= notificationList.length ||
            notificationList[pos] == null)
            return false;
        else
            return true;
    }
}

// Contains collection of notifications as an object of
// NotificationCollection
class NotificationBar
{
    NotificationCollection notifications;

    public NotificationBar(NotificationCollection notifications)
    {
        this.notifications = notifications;
    }

    public void printNotifications()
    {
        Iterator iterator = notifications.createIterator();
        System.out.println("-------NOTIFICATION BAR------------");
        while (iterator.hasNext())
        {
            Notification n = (Notification)iterator.next();
            System.out.println(n.getNotification());
        }
    }
}

// Driver class
class Main
{
    public static void main(String args[])
    {
        NotificationCollection nc = new NotificationCollection();
        NotificationBar nb = new NotificationBar(nc);
        nb.printNotifications();
    }
}
```

#columns(2, [
  #text(green)[Benefits]
  - single interface to loop through any collection
  #colbreak()
  #text(red)[Liabilities]
  - multiple iterators at the same time possible
    - not a problem with rust :)
  - life-cycle management of iterator objects
    - not a problem with rust :)
  - close coupling between iterator and corresponding collection
  - indexing might be more intuitive for programmers
])

#subsection([Internal/Enumeration Iterator Pattern])

#set text(size: 14pt)

Problem | Don't rely on external iterator which might introduce too much
coupling.\
Context | You would like to have a print functinality for your datastructure,
hence you create an enumeration function. This will then be used in a "executeOn"
function which takes a function as a parameter, which will then be used on each
item in the datastructure.
-
#set text(size: 11pt)
// images
#align(
  center, [#image("../../Screenshots/2023_10_06_09_37_26.png", width: 80%)],
)

#columns(
  2, [
    #text(green)[Benefits]
    - client is not responsible for loop
    - synchronization can be provided at the level of the whole traversal rather than
      for each element access
      - better safety
    #colbreak()
    #text(red)[Liabilities]
    - single element changes are annoying
      - less control
    - sometimes too abstract
    - depends on command type(not always??)
  ],
)

#subsection([Batch method Iterator])
#set text(size: 14pt)

Problem | Collection is on client -> iterator would not be efficient over
network.\
Context | We would like to access a datastructure on a remote pc, how do we do
this? -> *Batch request*\ We simply get all data, then proceed to iterate on our
local machine.
-
#set text(size: 11pt)
// images
#align(
  center, [#image("../../Screenshots/2023_10_06_09_51_15.png", width: 50%)],
)
