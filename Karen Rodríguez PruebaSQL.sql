CREATE SCHEMA minimarketjose;

USE minimarketjose;

 #creacion de tablas
CREATE TABLE Proveedor(
	proveedor_id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(20),
    telefono INTEGER,
    direccion VARCHAR(50),
    fecha_ultima_visita DATE
);

CREATE TABLE CategoriaProducto(
	categoria_producto_id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre_categoria VARCHAR(20)
);

CREATE TABLE Producto(
	producto_id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(20),
    precio_compra DOUBLE,
    precio_venta DOUBLE,
    marca VARCHAR(20)
);

CREATE TABLE ProveedorProducto(
	proveedor_producto_id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL
);

CREATE TABLE Inventario(
	inventario_id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    cantidad_disponible_producto INTEGER
);

CREATE TABLE Cliente(
	cliente_id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(20),
    telefono INTEGER,
    direccion VARCHAR(50)
);

CREATE TABLE Boleta(
	boleta_id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    cantidad_vendido INTEGER,
    precio_total_cantidad DOUBLE,
    metodo_pago VARCHAR(10),
    fecha DATE,
    descuento DOUBLE,
    total_venta DOUBLE
);

#borre una columna que al pensarlo bien siento que no agreagaba nada
ALTER TABLE Boleta DROP COLUMN precio_total_cantidad;

#crear las columnas para luego convertilas en foreign keys
ALTER TABLE  ProveedorProducto ADD proveedor_id INTEGER NOT NULL;
ALTER TABLE ProveedorProducto
ADD FOREIGN KEY (proveedor_id) REFERENCES Proveedor(proveedor_id);

ALTER TABLE  ProveedorProducto ADD producto_id INTEGER NOT NULL;
ALTER TABLE ProveedorProducto
ADD FOREIGN KEY (producto_id) REFERENCES Producto(producto_id);

ALTER TABLE  Producto ADD categoria_producto_id INTEGER NOT NULL;
ALTER TABLE Producto
ADD FOREIGN KEY (categoria_producto_id ) REFERENCES CategoriaProducto(categoria_producto_id );

ALTER TABLE Inventario ADD producto_id INTEGER NOT NULL;
ALTER TABLE Inventario
ADD FOREIGN KEY (producto_id ) REFERENCES Producto(producto_id );

ALTER TABLE Boleta ADD producto_id INTEGER NOT NULL;
ALTER TABLE Boleta
ADD FOREIGN KEY (producto_id ) REFERENCES Producto(producto_id );

ALTER TABLE Boleta ADD cliente_id INTEGER NOT NULL;
ALTER TABLE Boleta
ADD FOREIGN KEY (cliente_id ) REFERENCES Cliente(cliente_id );

#agregar una columna importante que olvide
ALTER TABLE Cliente ADD Rut INTEGER;
ALTER TABLE Cliente RENAME COLUMN Rut TO rut;

#inserta 4 tipos de producto
INSERT INTO CategoriaProducto VALUES(1, "Papeleria"), (2, "Víveres"), (3, "Limpieza");
INSERT INTO CategoriaProducto VALUES(4, "Dulces");

#insertar 5 productos
INSERT INTO Producto(nombre, precio_compra, precio_venta, marca, categoria_producto_id) 
VALUES("Mayonesa 500gr", 1500.0, 2300.0, "Heinz", 2),
("Arroz 1kg", 950.90, 1200.0, "Río Blanco", 2),
("Jabón de 3 unidades", 800.0, 900.0, "Dove", 3),
("Lapiz negro", 300.0, 500.0, "Sharpie", 1),
("Shampoo 1lt", 1450.0, 1800.0, "Dove", 3);

#insertar clientes
INSERT INTO Cliente (nombre, telefono, direccion, rut)
VALUES("Javiera Rosa", 975634879, "Magallanes 75", 234569872),
("Jose Villaroel", 997634879, "Toesca 34", 176549876),
("Elliana Renta", 975632345, "Patronato 132", 256782349);

#insertar boletas
INSERT INTO Boleta (cantidad_vendido, metodo_pago, fecha, descuento, total_venta, producto_id, cliente_id)
VALUES(2, "Efectivo", "2022-02-15", null, 1800.0, 8, 4),
(5, "Efectivo", "2022-10-15", null, 4500.0, 8, 4),
(4, "Credito", "2022-07-12", null, 2000.0, 9, 6);

#dos select basicos
SELECT marca, nombre
FROM Producto
WHERE precio_venta > 1100.0;

SELECT  direccion, rut, nombre
FROM Cliente
WHERE nombre like "%ll%";

#select con Join donde no devuelve dulces porque no se le asigno a un producto
SELECT nombre_categoria, nombre, precio_compra
FROM CategoriaProducto JOIN Producto ON CategoriaProducto.categoria_producto_id = Producto.categoria_producto_id;

#select con Join donde devuelve tambien dulces porque es parte de la tabla CategoriaProducto
SELECT nombre_categoria, nombre, precio_compra
FROM CategoriaProducto LEFT JOIN Producto ON CategoriaProducto.categoria_producto_id = Producto.categoria_producto_id;

#select para el informe anual de ganancias
#muestra la suma del total de las ventas anual menos la suma del precio de compra del producto por cuantos se vendieron de esos al anio
SELECT SUM(total_venta)-SUM(precio_compra*cantidad_vendido)
FROM Boleta JOIN Producto ON Boleta.producto_id = Producto.producto_id
WHERE fecha > "2022-01-01" and fecha < "2022-12-31";

#select para el informe anual de ventas de productos, muestra la cantidad total de productos vendidos al anio
SELECT sum(cantidad_vendido)
FROM Boleta 
WHERE fecha > "2022-01-01" and fecha < "2022-12-31";

#no entiendo porque el autoincrementable empezo desde 4 y 6 respectivamente
SELECT * FROM Producto;
SELECT * FROM Cliente;
SELECT * FROM Boleta;
