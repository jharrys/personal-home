###### cd to /tmp to run exercises
cd /tmp

##########################################################################################
# named pipes and command substitution
# assume h.txt contains "hello bye good"
cat >h.txt <<EOF
hello bye good
EOF
paste <(cut -d' ' -f1 h.txt) <(cut -d' ' -f3 h.txt) > >(tr "\t" ";") # output: hello;good

##########################################################################################
###### screen casting using script between terminals
# on terminal 1 do
mkfifo screenshare
script -t 0 screenshare

# on terminal 2 do
cat screenshare

# no do anything in terminal 1 and it will be echod in terminal 2
# in terminal one type CTL^D

##########################################################################################
###### screen casting using script and nc between machines
# remote machine start listener on port 9999
nc -l -p 9999

# host machine
mkfifo screenshare
script -t 0 screenshare
nc ${ip-of-listener} 9999 <screenshare

##########################################################################################
###### print out the number of files in a directory
ls -l **/*(/l+20) # will glob for dirs only with "link count" >=20
