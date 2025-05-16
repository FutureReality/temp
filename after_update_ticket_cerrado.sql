DELIMITER $$

CREATE TRIGGER after_update_ticket
AFTER UPDATE ON Tickets
FOR EACH ROW
BEGIN
  DECLARE cliente_email VARCHAR(255);

  IF NEW.estado = 'Cerrado' AND OLD.estado != 'Cerrado' THEN
    SELECT u.email INTO cliente_email
    FROM Usuarios u
    INNER JOIN Clientes c ON c.id_usuario = u.id_usuario
    WHERE c.id_cliente = NEW.id_cliente;

    INSERT INTO pending_mails (email, subject, message, sent)
    VALUES (
      cliente_email,
      CONCAT('Ticket ', NEW.id_ticket),
      CONCAT(
        'Su ticket con id ', NEW.id_ticket, ' ha sido llegado a los técnicos.\n\n',
        'Título: ', NEW.asunto, '\n',
        'Descripción: ', NEW.descripcion
      ),
      0
    );
  END IF;
END$$

DELIMITER ;
