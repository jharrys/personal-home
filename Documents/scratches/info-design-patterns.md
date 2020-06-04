# Design Patterns

Good website for reference is the [tutorials point][1].

Design patterns can be categorized into three domains.

- Creational
- Structural
- Behavioral

### Creational

These hide the complexities of creating instances of classes. Encapsulation of instance creation.

1. Singleton (the instance is cached inside and you only can get the cached instance)
1. Factory Method (A class that creates a set of objects - e.g., cars)
1. Abstract Factory (A factory of factories; IndiaCarCreator, USACarCreator, JapanCarCreator)
1. Builder (Chaining if object requires lots of params)
1. Pooled (ThreadPool, JDBCPool, etc.)
1. Lazy init (Do not instantiate instance vars; wait until an action is performed: like caching of instance)
1. Prototype (clone of already existing objects; for complex hierarchies that are difficult to create the first time)

### Structural

These patterns create and organize relationships between different entities, simplifying to enhancing
relationships between classes.

1. Adapter (join independent interfaces)
1. Decorator (add functionality without updating the class and affecting class instances - e.g., ShapeDecorator)
1. Bridge (decouple abstraction from its implementation to allow extension without affecting either - e.g., separate a DrawAPI from Shape abstraction and a circle implementation)
1. Facade (expose a different interface or more simple interface to clients of the interface)
1. Composite (have a single object contain a group of like objects in a hierarchy - e.g., employees in an org can traverse whole org through single object CEO)
1. Flyweight (like singleton but for instances of objects - String interning - never create a new instance of string "A", once creeated always return the same instance of "A")
1. Proxy (provide access to a different object)

### Behavioral

Increase communication flexibility between objects. Behavioral patterns describe a process or flow. They
simplify this flow and make it more understandable.

**Note**: They accomplish tasks that would be difficult or impossible to achieve with objects.

1. value object (immutable, equality based on field/value not identity, great of multi-threading; can be used for DTO)
1. null object (removes NPE or null checks; e.g., Optional in java)
1. strategy (define multiple algorithms, decide which to use at runtime based on context)
1. command (data driven pattern; like a broker pattern; command is wrapped as object and the invoker desides who handles the command object)
1. chain of responsibility
1. interpreter (used in SQL parsing and symbol processing)
1. iterator (used in collections, etc)
1. mediator
1. memento (used to restore state of an object to a previous state)
1. observer (used when there is one-to-many relationship between objects such as if one object is modified, its depenedent objects are to be notified automatically)
1. state
1. template method
1. visitor



[1]: https://www.tutorialspoint.com/design_pattern
