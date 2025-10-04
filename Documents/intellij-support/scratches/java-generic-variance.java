import java.util .*;
import java.math .*;

class Scratch {

    public static void main(String[] args) {
      List<Float> list = Arrays.asList(2.2f);
      process(list);
    }

    //covariance
    public static void process(List<? extends Number> list) {
      for (Number n : list) {
        System.out.println(n.shortValue());
      }
    }
}
