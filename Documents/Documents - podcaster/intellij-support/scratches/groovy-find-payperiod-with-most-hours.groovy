import java.time.DayOfWeek
import java.time.LocalDate
import java.time.LocalDateTime

(2020..2023).each { year ->
    (1..12).each { month ->
        LocalDate monthDate = LocalDate.of(year, month, 1)
        int startDay = 1
        int endDay = 15

        int workWeekPp1 = 0
        (startDay..endDay).each { day ->
            LocalDate date = LocalDate.of(year, month, day)
            if (date.dayOfWeek.value < 6) {
                workWeekPp1++
            }
        }

        startDay = startDay + 15
        endDay = monthDate.lengthOfMonth()
        int workWeekPp2 = 0
        (startDay..endDay).each { day ->
            LocalDate date = LocalDate.of(year, month, day)
            if (date.dayOfWeek.value < 6) {
                workWeekPp2++
            }
        }
        if (workWeekPp1 > 11 || workWeekPp2 > 11) {
            if (workWeekPp1 > workWeekPp2)
                println "$year: ${monthDate.month} PP1 = ${workWeekPp1 * 8}"
            else
                println "$year: ${monthDate.month} PP2 = ${workWeekPp2 * 8}"
        }
    }
}
