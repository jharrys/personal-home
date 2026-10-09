# Gradle vs. Maven

* Both build systems have built-in capability to resolve dependencies
* Both can cache dependencies locally and download them in parallel

| Maven | Gradle | Notes |
| ----- | ------ | ----- |
| Maven allows overriding a dependency, only by version | Gradle allows customizable dependency selection & substitution rules, declared once and applied to whole project | The substitution mechanism from Gradle enables it to build multiple sources together to create [composite builds](https://docs.gradle.org/current/userguide/composite_builds.html) |
| Rigid in its extensibility (rely completely on plugins or awkward scripting within markup language tooling) | Modeled to be extensible in the most fundamental ways | Gradle is designed with embedding in mind using its [Tooling API](https://docs.gradle.org/current/userguide/embedding.html) |
| Few dependency scopes | Allows for custom dependency scopes | Custom scopes allows for better models and faster builds |
| No separation between unit and integration tests | Can separate unit and integration tests through use of custom dependency scopes | Example of custom scopes use in Gradle |
| Dependency conflict resolution works with shortest path | Does full conflict resolution | Shortest path (Maven) impacts dependency declaration ordering |
| No overriding of transitive versions | Use _strictly_ to override transitive versions, even [downgrading](https://docs.gradle.org/current/userguide/dependency_downgrade_and_exclude.html#sec:enforcing_dependency_version) | By default Gradle will choose latest version |
| As a library producer Maven allows publishers to provide metadata through optional dependencies, but as documentation only | Allows producers to declare as `api` or `implementation` to prevent unwanted libraries from **leaking** into classpaths of consumers | Gradle also supports [feature variants and optional dependencies](https://docs.gradle.org/current/userguide/feature_variants.html) |
| Build logic is not testable code | Testable build logic | Gradle supports Gradle DSL and Kotlin DSL |
| No compiler daemon | Reuses a long-lived compiler daemon (keeps info "hot" in memory) | faster startup; incremental builds |
| No debugging of build scripts | Supports debugging through build scripts | Intellij support for Gradle debugging |
| Weak or no support for incremental builds | Strong support for incremental builds including a compiler daemon | incremental may include tests as well as compilable units |
| Not very developer friendly (aging out) | Interactive web-based UI for debugging and analyzing builds: [Build Scan](https://gradle.com/gradle-enterprise-solution-overview/build-scan-root-cause-analysis-data/) |

last updated November 18, 2021.