import com.intellij.openapi.ui.Messages.showInfoMessage
var sum: Long = 0L
val arr = "35907 77134 453661 175096 23673 29350".split(" ")
arr.forEach { sum+=it.length }

showInfoMessage((sum.toFloat() / arr.size).toString(), "test")
