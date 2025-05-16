DELIMITER $$

CREATE TRIGGER trg_ticket_insertado
AFTER INSERT ON Tickets
FOR EACH ROW
BEGIN
  DECLARE cliente_email VARCHAR(255);

  SELECT u.email INTO cliente_email
  FROM Clientes c
  JOIN Usuarios u ON c.id_usuario = u.id_usuario
  WHERE c.id_cliente = NEW.id_cliente;


  INSERT INTO pending_emails (email, subject, message, sent)
  VALUES (
    cliente_email,
    CONCAT('Ticket ', NEW.id_ticket),
    CONCAT(
      'El ticket con id: ', NEW.id_ticket,
      ' ha sido recibido por los técnicos, pronto se ocuparán.\n\n',
      'Título: ', NEW.asunto, '\n',
      'Descripción: ', NEW.descripcion
    ),
    0
  );
END$$

DELIMITER ;
