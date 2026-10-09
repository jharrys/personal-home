import java.lang.invoke.VarHandle;
import org.mockito.Mock;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

class webflux {

  private int a = 5;

  /**
   * Understand the Mono.defer use case.
   *
   * <p>Mono.just will evaluate and dereference a to its value immediately and its done. Subsequent
   * calls to the var monoJust will be using the value 5.
   *
   * <p>The var monoDefer actually contains a lambda not a value = () -> Mono.just(a). Therefore, it
   * will evaluate 'a' each time ... lazy evaluation vs eager.
   */
  public void run() throws Exception {

    Mono<Integer> monoJust = Mono.just(a);
    Mono<Integer> monoDefer = Mono.defer(() -> Mono.just(a));

    monoJust.subscribe(integer1 -> System.out.println(integer1));
    monoDefer.subscribe(integer1 -> System.out.println(integer1));

    a = 7;
    monoJust.subscribe(integer1 -> System.out.println(integer1));
    monoDefer.subscribe(integer1 -> System.out.println(integer1));
  }

  /**
   * Used for an example with the handle method.
   */
  public String alphabet(int letterNumber) {
    if (letterNumber < 1 || letterNumber > 26) {
      return null;
    }
    int letterIndexAscii = 'A' + letterNumber - 1;
    return "" + (char) letterIndexAscii;
  }

  public static void main(String[] args) throws Exception {
    webflux w = new webflux();

    // defer vs. just
    w.run();

    /**
     * Use handle to skip; have access to sink (it's a SynchronousSink) - SynchronousSink only
     * allows 1 by 1 emissions.
     *
     * Part of the reactive streams spec disallows nulls in sequences.
     *
     * Filter null by not calling sink.next() on it.
     */
    Flux<String> alphabet =
        Flux.just(-1, 30, 13, 9, 20)
            .handle(
                (i, sink) -> {
                  String letter = w.alphabet(i);
                  if (letter != null) sink.next(letter);
                });

    alphabet.subscribe(System.out::println);
  }

  /**
   * Use case for Mono.then() ... works when a Mono comes back than you can ignore, such as
   * deleting an object from a repository (the results coming back are none or don't matter).
   *
   * Mono.then() ignores the preceding mono signal
   */
  @DeleteMapping("/tweets/{id}")
  public Mono<ResponseEntity<Void>> deleteTweet(@PathVariable(value = "id") String tweetId) {

    return tweetRepository
        .findById(tweetId)
        .flatMap(
            existingTweet ->
                tweetRepository
                    .delete(existingTweet)
                    .then(Mono.just(new ResponseEntity<Void>(HttpStatus.OK))))
        .defaultIfEmpty(new ResponseEntity<>(HttpStatus.NOT_FOUND));
  }
}
