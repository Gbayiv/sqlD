-- Tablas principales
CREATE TABLE Region (
    id_region NUMBER(4) PRIMARY KEY,
    nombre_region VARCHAR2(60) NOT NULL
);

CREATE TABLE Ciudad (
    id_ciudad NUMBER(4) PRIMARY KEY,
    nombre_ciudad VARCHAR2(60) NOT NULL,
    id_region NUMBER(4) NOT NULL,
    CONSTRAINT fk_ciudad_region FOREIGN KEY (id_region) REFERENCES Region(id_region)
);

CREATE TABLE Comuna (
    id_comuna NUMBER(4) PRIMARY KEY,
    nombre_comuna VARCHAR2(60) NOT NULL,
    id_ciudad NUMBER(4) NOT NULL,
    CONSTRAINT fk_comuna_ciudad FOREIGN KEY (id_ciudad) REFERENCES Ciudad(id_ciudad)
);

CREATE TABLE Cadena_Tiendas (
    id_cadena NUMBER(4) PRIMARY KEY,
    nombre_cadena VARCHAR2(100) NOT NULL,
    rut VARCHAR2(12) NOT NULL UNIQUE,
    razon_social VARCHAR2(100) NOT NULL,
    giro VARCHAR2(100) NOT NULL
);

CREATE TABLE Local (
    id_local NUMBER(4) PRIMARY KEY,
    nombre_local VARCHAR2(100) NOT NULL,
    es_matriz CHAR(1) NOT NULL CHECK (es_matriz IN ('S', 'N')),
    id_cadena NUMBER(4) NOT NULL,
    id_comuna NUMBER(4) NOT NULL,
    CONSTRAINT fk_local_cadena FOREIGN KEY (id_cadena) REFERENCES Cadena_Tiendas(id_cadena),
    CONSTRAINT fk_local_comuna FOREIGN KEY (id_comuna) REFERENCES Comuna(id_comuna)
);

-- Tabla para direcciones de locales (pueden tener múltiples direcciones)
CREATE TABLE Local_Direccion (
    id_direccion NUMBER(4) PRIMARY KEY,
    direccion VARCHAR2(200) NOT NULL,
    id_local NUMBER(4) NOT NULL,
    es_principal CHAR(1) DEFAULT 'S' CHECK (es_principal IN ('S', 'N')),
    CONSTRAINT fk_localdir_local FOREIGN KEY (id_local) REFERENCES Local(id_local)
);

CREATE TABLE Categoria_Producto (
    id_categoria NUMBER(4) PRIMARY KEY,
    nombre_categoria VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(200)
);

CREATE TABLE Producto (
    id_producto NUMBER(4) PRIMARY KEY,
    nombre_producto VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(200),
    precio_neto NUMBER(10) NOT NULL,
    id_categoria NUMBER(4) NOT NULL,
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria_Producto(id_categoria)
);

CREATE TABLE Local_Producto (
    id_local NUMBER(4) NOT NULL,
    id_producto NUMBER(4) NOT NULL,
    stock NUMBER(10) NOT NULL,
    PRIMARY KEY (id_local, id_producto),
    CONSTRAINT fk_localprod_local FOREIGN KEY (id_local) REFERENCES Local(id_local),
    CONSTRAINT fk_localprod_producto FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Trabajador (
    rut NUMBER(8) PRIMARY KEY,
    dv CHAR(1) NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    apaterno VARCHAR2(50) NOT NULL,
    amaterno VARCHAR2(50),
    sueldo_base NUMBER(10) NOT NULL,
    comision NUMBER(5,2),
    isapre NUMBER(5,2),
    fonasa NUMBER(5,2),
    afp NUMBER(5,2),
    inp NUMBER(5,2),
    id_local NUMBER(4) NOT NULL,
    CONSTRAINT fk_trabajador_local FOREIGN KEY (id_local) REFERENCES Local(id_local)
);

-- Tabla para teléfonos de trabajadores (campos multivaluados)
CREATE TABLE Trabajador_Telefono (
    id_telefono NUMBER(4) PRIMARY KEY,
    rut_trabajador NUMBER(8) NOT NULL,
    numero_telefono VARCHAR2(15) NOT NULL,
    tipo_telefono VARCHAR2(20),
    CONSTRAINT fk_trabtele_trabajador FOREIGN KEY (rut_trabajador) REFERENCES Trabajador(rut)
);

-- Tabla para direcciones de trabajadores (campos multivaluados)
CREATE TABLE Trabajador_Direccion (
    id_direccion NUMBER(4) PRIMARY KEY,
    rut_trabajador NUMBER(8) NOT NULL,
    direccion VARCHAR2(200) NOT NULL,
    tipo_direccion VARCHAR2(20),
    id_comuna NUMBER(4) NOT NULL,
    es_principal CHAR(1) DEFAULT 'S' CHECK (es_principal IN ('S', 'N')),
    CONSTRAINT fk_trabdir_trabajador FOREIGN KEY (rut_trabajador) REFERENCES Trabajador(rut),
    CONSTRAINT fk_trabdir_comuna FOREIGN KEY (id_comuna) REFERENCES Comuna(id_comuna)
);

CREATE TABLE Proveedor (
    id_proveedor NUMBER(4) PRIMARY KEY,
    rut VARCHAR2(12) NOT NULL UNIQUE,
    razon_social VARCHAR2(100) NOT NULL,
    giro VARCHAR2(100) NOT NULL
);

-- Tabla para direcciones de proveedores (campos multivaluados)
CREATE TABLE Proveedor_Direccion (
    id_direccion NUMBER(4) PRIMARY KEY,
    id_proveedor NUMBER(4) NOT NULL,
    direccion VARCHAR2(200) NOT NULL,
    id_comuna NUMBER(4) NOT NULL,
    es_principal CHAR(1) DEFAULT 'S' CHECK (es_principal IN ('S', 'N')),
    CONSTRAINT fk_provdir_proveedor FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor),
    CONSTRAINT fk_provdir_comuna FOREIGN KEY (id_comuna) REFERENCES Comuna(id_comuna)
);

-- Tabla para teléfonos de proveedores (campos multivaluados)
CREATE TABLE Proveedor_Telefono (
    id_telefono NUMBER(4) PRIMARY KEY,
    id_proveedor NUMBER(4) NOT NULL,
    numero_telefono VARCHAR2(15) NOT NULL,
    tipo_telefono VARCHAR2(20),
    CONSTRAINT fk_provtele_proveedor FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);

CREATE TABLE Proveedor_Producto (
    id_proveedor NUMBER(4) NOT NULL,
    id_producto NUMBER(4) NOT NULL,
    PRIMARY KEY (id_proveedor, id_producto),
    CONSTRAINT fk_provprod_proveedor FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor),
    CONSTRAINT fk_provprod_producto FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Tipo_Documento (
    id_tipo_documento NUMBER(2) PRIMARY KEY,
    descripcion VARCHAR2(20) NOT NULL
);

CREATE TABLE Documento (
    id_documento NUMBER(10) PRIMARY KEY,
    nro_correlativo NUMBER(10) NOT NULL,
    fecha_emision DATE NOT NULL,
    afecta_exenta CHAR(1) NOT NULL CHECK (afecta_exenta IN ('A', 'E')),
    neto NUMBER(10) NOT NULL,
    iva NUMBER(10) NOT NULL,
    total NUMBER(10) NOT NULL,
    id_tipo_documento NUMBER(2) NOT NULL,
    rut_cliente VARCHAR2(12),
    razon_social VARCHAR2(100),
    giro VARCHAR2(100),
    id_local NUMBER(4) NOT NULL,
    rut_vendedor NUMBER(8) NOT NULL,
    CONSTRAINT fk_documento_tipo FOREIGN KEY (id_tipo_documento) REFERENCES Tipo_Documento(id_tipo_documento),
    CONSTRAINT fk_documento_local FOREIGN KEY (id_local) REFERENCES Local(id_local),
    CONSTRAINT fk_documento_vendedor FOREIGN KEY (rut_vendedor) REFERENCES Trabajador(rut)
);

CREATE TABLE Detalle_Documento (
    id_detalle NUMBER(10) PRIMARY KEY,
    id_documento NUMBER(10) NOT NULL,
    id_producto NUMBER(4) NOT NULL,
    cantidad NUMBER(5) NOT NULL,
    valor_neto NUMBER(10) NOT NULL,
    CONSTRAINT fk_detdoc_documento FOREIGN KEY (id_documento) REFERENCES Documento(id_documento),
    CONSTRAINT fk_detdoc_producto FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- Secuencias para IDs autoincrementales
CREATE SEQUENCE seq_region START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ciudad START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_comuna START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_cadena START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_local START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_localdir START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_categoria START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_producto START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_proveedor START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_provdir START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_provtele START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_trabajador_telefono START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_trabajador_direccion START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tipo_documento START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_documento START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_detalle_doc START WITH 1 INCREMENT BY 1;

-- Insertar regiones
INSERT INTO Region VALUES (seq_region.NEXTVAL, 'Región Metropolitana');
INSERT INTO Region VALUES (seq_region.NEXTVAL, 'Valparaíso');
INSERT INTO Region VALUES (seq_region.NEXTVAL, 'Biobío');

-- Insertar ciudades
INSERT INTO Ciudad VALUES (seq_ciudad.NEXTVAL, 'Santiago', 1);
INSERT INTO Ciudad VALUES (seq_ciudad.NEXTVAL, 'Valparaíso', 2);
INSERT INTO Ciudad VALUES (seq_ciudad.NEXTVAL, 'Concepción', 3);

-- Insertar comunas
INSERT INTO Comuna VALUES (seq_comuna.NEXTVAL, 'Santiago Centro', 1);
INSERT INTO Comuna VALUES (seq_comuna.NEXTVAL, 'Providencia', 1);
INSERT INTO Comuna VALUES (seq_comuna.NEXTVAL, 'Viña del Mar', 2);

-- Insertar cadenas de tiendas
INSERT INTO Cadena_Tiendas VALUES (seq_cadena.NEXTVAL, 'SuperMart', '12345678-9', 'SuperMart S.A.', 'Supermercado');
INSERT INTO Cadena_Tiendas VALUES (seq_cadena.NEXTVAL, 'TecnoShop', '98765432-1', 'TecnoShop Ltda.', 'Electrónica');
INSERT INTO Cadena_Tiendas VALUES (seq_cadena.NEXTVAL, 'ModaTotal', '45678912-3', 'ModaTotal SpA', 'Vestuario');

-- Insertar locales
INSERT INTO Local VALUES (seq_local.NEXTVAL, 'SuperMart Centro', 'S', 1, 1);
INSERT INTO Local VALUES (seq_local.NEXTVAL, 'SuperMart Providencia', 'N', 1, 2);
INSERT INTO Local VALUES (seq_local.NEXTVAL, 'TecnoShop Viña', 'S', 2, 3);

-- Insertar direcciones de locales
INSERT INTO Local_Direccion VALUES (seq_localdir.NEXTVAL, 'Av. Libertador Bernardo O''Higgins 123', 1, 'S');
INSERT INTO Local_Direccion VALUES (seq_localdir.NEXTVAL, 'Av. Providencia 456', 2, 'S');
INSERT INTO Local_Direccion VALUES (seq_localdir.NEXTVAL, 'Av. San Martín 789', 3, 'S');

-- Insertar categorías de productos
INSERT INTO Categoria_Producto VALUES (seq_categoria.NEXTVAL, 'Alimentos', 'Productos alimenticios');
INSERT INTO Categoria_Producto VALUES (seq_categoria.NEXTVAL, 'Electrónica', 'Dispositivos electrónicos');
INSERT INTO Categoria_Producto VALUES (seq_categoria.NEXTVAL, 'Ropa', 'Vestuario y accesorios');

-- Insertar productos
INSERT INTO Producto VALUES (seq_producto.NEXTVAL, 'Arroz 1kg', 'Arroz grano largo', 1200, 1);
INSERT INTO Producto VALUES (seq_producto.NEXTVAL, 'Smartphone X', 'Teléfono inteligente', 450000, 2);
INSERT INTO Producto VALUES (seq_producto.NEXTVAL, 'Jeans Clásico', 'Jeans azul', 25000, 3);

-- Insertar relación local-producto
INSERT INTO Local_Producto VALUES (1, 1, 100);
INSERT INTO Local_Producto VALUES (1, 2, 20);
INSERT INTO Local_Producto VALUES (2, 1, 80);
INSERT INTO Local_Producto VALUES (3, 2, 15);
INSERT INTO Local_Producto VALUES (3, 3, 30);

-- Insertar trabajadores
INSERT INTO Trabajador VALUES (12345678, '9', 'Juan', 'Pérez', 'González', 500000, 5, 7, NULL, 10, 2, 1);
INSERT INTO Trabajador VALUES (23456789, '1', 'María', 'López', 'Martínez', 550000, 4, NULL, 7, 12, 1, 2);
INSERT INTO Trabajador VALUES (34567890, '2', 'Carlos', 'García', NULL, 600000, 6, 5, NULL, 11, 3, 3);

-- Insertar teléfonos de trabajadores (campos multivaluados)
INSERT INTO Trabajador_Telefono VALUES (seq_trabajador_telefono.NEXTVAL, 12345678, '911223344', 'Celular');
INSERT INTO Trabajador_Telefono VALUES (seq_trabajador_telefono.NEXTVAL, 12345678, '222334455', 'Casa');
INSERT INTO Trabajador_Telefono VALUES (seq_trabajador_telefono.NEXTVAL, 23456789, '933445566', 'Celular');

-- Insertar direcciones de trabajadores (campos multivaluados)
INSERT INTO Trabajador_Direccion VALUES (seq_trabajador_direccion.NEXTVAL, 12345678, 'Calle Principal 123', 'Casa', 1, 'S');
INSERT INTO Trabajador_Direccion VALUES (seq_trabajador_direccion.NEXTVAL, 12345678, 'Calle Secundaria 456', 'Trabajo', 1, 'N');
INSERT INTO Trabajador_Direccion VALUES (seq_trabajador_direccion.NEXTVAL, 23456789, 'Av. Siempre Viva 789', 'Casa', 2, 'S');

-- Insertar proveedores
INSERT INTO Proveedor VALUES (seq_proveedor.NEXTVAL, '11111111-1', 'Distribuidora Alimentos S.A.', 'Distribución alimentos');
INSERT INTO Proveedor VALUES (seq_proveedor.NEXTVAL, '22222222-2', 'TecnoImport Ltda.', 'Importación electrónica');
INSERT INTO Proveedor VALUES (seq_proveedor.NEXTVAL, '33333333-3', 'Textiles del Sur SpA', 'Fabricación textiles');

-- Insertar direcciones de proveedores (campos multivaluados)
INSERT INTO Proveedor_Direccion VALUES (seq_provdir.NEXTVAL, 1, 'Av. Industrial 123', 1, 'S');
INSERT INTO Proveedor_Direccion VALUES (seq_provdir.NEXTVAL, 2, 'Calle Tecnológica 456', 1, 'S');
INSERT INTO Proveedor_Direccion VALUES (seq_provdir.NEXTVAL, 3, 'Ruta Textil 789', 3, 'S');

-- Insertar teléfonos de proveedores (campos multivaluados)
INSERT INTO Proveedor_Telefono VALUES (seq_provtele.NEXTVAL, 1, '800100200', 'Oficina');
INSERT INTO Proveedor_Telefono VALUES (seq_provtele.NEXTVAL, 1, '900200300', 'Ventas');
INSERT INTO Proveedor_Telefono VALUES (seq_provtele.NEXTVAL, 2, '800300400', 'Oficina');

-- Insertar relación proveedor-producto
INSERT INTO Proveedor_Producto VALUES (1, 1);
INSERT INTO Proveedor_Producto VALUES (2, 2);
INSERT INTO Proveedor_Producto VALUES (3, 3);

-- Insertar tipos de documento
INSERT INTO Tipo_Documento VALUES (seq_tipo_documento.NEXTVAL, 'Boleta');
INSERT INTO Tipo_Documento VALUES (seq_tipo_documento.NEXTVAL, 'Factura');
INSERT INTO Tipo_Documento VALUES (seq_tipo_documento.NEXTVAL, 'Guía Despacho');

-- Insertar documentos
INSERT INTO Documento VALUES (seq_documento.NEXTVAL, 1001, SYSDATE, 'A', 1200, 228, 1428, 1, '44444444-4', 'Cliente Uno', 'Particular', 1, 12345678);
INSERT INTO Documento VALUES (seq_documento.NEXTVAL, 2001, SYSDATE, 'A', 450000, 85500, 535500, 2, '55555555-5', 'Empresa Dos', 'Comercio', 3, 34567890);
INSERT INTO Documento VALUES (seq_documento.NEXTVAL, 1002, SYSDATE, 'E', 25000, 0, 25000, 1, '66666666-6', 'Cliente Tres', 'Particular', 3, 34567890);

-- Insertar detalles de documento
INSERT INTO Detalle_Documento VALUES (seq_detalle_doc.NEXTVAL, 1, 1, 1, 1200);
INSERT INTO Detalle_Documento VALUES (seq_detalle_doc.NEXTVAL, 2, 2, 1, 450000);
INSERT INTO Detalle_Documento VALUES (seq_detalle_doc.NEXTVAL, 3, 3, 1, 25000);

COMMIT;


--Mostrar locales por comuna y ciudad:

SELECT c.nombre_comuna, ci.nombre_ciudad, l.nombre_local, 
       ct.nombre_cadena,
       CASE WHEN l.es_matriz = 'S' THEN 'Casa Matriz' ELSE 'Sucursal' END AS tipo_local
FROM Local l
JOIN Comuna c ON l.id_comuna = c.id_comuna
JOIN Ciudad ci ON c.id_ciudad = ci.id_ciudad
JOIN Cadena_Tiendas ct ON l.id_cadena = ct.id_cadena
ORDER BY ci.nombre_ciudad, c.nombre_comuna;

--Mostrar productos por categoría:

SELECT cp.nombre_categoria, p.nombre_producto, l.nombre_local, ct.nombre_cadena
FROM Producto p
JOIN Categoria_Producto cp ON p.id_categoria = cp.id_categoria
JOIN Local_Producto lp ON p.id_producto = lp.id_producto
JOIN Local l ON lp.id_local = l.id_local
JOIN Cadena_Tiendas ct ON l.id_cadena = ct.id_cadena
ORDER BY cp.nombre_categoria, p.nombre_producto;


--Mostrar trabajadores por región:

SELECT r.nombre_region, t.nombre || ' ' || t.apaterno || ' ' || NVL(t.amaterno, '') AS nombre_completo, 
       l.nombre_local, ct.nombre_cadena
FROM Trabajador t
JOIN Local l ON t.id_local = l.id_local
JOIN Comuna c ON l.id_comuna = c.id_comuna
JOIN Ciudad ci ON c.id_ciudad = ci.id_ciudad
JOIN Region r ON ci.id_region = r.id_region
JOIN Cadena_Tiendas ct ON l.id_cadena = ct.id_cadena
ORDER BY r.nombre_region, t.apaterno, t.amaterno;


--Proveedores por sucursal y categoría:

SELECT l.nombre_local, cp.nombre_categoria, p.nombre_producto, 
       pr.razon_social AS proveedor, pd.direccion AS direccion_proveedor
FROM Local l
JOIN Local_Producto lp ON l.id_local = lp.id_local
JOIN Producto p ON lp.id_producto = p.id_producto
JOIN Categoria_Producto cp ON p.id_categoria = cp.id_categoria
JOIN Proveedor_Producto pp ON p.id_producto = pp.id_producto
JOIN Proveedor pr ON pp.id_proveedor = pr.id_proveedor
JOIN Proveedor_Direccion pd ON pr.id_proveedor = pd.id_proveedor AND pd.es_principal = 'S'
WHERE l.es_matriz = 'N'
ORDER BY l.nombre_local, cp.nombre_categoria;


--Listado de trabajadores con detalles de sueldo:

SELECT l.nombre_local, 
       t.nombre || ' ' || t.apaterno || ' ' || NVL(t.amaterno, '') AS nombre_completo,
       t.sueldo_base, 
       t.comision || '%' AS comision,
       (COALESCE(t.isapre, 0) + COALESCE(t.fonasa, 0)) || '%' AS prevision_salud,
       (COALESCE(t.afp, 0) + COALESCE(t.inp, 0)) || '%' AS prevision_pension
FROM Trabajador t
JOIN Local l ON t.id_local = l.id_local
ORDER BY l.nombre_local, t.apaterno, t.amaterno;

--Boletas y facturas de un día específico:

SELECT 
    d.id_documento,
    td.descripcion AS tipo_documento, 
    d.nro_correlativo, 
    TO_CHAR(d.fecha_emision, 'DD/MM/YYYY HH24:MI') AS fecha_emision,
    t.nombre || ' ' || t.apaterno AS vendedor,
    d.neto, 
    d.iva, 
    d.total,
    CASE d.afecta_exenta WHEN 'A' THEN 'Afecta' ELSE 'Exenta' END AS tipo_impuesto
FROM Documento d
JOIN Tipo_Documento td ON d.id_tipo_documento = td.id_tipo_documento
JOIN Trabajador t ON d.rut_vendedor = t.rut
WHERE TRUNC(d.fecha_emision) = TRUNC(SYSDATE)
ORDER BY td.descripcion, d.nro_correlativo;

--Detalle de factura/boleta:

SELECT 
    d.id_documento,
    td.descripcion AS tipo_documento, 
    d.nro_correlativo,
    TO_CHAR(d.fecha_emision, 'DD/MM/YYYY') AS fecha,
    p.nombre_producto,
    dd.cantidad,
    dd.valor_neto AS precio_unitario,
    (dd.cantidad * dd.valor_neto) AS subtotal_neto,
    CASE 
        WHEN d.afecta_exenta = 'A' THEN ROUND((dd.cantidad * dd.valor_neto) * 0.19)
        ELSE 0 
    END AS iva,
    CASE 
        WHEN d.afecta_exenta = 'A' THEN (dd.cantidad * dd.valor_neto) + ROUND((dd.cantidad * dd.valor_neto) * 0.19)
        ELSE (dd.cantidad * dd.valor_neto)
    END AS subtotal_total
FROM Documento d
JOIN Tipo_Documento td ON d.id_tipo_documento = td.id_tipo_documento
JOIN Detalle_Documento dd ON d.id_documento = dd.id_documento
JOIN Producto p ON dd.id_producto = p.id_producto
WHERE d.id_documento = :id_documento_parametro;

--listo 