import java.sql.Timestamp;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


class SomeTest {

  /**
   * This is a configuration for Spring framework testing using a clock fixture.
   *
   * @Configuration overrides main production code for any already existing beans. It also does the
   * auto scanning. @TestConfiguration is available and "adds to" the existing beans, will not
   * override. Additionallly, it does not do auto scanning.
   */
  @Configuration
  static class Config {

    /*
    Create a bean of type Clock.fixed to return the same instant every time.
     */
    @Bean
    Clock clock() {
      // create clock 7 years into the future of now().
      Clock offsetClock = Clock.offset(Clock.systemDefaultZone(), Duration.ofDays(365L * 7L));

      // create clock for instant of 2015-08-19
      Clock fixedClock =
          Clock.fixed(Instant.parse("2015-08-19T16:02:42.00Z"), ZoneId.systemDefault());

      // return fixedClock
      return fixedClock;
    }
  }

  @Autowired
  private Clock clock;

  public static void main(String[] args) {
    SomeTest someTest = new SomeTest();
    LocalDate date = LocalDate.now(someTest.clock);

    // get epoch millis from LocalDate
    System.out.println(
        "millis from localdate: " + date.atStartOfDay(ZoneId.systemDefault()).toInstant()
            .toEpochMilli());

    // get epoch millis from Instant
    System.out.println("millis from instant: " + Instant.now(someTest.clock).toEpochMilli());

    // localdate to timestamp
    System.out
        .println("localdate -> timestamp: " + Timestamp.valueOf(date.atTime(LocalTime.MIDNIGHT)));

  }

}

// The following is a best practice clock bean for Spring apps. It's best practice
// to define a Clock (for >=Java8). Then in tests you can provide your own Clock fixture to test
// dates appropriately.

// Remember, making your app testable is good design.
@Configuration
class AppConfiguration {

  /**
   * Provide a default system clock for production.
   *
   * <p>This bean can be mocked for testing by creating a mock of Clock or by using
   * Clock.fixed(Instant, ZoneId) or Clock.offset(Clock, Duration).
   *
   * <p>Real clock: Clock.systemDefaultZone();
   *
   * <p>Offset clock that is 72 hours ahead of current time:
   * Clock.offset(Clock.systemDefaultZone(), Duration.ofHours(72));
   *
   * <p>Fixed clock that returns the same instance every time:
   * Clock.fixed(Instant.parse("2018-08-19T16:02:42.00Z"), ZoneId.systemDefault());
   *
   * @return the system clock for production.
   */
  @Bean
  public Clock clock() {
    return Clock.systemDefaultZone();
  }
}
