-- 1. Creación de tablas

CREATE TABLE vivero (
    id_vivero SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    latitud DECIMAL(9,6),
    longitud DECIMAL(9,6)
);

CREATE TABLE empleados (
    id_empleado SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    id_vivero INT,
    FOREIGN KEY (id_vivero) REFERENCES vivero(id_vivero) ON DELETE SET NULL
);

CREATE TABLE zona (
    id_zona SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    latitud DECIMAL(9,6),
    longitud DECIMAL(9,6),
    tarea VARCHAR(150),
    id_vivero INT NOT NULL,
    id_empleado INT,
    FOREIGN KEY (id_vivero) REFERENCES vivero(id_vivero) ON DELETE CASCADE,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) ON DELETE SET NULL
);

CREATE TABLE producto (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0)
);

CREATE TABLE cliente_tajinaste_plus (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_ingreso DATE DEFAULT CURRENT_DATE NOT NULL
);

CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    id_cliente INT NOT NULL,
    id_empleado INT,
    FOREIGN KEY (id_cliente) REFERENCES cliente_tajinaste_plus(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) ON DELETE SET NULL
);

CREATE TABLE stock (
    id_zona INT,
    id_producto INT,
    cantidad INT NOT NULL CHECK (cantidad >= 0),
    PRIMARY KEY (id_zona, id_producto),
    FOREIGN KEY (id_zona) REFERENCES zona(id_zona) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE
);

CREATE TABLE contiene (
    id_producto INT,
    id_pedido INT,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    PRIMARY KEY (id_producto, id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE
);

CREATE TABLE bonificaciones (
    id_bonificacion SERIAL PRIMARY KEY,
    mes_anyo VARCHAR(7) NOT NULL, -- Formato 'MM-YYYY'
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente_tajinaste_plus(id_cliente) ON DELETE CASCADE
);

-- 2. Introducción de datos

INSERT INTO vivero (nombre, latitud, longitud) VALUES 
('Vivero La Esperanza', 28.4500, -16.3333),
('Vivero Norte', 28.3833, -16.5167),
('Vivero Sur', 28.0500, -16.7167),
('Vivero Anaga', 28.5333, -16.2167),
('Vivero Teide', 28.2667, -16.6167);

INSERT INTO empleados (nombre, fecha_inicio, fecha_fin, id_vivero) VALUES 
('Ana García', '2023-01-15', NULL, 1),
('Carlos Pérez', '2022-05-10', '2024-01-01', 2),
('Elena Ruiz', '2023-11-01', NULL, 3),
('David López', '2021-03-20', NULL, 1),
('Sofía Martín', '2024-02-10', NULL, 4);

INSERT INTO zona (nombre, latitud, longitud, tarea, id_vivero, id_empleado) VALUES 
('Zona Invernadero A', 28.4501, -16.3334, 'Riego y control de temperatura', 1, 1),
('Zona Exterior Semillas', 28.3834, -16.5168, 'Plantación', 2, 2),
('Zona Árboles Frutales', 28.0501, -16.7168, 'Poda', 3, 3),
('Zona Cactus', 28.4502, -16.3335, 'Trasplante', 1, 4),
('Zona Fertilizantes', 28.5334, -16.2168, 'Gestión de inventario', 4, 5);

INSERT INTO producto (nombre, precio) VALUES 
('Rosal', 12.50),
('Abono Universal 5L', 8.99),
('Maceta de barro grande', 15.00),
('Semillas de tomate', 2.50),
('Cactus San Pedro', 25.00);

INSERT INTO cliente_tajinaste_plus (nombre, fecha_ingreso) VALUES 
('María Fernández', '2023-06-10'),
('Juan Rodríguez', '2023-08-22'),
('Laura Gómez', '2024-01-05'),
('Pedro Sánchez', '2022-11-15'),
('Carmen Díaz', '2024-03-12');

INSERT INTO pedidos (fecha, id_cliente, id_empleado) VALUES 
('2024-03-01', 1, 1),
('2024-03-05', 2, 3),
('2024-03-10', 3, 4),
('2024-03-15', 1, 1),
('2024-03-20', 4, 5);

INSERT INTO stock (id_zona, id_producto, cantidad) VALUES 
(1, 1, 50),
(2, 4, 200),
(4, 5, 30),
(5, 2, 100),
(1, 3, 45);

INSERT INTO contiene (id_pedido, id_producto, cantidad) VALUES 
(1, 1, 2),  -- Pedido 1 lleva 2 Rosales
(1, 2, 1),  -- Pedido 1 lleva 1 Abono
(2, 5, 1),  -- Pedido 2 lleva 1 Cactus
(3, 4, 10), -- Pedido 3 lleva 10 Semillas
(4, 3, 4),  -- Pedido 4 lleva 4 Macetas
(5, 1, 1);  -- Pedido 5 lleva 1 Rosal

INSERT INTO bonificaciones (mes_anyo, id_cliente) VALUES 
('03-2024', 1),
('03-2024', 2),
('03-2024', 3),
('02-2024', 4),
('03-2024', 5);
