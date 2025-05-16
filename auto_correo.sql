DELIMITER $$

CREATE TRIGGER after_insert_ticket
AFTER INSERT ON Tickets
FOR EACH ROW
BEGIN
  DECLARE cliente_email VARCHAR(255);

  SELECT email INTO cliente_email
  FROM Clientes
  WHERE id_cliente = NEW.id_cliente;

  INSERT INTO pending_mails (email, subject, message, sent)
  VALUES (
    cliente_email,
    CONCAT('Ticket ', NEW.id_ticket),
    CONCAT(
      'El ticket con id: ', NEW.id_ticket, ' ha sido recibido por los técnicos, pronto se ocuparán.\n\n',
      'Título: ', NEW.asunto, '\n',
      'Descripción: ', NEW.descripcion
    ),
    0
  );
END$$

DELIMITER ;
