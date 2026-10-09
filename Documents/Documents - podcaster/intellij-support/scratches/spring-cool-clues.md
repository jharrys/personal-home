# Spring optional config property value

```
@Value('${app.profile:#{null}}')
```
# tests: internal @Configuration for Autowired and Mocked beans in test
```java
 @RunWith(SpringRunner.class)
 public class ExampleTests {

     @SpyBean
     private ExampleService service;

     @Autowired
     private UserOfService userOfService;

     @Test
     public void testUserOfService() {
         String actual = this.userOfService.makeUse();
         assertEquals("Was: Hello", actual);
         verify(this.service).greet();
     }

     @Configuration
     static class Config {
     }
 }
```