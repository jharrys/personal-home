/: .*[0-9][0-9]*$/{
h
d
}
/^http/{
g
N
s/.*:/LATEST &/
s#/usr/local/Caskroom/\([a-zA-Z0-9-]*\)/\(.*\) (.*)#INSTALLED \1: \2\
#
p
}
