@GrabConfig(systemClassLoader = true)
@Grab(group = 'mysql', module = 'mysql-connector-java', version = '5.1.46')
import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException
@Grab(group = 'org.xerial', module = 'sqlite-jdbc', version = '3.36.0.3')

// to get @Grab to work on Intellij 2021.2.3
// I had to also import the ivy-x.y.z.jar into the module.

// also @GrabConfig is needed for loading jdbc drivers as they need to be loaded into the System Class Loader.