1. cp sasl_passwd to /etc/postfix and chown to root.
2. execute 'sudo postmap /etc/postfix/sasl_passwd' - will the create the hash db.
3. may not be needed: sudo postfix stop; sudo postfix start
4. sudo postfix status

NOTE: postfix runs when needed; it doesn't use a daemon that runs all the time - works like inet.
