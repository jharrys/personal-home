# Debugging Gradle Kts in Intellij

* Create a run/debug configuration using the Remote JVM Debug template
* Run `./gradlew build -Dorg.gradle.debug=true --no-daemon`
* Add your break points to the script
* Run the debug configuration you created earlier
* gradlew will wait until the debugger is connected before running
