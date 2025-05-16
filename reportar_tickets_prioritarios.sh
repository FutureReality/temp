#!/bin/bash

DB_USER="root"
DB_PASS="auditor"
DB_NAME="CI_NA_Tickets"
SMTP_TO="angellitillo300@gmail.com"
SMTP_FROM="Helpdesk <no-reply@computerinnovations.com>"

# Obtener los 10 tickets más antiguos (solo abiertos)
antiguos=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -Bse \
"SELECT CONCAT('ID: ', id_ticket, ', Fecha: ', fechaEmision, ', Estado: ', estado, ', Prioridad: ', prioridad, ', Asunto: ', asunto)
 FROM Tickets WHERE estado != 'Cerrado' ORDER BY fechaEmision ASC LIMIT 10;")

# Obtener tickets con prioridad ALTA (solo abiertos)
altos=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -Bse \
"SELECT CONCAT('ID: ', id_ticket, ', Fecha: ', fechaEmision, ', Estado: ', estado, ', Prioridad: ', prioridad, ', Asunto: ', asunto)
 FROM Tickets WHERE LOWER(prioridad) = 'alto' AND estado != 'Cerrado';")

# Construir cuerpo del correo
mail_body="Reporte de tickets importantes - $(date)

📌 10 tickets más antiguos (solo abiertos):
$antiguos

📌 Tickets con prioridad ALTA (solo abiertos):
$altos
"

# Enviar el correo usando `mail -s`
echo "$mail_body" | mail -s "Reporte de tickets críticos y antiguos" -a "From: $SMTP_FROM" "$SMTP_TO"
