:: Johnnie Harris 2015
:: Needs to be run as Administrator

:: MT - Multiple Threads
:: Z - run in restartable mode (if interrupted it can restart where it left off)
:: B - run in Backup mode (open files can be backed up)

robocopy \Users\lpjharri\Documents\MailArchives\ \\co.ihc.com\root\CO\TL\User\lpjharri\MailArchives /MT:64 /ZB