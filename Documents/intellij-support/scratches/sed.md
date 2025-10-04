# sed matching paragraphs across multiple lines

`sed -e '/./{H;$!d;}' -e 'x;/AAA/!d;' file`

understood better as

```
/./{
    H
    $!d
}
x
/AAA/!d
```
explained

```
/./{        # When hitting a line that contains at least one character...
    H;      # Append the line to the "hold space".
    $!d;    # If it's not the last line, delete it. (! negates the pattern)
}
x;          # Swap the hold space and the pattern space.
/AAA/!d;    # Delete the pattern space if it does not contain the string "AAA"
            # (implicit print)
```
