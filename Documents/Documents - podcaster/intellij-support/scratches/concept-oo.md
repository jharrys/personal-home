## Overloading vs Overriding in Java

1. Overloading happens at [compile-time][1] while Overriding happens at [runtime][1]: The binding of overloaded method
   call to its definition has happens at compile-time however binding of overridden method call to its definition
   happens at runtime.

2. _Static methods can be overloaded_ which means a class can have more than one static method of same name. Static
   methods cannot be overridden, even if you declare a same static method in child class it has nothing to do with the
   same method of parent class.

3. The most basic difference is that **overloading is being done in the same class** while for overriding base and child
   classes are required. Overriding is all about giving a specific implementation to the inherited method of parent
   class.

4. [Static binding][2] is being used for overloaded methods and [dynamic binding][2] is being used for
   overridden/overriding methods.

5. Performance: **Overloading gives better performance compared to overriding**. The reason is that the binding of
   overridden methods is being done at runtime.

6. private and final methods can be overloaded, but they cannot be overridden. It means a class can have more than one
   private/final methods of same name but a child class cannot override the private/final methods of their base class.

7. Return type of method does not matter in case of method overloading, it can be same or different. However, in case of
   method overriding the overriding method can have more specific return
   type [refer this](https://stackoverflow.com/questions/14694852/can-overridden-methods-differ-in-return-type).

8. Argument list should be different while doing method overloading. Argument list should be same in method Overriding.

[1]: <https://beginnersbook.com/2013/04/runtime-compile-time-polymorphism/>

[2]: <https://beginnersbook.com/2013/04/java-static-dynamic-binding/>