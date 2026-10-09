@Grab(group = 'com.sun.mail', module = 'javax.mail', version = '1.6.0')

import javax.mail.Message
import javax.mail.Session
import javax.mail.Transport
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeMessage

MAILER_HOST = "smtp-relay.churchofjesuschrist.org"
MAILER_USER = "blah"
MAILER_PASS = "blah"
MAILER_PORT = 25

private void runScript() {
    Session session = Session.getDefaultInstance(new Properties())

    MimeMessage message = new MimeMessage(session)
    message.setFrom("dm-alert-no-reply@churchofjesuschrist.org")
    message.setRecipients(Message.RecipientType.TO, "8015894721@messaging.sprintpcs.com, harris.johnny@gmail.com")
    message.setSubject("JJJJJ")
    message.setText("HelloA")

    Transport transport = session.getTransport()
    transport.connect(MAILER_HOST, MAILER_PORT, null, null)
    transport.sendMessage(message, message.getAllRecipients())
    transport.close()
}

runScript()
