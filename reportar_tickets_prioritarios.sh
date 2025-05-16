#!/bin/bash

DB_USER="root"
DB_PASS="auditor"
DB_NAME="CI_NA_Tickets"
SMTP_TO="it@computerinnovations.com"
SMTP_FROM="no-reply@computerinnovations.com"

# Solo tickets abiertos en los más antiguos
antiguos=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -Bse \
"SELECT CONCAT('ID: ', id_ticket, ', Fecha: ', fechaEmision, ', Estado: ', estado, ', Prioridad: ', prioridad, ', Asunto: ', asunto)
 FROM Tickets WHERE estado != 'Cerrado' ORDER BY fechaEmision ASC LIMIT 10;")

# Solo prioridad ALTA y abiertos
altos=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -Bse \
"SELECT CONCAT('ID: ', id_ticket, ', Fecha: ', fechaEmision, ', Estado: ', estado, ', Prioridad: ', prioridad, ', Asunto: ', asunto)
 FROM Tickets WHERE LOWER(prioridad) = 'alto' AND estado != 'Cerrado';")

mail_body="Reporte de tickets importantes - $(date)

📌 10 tickets más antiguos (solo abiertos):
$antiguos

📌 Tickets con prioridad ALTA (solo abiertos):
$altos
"

echo -e "From: Helpdesk <$SMTP_FROM>\nTo: $SMTP_TO\nSubject: Reporte de tickets críticos y antiguos\n\n$mail_body" | /usr/sbin/sendmail -t
