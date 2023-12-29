#import "../../utils.typ": *

#subsection("Memento")
#set text(size: 14pt)
Problem | *History* -> Object should remember its own state\
Category | *Behavioral*\
Participants | Originator -> Object in question, Memento -> History, e.g. stack,
Caretaker -> storage, e.g. database
#set text(size: 11pt)
#align(
  center, [#image("../../Screenshots/2023_09_29_09_21_19.png", width: 80%)],
)

```java
// Memento
import org.jetbrains.annotations.Nullable;
public class Memento {
  private final String savedState;

  @Nullable
  String getState() {
    return savedState;
  }
  Memento(@Nullable String state) {
    savedState = state;
  }
}

// Originator
import org.jetbrains.annotations.NotNull;
public class Originator {
  private String internalData;

  @NotNull
  public Memento createMemento() {
    return new Memento(internalData);
  }

  public void setMemento(@NotNull Memento memento) {
    internalData = memento.getState();
  }
}
```

- similar:
  - Serialization
  - Future Pattern

#columns(2, [
  #text(green)[Benefits]
  - Internal state of an object can be saved and restored at any time
  - Encapsulation of attributes is not harmed
  - State of objects can be restored later
  #colbreak()
  #text(red)[Liabilities]
  - Creates a complete copy of the object every time, no diffs
  - May require a lot of memory
  - No direct access to saved state, it must be restored first
])

#subsection("Singleton (Base)")
#text(red)[This is explained better later on]
Problem | *Static Instance* -> only 1 object of this type should exist\
Category | *Creational*
#columns(
  2, [
    #text(green)[Benefits]
    - clean solution to single object
    - solves dependencies including the singleton object
    - solves argument spam in functions
    #colbreak()
    #text(red)[Liabilities]
    - if built wrong can lead to needless mock implementations of a singleton -> mock
      singletons for tests
    - can lead to race conditions -> not in rust
    - might require getDB() calls
  ],
)

#subsection([Chain of Responsibility])
*Problem* |\
- Coupling the sender of a request to its receiver should be avoided.
- It should be possible that more than one receiver can handle a request.
*Solution* | Define a chain of receiver objects having the responsibility,
depending on run-time conditions, to either handle a request or forward it to
the next receiver on the chain (if any).
// images

#align(center, [#image("../uml/responsibility.jpg", width: 100%)])
```cpp
#include <iostream>
#include <memory>

typedef int Topic;
constexpr Topic NO_HELP_TOPIC = -1;

// defines an interface for handling requests.
class HelpHandler { // Handler
public:
  HelpHandler(HelpHandler* h = nullptr, Topic t = NO_HELP_TOPIC)
    : successor(h), topic(t) {}
  virtual bool hasHelp() {
    return topic != NO_HELP_TOPIC;
  }
  virtual void setHandler(HelpHandler*, Topic) {}
  virtual void handleHelp() {
    std::cout << "HelpHandler::handleHelp\n";
    // (optional) implements the successor link.
    if (successor != nullptr) {
      successor->handleHelp();
    }
  }
  virtual ~HelpHandler() = default;
  HelpHandler(const HelpHandler&) = delete; // rule of three
  HelpHandler& operator=(const HelpHandler&) = delete;
private:
  HelpHandler* successor;
  Topic topic;
};

class Widget : public HelpHandler {
public:
  Widget(const Widget&) = delete; // rule of three
  Widget& operator=(const Widget&) = delete;
protected:
  Widget(Widget* w, Topic t = NO_HELP_TOPIC)
    : HelpHandler(w, t), parent(nullptr) {
    parent = w;
  }
private:
  Widget* parent;
};

// handles requests it is responsible for.
class Button : public Widget { // ConcreteHandler
public:
  Button(std::shared_ptr<Widget> h, Topic t = NO_HELP_TOPIC) : Widget(h.get(), t) {}
  virtual void handleHelp() {
    // if the ConcreteHandler can handle the request, it does so; otherwise it forwards the request to its successor.
    std::cout << "Button::handleHelp\n";
    if (hasHelp()) {
      // handles requests it is responsible for.
    } else {
      // can access its successor.
      HelpHandler::handleHelp();
    }
  }
};

class Dialog : public Widget { // ConcreteHandler
public:
  Dialog(std::shared_ptr<HelpHandler> h, Topic t = NO_HELP_TOPIC) : Widget(nullptr) {
    setHandler(h.get(), t);
  }
  virtual void handleHelp() {
    std::cout << "Dialog::handleHelp\n";
    // Widget operations that Dialog overrides...
    if(hasHelp()) {
      // offer help on the dialog
    } else {
      HelpHandler::handleHelp();
    }
  }
};

class Application : public HelpHandler {
public:
  Application(Topic t) : HelpHandler(nullptr, t) {}
  virtual void handleHelp() {
    std::cout << "Application::handleHelp\n";
    // show a list of help topics
  }
};

int main() {
  constexpr Topic PRINT_TOPIC = 1;
  constexpr Topic PAPER_ORIENTATION_TOPIC = 2;
  constexpr Topic APPLICATION_TOPIC = 3;
  // The smart pointers prevent memory leaks.
  std::shared_ptr<Application> application = std::make_shared<Application>(APPLICATION_TOPIC);
  std::shared_ptr<Dialog> dialog = std::make_shared<Dialog>(application, PRINT_TOPIC);
  std::shared_ptr<Button> button = std::make_shared<Button>(dialog, PAPER_ORIENTATION_TOPIC);

  button->handleHelp();
}
```

#columns(2, [
  #text(green)[Benefits]
  - events are handled by the first to be able to
  - concrete handling of events that no handler can process
  #colbreak()
  #text(red)[Liabilities]
  - all events will be passed through the chain
    - might sometimes be slow -> last of chain
    - multithreaded non-hierarchical is faster here
])
