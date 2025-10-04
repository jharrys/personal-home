import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PipedInputStream;
import java.io.PipedOutputStream;
import org.apache.commons.io.input.TeeInputStream;

class Scratch {

  public static void main(String[] args) throws IOException {
    // Create the source input stream.
    InputStream is = new FileInputStream("filename.txt");

    // Create a piped input stream for one of the readers.
    PipedInputStream in = new PipedInputStream();

    // Create a tee-splitter for the other reader.
    TeeInputStream tee = new TeeInputStream(is, new PipedOutputStream(in));

    // Create the two buffered readers.
    BufferedReader br1 = new BufferedReader(new InputStreamReader(tee));
    BufferedReader br2 = new BufferedReader(new InputStreamReader(in));

    // Do some interleaved reads from them.
    System.out.println("One line from br1:");
    System.out.println(br1.readLine());
    System.out.println();

    System.out.println("Two lines from br2:");
    System.out.println(br2.readLine());
    System.out.println(br2.readLine());
    System.out.println();

    System.out.println("One line from br1:");
    System.out.println(br1.readLine());
    System.out.println();
  }
}
