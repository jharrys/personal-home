REM TRIM is used to improve performance on SSD drives with Windows 7
REM Windows 7 should be able to identify SSD and enable TRIM
REM if not, then it's probably an SSD Windows 7 is not familiar with

REM To identify if TRIM is on or not. On=0; Off=1
fsutil behavio query DisableDeleteNotify

REM To enable it, uncomment below
REM fsutil behavior set disablenotify 0