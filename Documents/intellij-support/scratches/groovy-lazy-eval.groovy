int i = 3

def s1 = "i's value is: ${i}"
def s2 = "i's value is: ${-> i}"

i++

assert s1 == "i's value is: 3" // eagerly evaluated, takes the value on creation
assert s2 == "i's value is: 4" // lazily evaluated, takes the new value into account

i++


assert s1 == "i's value is: 3" // eagerly evaluated, takes the value on creation
assert s2 == "i's value is: 5" // lazily evaluated, takes the new value into account
