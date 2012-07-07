#!/bin/sh

VMNAME="Fedora 13"

VBoxManage --nologo startvm "$VMNAME" |tee -a $LOG

exit 0

# -------------------------------------------------------------------------------------------------------
# The code below was setup to try to start the VM
# Ensure that the user got logged in (through Fedora's auto-login)
# And then pause the VM until it was actually needed (I would be running this as a login startup item)
# Alas,
# it does not work. Somehow the running VM becomes disconnected with VirtualBox and things get screwey
# the VM was disappearing auto-magically.
# -------------------------------------------------------------------------------------------------------

LOG="/tmp/vbox.log"
SLEEP=60

# init log
date > $LOG

echo | tee -a $LOG
echo "Waiting for GUI to start and User to login ..." | tee -a $LOG

# This will "wait" for NoLoggedInUsers property to change - because we are starting it should become "false"
RESULT=$( VBoxManage --nologo guestproperty wait "$VMNAME" /VirtualBox/GuestInfo/OS/NoLoggedInUsers | tee -a $LOG )

#echo "debug: $RESULT" | tee -a $LOG

# Make sure we wait until a user is logged in, if not wait until one is
echo "$RESULT" |grep "value: false"
if [ $? -ne 0 ]
then
	RESULT=$( VBoxManage --nologo guestproperty wait "$VMNAME" /VirtualBox/GuestInfo/OS/NoLoggedInUsers | tee -a $LOG )
fi

#echo "debug: $RESULT" | tee -a $LOG

# Give some more time to the VM to get things in order before pausing
echo "Sleeping for $SLEEP to ensure GUI comes all the way up" | tee -a $LOG
sleep $SLEEP

# place vm in pause state
echo "Pausing $VMNAME" | tee -a $LOG
VBoxManage --nologo controlvm "$VMNAME" pause | tee -a $LOG
