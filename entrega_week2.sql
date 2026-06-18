-- ====================================================================================================
-- ENTREGA WEEK 2 — TECHSTORE INVENTARIO
-- Nombre: Jose Araujo | Fecha: 12/JUN/2026
-- ====================================================================================================



-- ====================================================================================================
-- PARTE 1: DDL
-- ====================================================================================================
DROP DATABASE IF EXISTS techstore_inventario;
CREATE DATABASE techstore_inventario;
USE techstore_inventario;

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
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);

CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



-- ====================================================================================================
-- PARTE 2: DML inicial
-- ====================================================================================================
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

SELECT * FROM productos;

-- ====================================================================================================
-- PARTE 3: UPDATE de Fase 3 (aumento precios, reducción stock, marca inactivos)
-- ====================================================================================================
-- Aumento precios
START TRANSACTION;
    -- PASO 1: VERIFICAR
    SELECT
        nombre,
        precio,
        ROUND(precio * 1.10, 2) AS nuevo_precio
    FROM productos
    WHERE categoria = 'Audio';

    -- PASO 2: EJECUTAR
    UPDATE productos
    SET precio = ROUND(precio * 1.10, 2)
    WHERE categoria = 'Audio';
    -- Output esperado: "Query OK, 5 rows affected"

    -- PASO 3: CONFIRMAR
    SELECT
        nombre,
        precio
    FROM productos
    WHERE categoria = 'Audio';
COMMIT;

-- Reducción stock
START TRANSACTION;
    -- PASO 1: VERIFICAR
    SELECT stock FROM productos WHERE id = 1 AND stock >= 2;
    SELECT stock FROM productos WHERE id = 5 AND stock >= 5;
    SELECT stock FROM productos WHERE id = 6 AND stock >= 3;
    SELECT stock FROM productos WHERE id = 11 AND stock >= 1;
    SELECT stock FROM productos WHERE id = 16 AND stock >= 4;

    -- PASO 2: EJECUTAR
    UPDATE productos SET stock = stock - 2 WHERE id = 1;
    UPDATE productos SET stock = stock - 5 WHERE id = 5;
    UPDATE productos SET stock = stock - 3 WHERE id = 6;
    UPDATE productos SET stock = stock - 1 WHERE id = 11;
    UPDATE productos SET stock = stock - 4 WHERE id = 16;

    -- PASO 3: CONFIRMAR
    SELECT
        id,
        nombre,
        stock
    FROM productos
    WHERE id IN (1, 5, 6, 11, 16);
COMMIT;

-- Marca inactivos
START TRANSACTION;
    -- PASO 1: VERIFICAR
    SELECT
        nombre,
        stock,
        stock_minimo
    FROM productos
    WHERE stock < stock_minimo;

    -- PASO 2: EJECUTAR
    UPDATE productos
    SET activo = FALSE
    WHERE stock < stock_minimo;

    -- PASO 3: CONFIRMAR
    SELECT
        nombre,
        stock,
        stock_minimo,
        activo
    FROM productos
    WHERE activo = FALSE;
COMMIT;



-- ====================================================================================================
-- PARTE 4: Soft delete + hard delete
-- ====================================================================================================
-- Soft delete del Lenovo ThinkPad
UPDATE productos
SET deleted_at = CURRENT_TIMESTAMP
WHERE codigo_producto = 'LAP004';

-- Hard delete de ventas viejas (antes de 2023)
-- VERIFICAR
SELECT * FROM ventas WHERE fecha_venta < '2023-01-01';
-- EJECUTAR
DELETE FROM ventas WHERE fecha_venta < '2023-01-01';
-- CONFIRMAR
SELECT COUNT(*) FROM ventas;



-- ====================================================================================================
-- PARTE 5: Transacción de venta completa
-- ====================================================================================================
START TRANSACTION;
    -- 1. Verificar stock suficiente
    SELECT stock FROM productos WHERE id = 9 AND stock >= 1;

    -- 2. Registrar venta
    INSERT INTO ventas (producto_id, cantidad, precio_venta, total)
    VALUES (9, 3, 24.99, 74.97);

    -- 3. Reducir stock
    UPDATE productos SET stock = stock - 2 WHERE id = 9;

    -- 4.1. Confirmar cambios
    SELECT
        id,
        producto_id,
        cantidad,
        precio_venta,
        total
    FROM ventas
    WHERE id = LAST_INSERT_ID();

    -- 4.2. Verificar stock actualizado
    SELECT
        id,
        nombre,
        stock
    FROM productos
    WHERE id = 9;
COMMIT;
-- ROLLBACK


-- ====================================================================================================
-- PARTE 6 (BONUS): los 3 reportes siguientes
-- ====================================================================================================
-- Reporte 1 — Productos en alerta de stock bajo (con prioridad)
SELECT
    codigo_producto,
    nombre,
    categoria,
    stock,
    stock_minimo,
    (stock_minimo - stock) AS faltante
FROM productos
WHERE stock < stock_minimo
AND deleted_at IS NULL;

-- Reporte 2 — Margen de ganancia top 10
-- "Dame los 10 productos con mayor margen absoluto (precio - costo),
-- incluyendo el margen porcentual. Solo activos."
SELECT
    codigo_producto,
    nombre,
    categoria,
    precio,
    costo,
    (precio - costo) AS margen_absoluto,
    ROUND(((precio - costo) / costo) * 100, 2) AS margen_porcentual
FROM productos
WHERE activo = TRUE
AND deleted_at IS NULL
ORDER BY margen_absoluto DESC
LIMIT 10;

-- Reporte 3 — Revenue por categoría
-- "Cuánto vendió cada categoría en total: número de ventas, unidades, revenue."
SELECT
    p.categoria,
    COUNT(v.id) AS total_ventas,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.total) AS valor_total_venta
FROM ventas v
JOIN productos p ON v.producto_id = p.id
WHERE p.deleted_at IS NULL
GROUP BY p.categoria
ORDER BY valor_total_venta DESC;