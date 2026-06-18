DROP DATABASE IF EXISTS techstore_inventario;
CREATE DATABASE techstore_inventario;
USE techstore_inventario;

-- Validamos que estamos usando la base de datos correcta
SELECT DATABASE();

-- Fase 1 — Las dos tablas del sistema
-- Creamos la tabla de productos
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_producto VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    categoria VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    costo DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    stock_minimo INT DEFAULT 5,
    proveedor VARCHAR(100),
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Creamos la tabla de ventas
CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Verificamos tablas
SHOW TABLES;
DESCRIBE productos;
DESCRIBE ventas;

-- Fase 2 — Cargar el catálogo y las primeras ventas
-- Insertamos productos
INSERT INTO productos
    (codigo_producto, nombre, descripcion, categoria, precio, costo, stock, stock_minimo, proveedor, activo)
VALUES
    -- Laptops
    ('LAP001', 'Laptop HP Pavilion 15', 'Laptop Intel i5, 8GB RAM, 256GB SSD', 'Laptops', 799.99, 650.00, 12, 5, 'HP Inc', TRUE),
    ('LAP002', 'MacBook Air M2', 'Apple MacBook Air con chip M2, 8GB, 256GB', 'Laptops', 1299.99, 1050.00, 8, 3, 'Apple', TRUE),
    ('LAP003', 'Dell XPS 13', 'Ultrabook Dell XPS 13, i7, 16GB, 512GB SSD', 'Laptops', 1499.99, 1200.00, 5, 3, 'Dell', TRUE),
    ('LAP004', 'Lenovo ThinkPad', NULL, 'Laptops', 899.99, 720.00, 0, 5, 'Lenovo', FALSE),

    -- Periféricos
    ('PER001', 'Mouse Logitech MX Master 3', 'Mouse ergonómico inalámbrico', 'Perifericos', 99.99, 65.00, 35, 10, 'Logitech', TRUE),
    ('PER002', 'Teclado Mecánico Keychron K2', 'Teclado mecánico RGB, switches Gateron Brown', 'Perifericos', 89.99, 55.00, 20, 8, 'Keychron', TRUE),
    ('PER003', 'Webcam Logitech C920', 'Webcam Full HD 1080p', 'Perifericos', 79.99, 50.00, 15, 10, 'Logitech', TRUE),
    ('PER004', 'Hub USB-C 7 puertos', NULL, 'Perifericos', 45.99, 25.00, 50, 15, 'Anker', TRUE),
    ('PER005', 'Mouse Pad XL', 'Mouse pad gaming 90x40cm', 'Perifericos', 24.99, 10.00, 80, 20, 'SteelSeries', TRUE),
    ('PER006', 'Soporte Laptop Ajustable', 'Soporte ergonómico aluminio', 'Perifericos', 39.99, 20.00, 25, 10, 'Rain Design', TRUE),

    -- Audio
    ('AUD001', 'Audífonos Sony WH-1000XM5', 'Audífonos con cancelación de ruido', 'Audio', 399.99, 280.00, 10, 5, 'Sony', TRUE),
    ('AUD002', 'Audífonos Gaming HyperX', NULL, 'Audio', 79.99, 45.00, 30, 10, 'HyperX', TRUE),
    ('AUD003', 'Micrófono Blue Yeti', 'Micrófono USB profesional', 'Audio', 129.99, 85.00, 12, 6, 'Logitech', TRUE),
    ('AUD004', 'Parlantes Logitech Z623', 'Sistema 2.1, 200W', 'Audio', 149.99, 95.00, 8, 5, 'Logitech', TRUE),
    ('AUD005', 'Audífonos Bluetooth JBL', 'Audífonos inalámbricos portátiles', 'Audio', 49.99, 25.00, 2, 10, 'JBL', TRUE),

    -- Componentes
    ('COM001', 'SSD Samsung 1TB', 'SSD NVMe M.2 1TB', 'Componentes', 89.99, 60.00, 40, 15, 'Samsung', TRUE),
    ('COM002', 'RAM Corsair 16GB DDR4', '16GB (2x8GB) DDR4 3200MHz', 'Componentes', 79.99, 50.00, 25, 10, 'Corsair', TRUE),
    ('COM003', 'Monitor LG 27" 4K', 'Monitor IPS 27 pulgadas 4K', 'Componentes', 449.99, 320.00, 7, 5, 'LG', TRUE),
    ('COM004', 'Cable HDMI 2.1 - 2m', NULL, 'Componentes', 19.99, 8.00, 100, 30, 'Cable Matters', TRUE),
    ('COM005', 'Adaptador USB-C a HDMI', 'Adaptador 4K 60Hz', 'Componentes', 29.99, 15.00, 60, 20, 'Anker', TRUE);

--  Insertar 5 ventas iniciales
INSERT INTO ventas (producto_id, cantidad, precio_venta, total) VALUES
    (1,  2,  799.99, 1599.98),
    (5,  5,   99.99,  499.95),
    (6,  3,   89.99,  269.97),
    (11, 1,  399.99,  399.99),
    (16, 4,   89.99,  359.96);

-- Verificamos los datos insertados
SELECT COUNT(*) FROM productos;
SELECT COUNT(*) FROM ventas;
SELECT categoria, COUNT(*) FROM productos GROUP BY categoria;

-- Fase 3 — UPDATE: el verbo más peligroso
-- Aumentamos precios de Audio en 10%
-- Paso 1: VERIFICAR (¿qué filas vas a tocar?)
SELECT nombre, precio, ROUND(precio * 1.10, 2) AS nuevo_precio
FROM productos
WHERE categoria = 'Audio';
-- Debes ver 5 filas, todas de Audio. Si ves 0 o 20, ALGO ESTÁ MAL.

-- Paso 2: EJECUTAR
UPDATE productos
SET precio = precio * 1.10
WHERE categoria = 'Audio';
-- Output esperado: "Query OK, 5 rows affected"

-- Paso 3: CONFIRMAR
SELECT nombre, precio
FROM productos
WHERE categoria = 'Audio';

--  Reducir stock por las ventas hechas en Fase 2
START TRANSACTION;
    UPDATE productos SET stock = stock - 2 WHERE id = 1;   -- venta 1
    UPDATE productos SET stock = stock - 5 WHERE id = 5;   -- venta 2
    UPDATE productos SET stock = stock - 3 WHERE id = 6;   -- venta 3
    UPDATE productos SET stock = stock - 1 WHERE id = 11;  -- venta 4
    UPDATE productos SET stock = stock - 4 WHERE id = 16;  -- venta 5

    -- Verificar antes de commit
    SELECT id, nombre, stock FROM productos WHERE id IN (1, 5, 6, 11, 16);
COMMIT;

-- Marcar como inactivos los productos con stock bajo
-- VERIFICAR
SELECT nombre, stock, stock_minimo
FROM productos
WHERE stock < stock_minimo;

-- EJECUTAR
UPDATE productos
SET activo = FALSE
WHERE stock < stock_minimo;

-- CONFIRMAR
SELECT nombre, stock, stock_minimo, activo
FROM productos
WHERE activo = FALSE;

-- Checkpoint Fase 3
SELECT nombre, fecha_creacion, fecha_actualizacion FROM productos WHERE id IN (1, 5);

-- Fase 4 — DELETE: soft vs hard (15 min)
-- Soft delete del Lenovo ThinkPad
-- 1. Agregar columna soft delete (DDL, no DML)
ALTER TABLE productos ADD COLUMN deleted_at TIMESTAMP NULL;

-- 2. "Eliminar" Lenovo ThinkPad
UPDATE productos
SET deleted_at = CURRENT_TIMESTAMP
WHERE codigo_producto = 'LAP004';

-- 3. Consulta normal: incluir solo activos
SELECT id, nombre FROM productos WHERE deleted_at IS NULL;

-- 4. Auditoría: ver los "borrados"
SELECT id, nombre, deleted_at FROM productos WHERE deleted_at IS NOT NULL;

-- Hard delete: ventas viejas
-- VERIFICAR (en este ejercicio probablemente no hay ninguna que cumpla)
SELECT * FROM ventas WHERE fecha_venta < '2023-01-01';

-- EJECUTAR
DELETE FROM ventas WHERE fecha_venta < '2023-01-01';

-- CONFIRMAR
SELECT COUNT(*) FROM ventas;  -- sigue 5 (porque ninguna venta era de antes de 2023)

-- Fase 5 — Una venta atómica de verdad (15 min)
START TRANSACTION;

    -- Paso 1: ¿hay stock suficiente?
    SELECT id, nombre, stock, precio
    FROM productos
    WHERE id = 9 AND stock >= 3 AND deleted_at IS NULL;
    -- Si esta query devuelve 0 filas → no hay stock o el producto fue eliminado → ROLLBACK
    -- Si devuelve 1 fila → continuar

    -- Paso 2: reducir stock
    UPDATE productos
    SET stock = stock - 3
    WHERE id = 9;

    -- Paso 3: capturar el precio actual (puede haber cambiado vs lo que el cliente vio)
    SELECT @precio_actual := precio FROM productos WHERE id = 9;

    -- Paso 4: registrar la venta con el precio capturado
    INSERT INTO ventas (producto_id, cantidad, precio_venta, total)
    VALUES (9, 3, @precio_actual, @precio_actual * 3);

    -- Paso 5: verificar que ambos cambios pasaron
    SELECT id, nombre, stock FROM productos WHERE id = 9;
    SELECT * FROM ventas WHERE id = LAST_INSERT_ID();

COMMIT;

-- Si algo se ve mal (ejemplo: stock quedó negativo, total no cuadra):
-- ROLLBACK;

