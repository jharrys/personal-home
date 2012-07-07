-- Errors from Interop
SELECT   a.msg_id, 
        a.msg, 
        b.error, 
        b.msg_tz,
FROM interop_error_log a, interop_error_log_msg b
WHERE a.msg_id = b.msg_id and
b.error not like '%Resource for Message Type cannot be found%'

/

