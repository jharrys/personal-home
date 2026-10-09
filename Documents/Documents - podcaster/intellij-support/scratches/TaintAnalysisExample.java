import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

/** @noinspection unused*/
public class TaintAnalysisExample implements HttpHandler {
  private Connection connection;

  public void handle(HttpExchange exc) throws IOException {
    String productId = exc.getRequestHeaders().getFirst("productId");

    if (checkIsProductAvailable(productId)) {
      exc.sendResponseHeaders(200, 0);
    } else {
      exc.sendResponseHeaders(403, 0);
    }
  }

  private boolean checkIsProductAvailable(String productId) {
    try (Statement statement = connection.createStatement()) {
      String sql = "SELECT available FROM products WHERE product_id='" + productId + "'";
      statement.executeQuery(sql);
      try (ResultSet resultSet = statement.getResultSet()) {
        if (resultSet.next()) {
          return resultSet.getBoolean("available");
        }
        return false;
      }
    }
    catch (SQLException e) {
      throw new RuntimeException(e);
    }
  }
}