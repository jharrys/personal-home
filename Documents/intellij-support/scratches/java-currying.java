import java.util.function.Function;

/** See https://www.baeldung.com/java-currying for a nice builder pattern using currying in java */
class Currying {

  public static void main(String[] args) {
    // Using Java 8 Functions
    // to create lambda expressions for functions
    // and with this, applying Function Currying

    // Curried Function for Adding u & v
    Function<Integer, Function<Integer, Integer>> curryAdder = u -> v -> u + v;

    // Calling the curried functions

    // Calling Curried Function for Adding u & v
    System.out.println("Add 2, 3 :" + curryAdder.apply(2).apply(3));

    // currying using functions
    Function<String, Function<String, Letter>> curryLetterCreator =
        salutation -> body -> new Letter(salutation, body);

    Function<String, Letter> partialFunction = curryLetterCreator.apply("Dear, ");

    System.out.println(partialFunction.apply("This is the body!"));
  }
}

class Letter {
  private String salutation;
  private String body;

  Letter(String salutation, String body) {
    this.salutation = salutation;
    this.body = body;
  }

  @Override
  public String toString() {
    return "salutation: " + this.salutation + "\nbody: " + this.body;
  }
}
