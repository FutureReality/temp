#!/bin/bash

DB_USER="root"
DB_PASS="auditor"
DB_NAME="CI_NA_Tickets"
SMTP_FROM="no-reply@computerinnovations.com"

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -se \
"SELECT JSON_OBJECT('id', id, 'email', email, 'subject', subject, 'message', message) FROM pending_mails WHERE sent = 0;" | \
while read -r json; do
    id=$(echo "$json" | jq -r .id)
    email=$(echo "$json" | jq -r .email)
    subject=$(echo "$json" | jq -r .subject)
    message=$(echo "$json" | jq -r .message)

    echo "$message" | mail -s "$subject" -r "$SMTP_FROM" "$email"

    if [ $? -eq 0 ]; then
        mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "DELETE FROM pending_mails WHERE id = $id"
    else
        echo "Error al enviar el correo a $email" >> errores_envio.log
    fi
done
