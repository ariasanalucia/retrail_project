---DDL
CREATE DATABASE retrail_project;
CREATE TABLE clientes(
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(20) NOT NULL,
	apellido VARCHAR(20) NOT NULL,
	mail VARCHAR(30) NOT NULL
);
CREATE TABLE productos(
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
	nombre_product VARCHAR(30) NOT NULL,
	precio DECIMAL(10,2) NOT NULL
);
CREATE TABLE ventas(
    id_ventas INT IDENTITY(1,1) PRIMARY KEY,
	fecha DATE NOT NULL DEFAULT (GETDATE()),
	id_cliente INT NOT NULL,
    CONSTRAINT FK_ventas_clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)

);
ALTER TABLE productos
ADD stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0);

CREATE TABLE detalle_ventaxproducto(
    id_detalle INT IDENTITY(1,1) PRIMARY KEY,
	cantidad INT NOT NULL,
	precio_unitario DECIMAL(6,2) NOT NULL,
	id_producto INT NOT NULL,
	id_ventas INT NOT NULL,
	CONSTRAINT FK_detalle_venta FOREIGN KEY (id_ventas) REFERENCES ventas(id_ventas),
	CONSTRAINT FK_detalle_producto FOREIGN KEY(id_producto) REFERENCES productos(id_producto)
);
ALTER TABLE detalle_ventaxproducto
ALTER COLUMN precio_unitario DECIMAL(10,2) NOT NULL;

DELETE FROM detalle_ventaxproducto
WHERE id_ventas = 1;

ALTER TABLE clientes
ADD UNIQUE (mail);

ALTER TABLE productos
ADD CHECK (precio >=0);

ALTER TABLE detalle_ventaxproducto
ADD CHECK (precio_unitario >0);

ALTER TABLE detalle_ventaxproducto
ADD CHECK(cantidad >=0);

---DML

BEGIN TRANSACTION;
INSERT INTO clientes(nombre, apellido, mail)
VALUES ('Pedro','Durrieu','pedrodurrieu@gmail.com'),
       ('Ana Lucia', 'Gomez', 'ani.gomez@gmail.com'),
       ('Lucia', 'Somma', 'luasomma@gmail.com'),
       ('Carlos', 'Hondarre', 'carlitoshonda@gmail.com'),
       ('Maria', 'Canevello', 'maricane.nutri@gmail.com');
INSERT INTO productos(nombre_product, precio, stock)
VALUES ('Termo Stanley Blanco', 139000, 10 ),
       ('Botella Stanley BLANCA', 80000, 15),
	   ('Mate Imperial', 50000, 20),
       ('Botella Stanley', 80000, 15),
       ('Vaso termico', 35000, 25),
       ('Termo Stanley Negro', 159000, 8);
INSERT INTO ventas(id_cliente)
VALUES(1),
      (2),
	  (4),
      (2),
	  (5),
      (2),
      (3),
      (5);
INSERT INTO detalle_ventaxproducto(cantidad, precio_unitario, id_producto, id_ventas)
VALUES (2, 150000.00, 1, 1),
       (1, 50000.00, 2, 1),
       (3, 35000.00, 4, 2),
       (1, 160000.00, 5, 3),
       (2, 80000.00, 3, 4),
       (1, 50000.00, 2, 5);
DELETE FROM ventas
WHERE id_ventas = 1;

COMMIT;