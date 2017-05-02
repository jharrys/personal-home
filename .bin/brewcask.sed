/: .*$/{
h
d
}
/^http/{
g
N
/^From: .*/d
s/.*:/LATEST &/
s#/usr/local/Caskroom/\([a-zA-Z0-9-]*\)/\(.*\) (.*)#INSTALLED \1: \2\
#
p
}
