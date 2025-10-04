// Fibonacci in Java using closures
import java.util.stream.Stream;

class Scratch {

  public static void main(String[] args) {
    int[] fibs = {0, 1};
    Stream<Integer> fibonacci = Stream.generate(() -> {
      int result = fibs[1];
      int fib3 = fibs[0] + fibs[1];
      fibs[0] = fibs[1];
      fibs[1] = fib3;
      return result;
    }).limit(10);

    fibonacci.forEach(System.out::println);
  }
}

// My own Functional Interface - for if I do it, I remember it.
@FunctionalInterface
interface Something<T> {
  T crazy();
}

class Blue {
  String aString = "";
  public Blue(Something<String> blueOne) {
    aString = blueOne.crazy();
  }

  public Blue(String message) {
    this(() ->{
      StringBuilder result = new StringBuilder(message);
      result.append("\nMy name is Johnnie!!!! 😇");
      return result.toString();
    });
  }

  public static void main(String[] args) {
    Blue blue = new Blue("Hello World!");
    System.out.println(blue.aString);
  }
}


