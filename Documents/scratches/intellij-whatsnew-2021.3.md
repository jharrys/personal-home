# What is new for 2021.3

## debugger knows about inline functions
* can display in stack trace panel
* can navigate to inline calls
* can inspect & eval run in each frame
* see [inline gif](https://www.jetbrains.com/idea/whatsnew/2021-3/img/KeyUpdates_DebuggerKotlin_2.gif)

## debugger: smart step (F7)
* for chained method calls & lambdas
* intellij highlights the methods and lambdas that can be stepped into
* the ide will highlight the places you can step into, and you need to **select the line you want by clicking on it** to see variables & evaluate
* see [smart step gif](https://www.jetbrains.com/idea/whatsnew/2021-3/img/KeyUpdates_DebuggerKotlin.png)

## MarkDown now supports tables!
* use `command-N` to open context menu
* lets you insert table, image and link
* use `shift-enter` and `tab` to navigate cells and insert new rows.

## preview results of intention actions
* use `option-enter` to bring up intentions
* press `F1` to activate previews
* if preview is available, it will show it next to the intention

## Groovy 4 Full Support
* inspections, insights, intentions, switch expressions and sealed types

## change font on All editor tabs
* enable in preferences

## Split Run Tool Window
* run tool window can be split!
* drag & drop and unsplit

## New bookmark window
* replaces favorites
* flag file, folders and classes
* sort them using Groups and Bookmarks option

## maven.config recognized by intellij now
* a project can now override general settings (.mvn/maven.config)

## text and json streams on the fly
* http client now supports this

## binary responses from http client
* can preview images, etc.

## output redirection with http client
* supports `>>` or `>>!` to overwrite

## yaml code completion!
* property or yaml files support code completion for `@value, @scheduled and Environment.getProperty`  

## Test Case Management (test run hierarchy & shared steps using MD files)
* called **Shared Steps**
* use the "Local TMS" feature (requires the Test Management Plugin) - I had to install it 
* you declare test steps and share them among multiple test cases
* shared steps are declared as a regular test case with a unique numeric ID
* you can refer to that test case in other test cases
* see [test run hierarchy gif](https://www.jetbrains.com/idea/whatsnew/2021-3/img/QATools_TestManagemnet_TestRunHierarchy.jpg)
* see [shared steps gif](https://www.jetbrains.com/idea/whatsnew/2021-3/img/QATools_TestManagement_SharedSteps.gif)

## Improved Docker Support
* view registries
* support docker compose v2
* improved image layers