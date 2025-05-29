-- Tablas principales
CREATE TABLE Region (
    id_region NUMBER(4) PRIMARY KEY,
    nombre_region VARCHAR2(60) NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE,
    usuario_creacion VARCHAR2(50),
    fecha_actualizacion DATE,
    usuario_actualizacion VARCHAR2(50)
);

CREATE TABLE Ciudad (
    id_ciudad NUMBER(4) PRIMARY KEY,
    nombre_ciudad VARCHAR2(60) NOT NULL,
    id_region NUMBER(4) NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE,
    usuario_creacion VARCHAR2(50),
    fecha_actualizacion DATE,
    usuario_actualizacion VARCHAR2(50),
    CONSTRAINT fk_ciudad_region FOREIGN KEY (id_region) REFERENCES Region(id_region)
);

CREATE TABLE Comuna (
    id_comuna NUMBER(4) PRIMARY KEY,
    nombre_comuna VARCHAR2(60) NOT NULL,
    id_ciudad NUMBER(4) NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE,
    usuario_creacion VARCHAR2(50),
    fecha_actualizacion DATE,
    usuario_actualizacion VARCHAR2(50),
    CONSTRAINT fk_comuna_ciudad FOREIGN KEY (id_ciudad) REFERENCES Ciudad(id_ciudad)
);

CREATE TABLE Cadena_Tiendas (
    id_cadena NUMBER(4) PRIMARY KEY,
    nombre_cadena VARCHAR2(100) NOT NULL,
    rut VARCHAR2(10) NOT NULL UNIQUE,
    razon_social VARCHAR2(100) NOT NULL,
    giro VARCHAR2(100) NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE,
    usuario_creacion VARCHAR2(50),
    fecha_actualizacion DATE,
    usuario_actualizacion VARCHAR2(50)
);

CREATE TABLE Local (
    id_local NUMBER(4) PRIMARY KEY,
    nombre_local VARCHAR2(100) NOT NULL,
    es_matriz CHAR(1) NOT NULL CHECK (es_matriz IN ('S', 'N')),
    id_cadena NUMBER(4) NOT NULL,
    id_comuna NUMBER(4) NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE,
    usuario_creacion VARCHAR2(50),
    fecha_actualizacion DATE,
    usuario_actualizacion VARCHAR2(50),
    CONSTRAINT fk_local_cadena FOREIGN KEY (id_cadena) REFERENCES Cadena_Tiendas(id_cadena),
    CONSTRAINT fk_local_comuna FOREIGN KEY (id_comuna) REFERENCES Comuna(id_comuna)
);

-- Tabla para direcciones de locales (pueden tener múltiples direcciones)
CREATE TABLE Local_Direccion (
    id_direccion NUMBER(4) PRIMARY KEY,
    direccion VARCHAR2(200) NOT NULL,
    id_local NUMBER(4) NOT NULL,
    es_principal CHAR(1) DEFAULT 'S' CHECK (es_principal IN ('S', 'N')),
    fecha_creacion DATE DEFAULT SYSDATE,
    usuario_creacion VARCHAR2(50),
    CONSTRAINT fk_localdir_local FOREIGN KEY (id_local) REFERENCES Local(id_local)
);

-- Tablas para tipos de teléfono y dirección
CREATE TABLE Tipo_Telefono (
    id_tipo_telefono NUMBER(2) PRIMARY KEY,
    descripcion VARCHAR2(30) NOT NULL
);

CREATE TABLE Tipo_Direccion (
    id_tipo_direccion NUMBER(2) PRIMARY KEY,
    descripcion VARCHAR2(30) NOT NULL
);

CREATE TABLE Categoria_Producto (
    id_categoria NUMBER(4) PRIMARY KEY,
    nombre_categoria VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(200),
    fecha_creacion DATE DEFAULT SYSDATE,
    usuario_creacion VARCHAR2(50),
    fecha_actualizacion DATE,
    usuario_actualizacion VARCHAR2(50)
);

CREATE TABLE Producto (
    id_producto NUMBER(4) PRIMARY KEY,
    nombre_producto VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(200),
    precio_neto NUMBER(10,2) NOT NULL,
    id_categoria NUMBER(4) NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE,
    usuario_creacion VARCHAR2(50),
    fecha_actualizacion DATE,
    usuario_actualizacion VARCHAR2(50),
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria_Producto(id_categoria)
);

CREATE TABLE Local_Producto (
    id_local NUMBER(4) NOT NULL,
    id_producto NUMBER(4) NOT NULL,
    stock NUMBER(10) NOT NULL,
    fecha_actualizacion DATE DEFAULT SYSDATE,
    usuario_actualizacion VARCHAR2(50),
    PRIMARY KEY (id_local, id_producto),
    CONSTRAINT fk_localprod_local FOREIGN KEY (id_local) REFERENCES Local(id_local),
    CONSTRAINT fk_localprod_producto FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Trabajador (
    rut VARCHAR2(10) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    apaterno VARCHAR2(50) NOT NULL,
    amaterno VARCHAR2(50),
    sueldo_base NUMBER(10,2) NOT NULL,
    comision NUMBER(5,2),
    isapre NUMBER(5,2),
    fonasa NUMBER(5,2),
    afp NUMBER(5,2),
    inp NUMBER(5,2),
    id_local NUMBER(4) NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE NOT NULL,
    usuario_creacion VARCHAR2(50) NOT NULL,
    fecha_actualizacion DATE,
    usuario_actualizacion VARCHAR2(50),
    CONSTRAINT fk_trabajador_local FOREIGN KEY (id_local) REFERENCES Local(id_local),
    CONSTRAINT ck_trabajador_rut CHECK (REGEXP_LIKE(rut, '^[0-9]{7,8}-[0-9Kk]$'))
);

-- Tabla para teléfonos de trabajadores (campos multivaluados)
CREATE TABLE Trabajador_Telefono (
    id_telefono NUMBER(4) PRIMARY KEY,
    rut_trabajador VARCHAR2(10) NOT NULL,
    numero_telefono VARCHAR2(15) NOT NULL,
    id_tipo_telefono NUMBER(2) NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE,
    CONSTRAINT fk_trabtele_trabajador FOREIGN KEY (rut_trabajador) REFERENCES Trabajador(rut),
    CONSTRAINT fk_trabtele_tipo FOREIGN KEY (id_tipo_telefono) REFERENCES Tipo_Telefono(id_tipo_telefono)
);

-- Tabla para direcciones de trabajadores (campos multivaluados)
CREATE TABLE Trabajador_Direccion (
    id_direccion NUMBER(4) PRIMARY KEY,
    rut_trabajador VARCHAR2(10) NOT NULL,
    direccion VARCHAR2(200) NOT NULL,
    id_tipo_direccion NUMBER(2) NOT NULL,
    id_comuna NUMBER(4) NOT NULL,
    es_principal CHAR(1) DEFAULT 'S' CHECK (es_principal IN ('S', 'N')),
    fecha_creacion DATE DEFAULT SYSDATE,
    CONSTRAINT fk_trabdir_trabajador FOREIGN KEY (rut_trabajador) REFERENCES Trabajador(rut),
    CONSTRAINT fk_trabdir_comuna FOREIGN KEY (id_comuna) REFERENCES Comuna(id_comuna),
    CONSTRAINT fk_trabdir_tipo FOREIGN KEY (id_tipo_direccion) REFERENCES Tipo_Direccion(id_tipo_direccion)
);

CREATE TABLE Proveedor (
    id_proveedor NUMBER(4) PRIMARY KEY,
    rut VARCHAR2(10) NOT NULL UNIQUE,
    razon_social VARCHAR2(100) NOT NULL,
    giro VARCHAR2(100) NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE,
    usuario_creacion VARCHAR2(50),
    fecha_actualizacion DATE,
    usuario_actualizacion VARCHAR2(50)
);

-- Tabla para direcciones de proveedores (campos multivaluados)
CREATE TABLE Proveedor_Direccion (
    id_direccion NUMBER(4) PRIMARY KEY,
    id_proveedor NUMBER(4) NOT NULL,
    direccion VARCHAR2(200) NOT NULL,
    id_comuna NUMBER(4) NOT NULL,
    es_principal CHAR(1) DEFAULT 'S' CHECK (es_principal IN ('S', 'N')),
    fecha_creacion DATE DEFAULT SYSDATE,
    CONSTRAINT fk_provdir_proveedor FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor),
    CONSTRAINT fk_provdir_comuna FOREIGN KEY (id_comuna) REFERENCES Comuna(id_comuna)
);

-- Tabla para teléfonos de proveedores (campos multivaluados)
CREATE TABLE Proveedor_Telefono (
    id_telefono NUMBER(4) PRIMARY KEY,
    id_proveedor NUMBER(4) NOT NULL,
    numero_telefono VARCHAR2(15) NOT NULL,
    id_tipo_telefono NUMBER(2) NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE,
    CONSTRAINT fk_provtele_proveedor FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor),
    CONSTRAINT fk_provtele_tipo FOREIGN KEY (id_tipo_telefono) REFERENCES Tipo_Telefono(id_tipo_telefono)
);

CREATE TABLE Proveedor_Producto (
    id_proveedor NUMBER(4) NOT NULL,
    id_producto NUMBER(4) NOT NULL,
    fecha_asociacion DATE DEFAULT SYSDATE,
    usuario_asociacion VARCHAR2(50),
    PRIMARY KEY (id_proveedor, id_producto),
    CONSTRAINT fk_provprod_proveedor FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor),
    CONSTRAINT fk_provprod_producto FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Tipo_Documento (
    id_tipo_documento NUMBER(2) PRIMARY KEY,
    descripcion VARCHAR2(20) NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE,
    usuario_creacion VARCHAR2(50)
);

CREATE TABLE Documento (
    id_documento NUMBER(10) PRIMARY KEY,
    nro_correlativo NUMBER(10) NOT NULL,
    fecha_emision DATE NOT NULL,
    afecta_exenta CHAR(1) NOT NULL CHECK (afecta_exenta IN ('A', 'E')),
    neto NUMBER(10,2) NOT NULL,
    iva NUMBER(10,2) NOT NULL,
    total NUMBER(10,2) NOT NULL,
    id_tipo_documento NUMBER(2) NOT NULL,
    rut_cliente VARCHAR2(10),
    razon_social VARCHAR2(100),
    giro VARCHAR2(100),
    id_local NUMBER(4) NOT NULL,
    rut_vendedor VARCHAR2(10) NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE NOT NULL,
    usuario_creacion VARCHAR2(50) NOT NULL,
    CONSTRAINT fk_documento_tipo FOREIGN KEY (id_tipo_documento) REFERENCES Tipo_Documento(id_tipo_documento),
    CONSTRAINT fk_documento_local FOREIGN KEY (id_local) REFERENCES Local(id_local),
    CONSTRAINT fk_documento_vendedor FOREIGN KEY (rut_vendedor) REFERENCES Trabajador(rut),
    CONSTRAINT ck_documento_rut_cliente CHECK (rut_cliente IS NULL OR REGEXP_LIKE(rut_cliente, '^[0-9]{7,8}-[0-9Kk]$'))
);

CREATE TABLE Detalle_Documento (
    id_detalle NUMBER(10) PRIMARY KEY,
    id_documento NUMBER(10) NOT NULL,
    id_producto NUMBER(4) NOT NULL,
    cantidad NUMBER(5) NOT NULL,
    valor_neto NUMBER(10,2) NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE,
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
CREATE SEQUENCE seq_tipo_telefono START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tipo_direccion START WITH 1 INCREMENT BY 1;

-- Insertar tipos de teléfono y dirección
INSERT INTO Tipo_Telefono VALUES (seq_tipo_telefono.NEXTVAL, 'Celular');
INSERT INTO Tipo_Telefono VALUES (seq_tipo_telefono.NEXTVAL, 'Casa');
INSERT INTO Tipo_Telefono VALUES (seq_tipo_telefono.NEXTVAL, 'Trabajo');
INSERT INTO Tipo_Telefono VALUES (seq_tipo_telefono.NEXTVAL, 'Fax');

INSERT INTO Tipo_Direccion VALUES (seq_tipo_direccion.NEXTVAL, 'Casa');
INSERT INTO Tipo_Direccion VALUES (seq_tipo_direccion.NEXTVAL, 'Trabajo');
INSERT INTO Tipo_Direccion VALUES (seq_tipo_direccion.NEXTVAL, 'Oficina');

-- Insertar regiones
INSERT INTO Region VALUES (seq_region.NEXTVAL, 'Región Metropolitana', SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Region VALUES (seq_region.NEXTVAL, 'Valparaíso', SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Region VALUES (seq_region.NEXTVAL, 'Biobío', SYSDATE, 'ADMIN', NULL, NULL);

-- Insertar ciudades
INSERT INTO Ciudad VALUES (seq_ciudad.NEXTVAL, 'Santiago', 1, SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Ciudad VALUES (seq_ciudad.NEXTVAL, 'Valparaíso', 2, SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Ciudad VALUES (seq_ciudad.NEXTVAL, 'Concepción', 3, SYSDATE, 'ADMIN', NULL, NULL);

-- Insertar comunas
INSERT INTO Comuna VALUES (seq_comuna.NEXTVAL, 'Santiago Centro', 1, SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Comuna VALUES (seq_comuna.NEXTVAL, 'Providencia', 1, SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Comuna VALUES (seq_comuna.NEXTVAL, 'Viña del Mar', 2, SYSDATE, 'ADMIN', NULL, NULL);

-- Insertar cadenas de tiendas
INSERT INTO Cadena_Tiendas VALUES (seq_cadena.NEXTVAL, 'SuperMart', '123456789', 'SuperMart S.A.', 'Supermercado', SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Cadena_Tiendas VALUES (seq_cadena.NEXTVAL, 'TecnoShop', '987654321', 'TecnoShop Ltda.', 'Electrónica', SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Cadena_Tiendas VALUES (seq_cadena.NEXTVAL, 'ModaTotal', '456789123', 'ModaTotal SpA', 'Vestuario', SYSDATE, 'ADMIN', NULL, NULL);

-- Insertar locales
INSERT INTO Local VALUES (seq_local.NEXTVAL, 'SuperMart Centro', 'S', 1, 1, SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Local VALUES (seq_local.NEXTVAL, 'SuperMart Providencia', 'N', 1, 2, SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Local VALUES (seq_local.NEXTVAL, 'TecnoShop Viña', 'S', 2, 3, SYSDATE, 'ADMIN', NULL, NULL);

-- Insertar direcciones de locales
INSERT INTO Local_Direccion VALUES (seq_localdir.NEXTVAL, 'Av. Libertador Bernardo O''Higgins 123', 1, 'S', SYSDATE, 'ADMIN');
INSERT INTO Local_Direccion VALUES (seq_localdir.NEXTVAL, 'Av. Providencia 456', 2, 'S', SYSDATE, 'ADMIN');
INSERT INTO Local_Direccion VALUES (seq_localdir.NEXTVAL, 'Av. San Martín 789', 3, 'S', SYSDATE, 'ADMIN');

-- Insertar categorías de productos
INSERT INTO Categoria_Producto VALUES (seq_categoria.NEXTVAL, 'Alimentos', 'Productos alimenticios', SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Categoria_Producto VALUES (seq_categoria.NEXTVAL, 'Electrónica', 'Dispositivos electrónicos', SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Categoria_Producto VALUES (seq_categoria.NEXTVAL, 'Ropa', 'Vestuario y accesorios', SYSDATE, 'ADMIN', NULL, NULL);

-- Insertar productos
INSERT INTO Producto VALUES (seq_producto.NEXTVAL, 'Arroz 1kg', 'Arroz grano largo', 1200.00, 1, SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Producto VALUES (seq_producto.NEXTVAL, 'Smartphone X', 'Teléfono inteligente', 450000.00, 2, SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Producto VALUES (seq_producto.NEXTVAL, 'Jeans Clásico', 'Jeans azul', 25000.00, 3, SYSDATE, 'ADMIN', NULL, NULL);

-- Insertar relación local-producto
INSERT INTO Local_Producto VALUES (1, 1, 100, SYSDATE, 'ADMIN');
INSERT INTO Local_Producto VALUES (1, 2, 20, SYSDATE, 'ADMIN');
INSERT INTO Local_Producto VALUES (2, 1, 80, SYSDATE, 'ADMIN');
INSERT INTO Local_Producto VALUES (3, 2, 15, SYSDATE, 'ADMIN');
INSERT INTO Local_Producto VALUES (3, 3, 30, SYSDATE, 'ADMIN');

-- Insertar trabajadores

INSERT INTO Trabajador VALUES ('12345678-9', 'Juan', 'Pérez', 'González', 500000, 5, 7, NULL, 10, 2, 1, SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Trabajador VALUES ('23456789-1', 'María', 'López', 'Martínez', 550000, 4, NULL, 7, 12, 1, 2, SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Trabajador VALUES ('34567890-2', 'Carlos', 'García', NULL, 600000, 6, 5, NULL, 11, 3, 3, SYSDATE, 'ADMIN', NULL, NULL);

-- Insertar teléfonos de trabajadores (campos multivaluados)
INSERT INTO Trabajador_Telefono VALUES (seq_trabajador_telefono.NEXTVAL, '123456789', '911223344', 1, SYSDATE);
INSERT INTO Trabajador_Telefono VALUES (seq_trabajador_telefono.NEXTVAL, '123456789', '222334455', 2, SYSDATE);
INSERT INTO Trabajador_Telefono VALUES (seq_trabajador_telefono.NEXTVAL, '234567891', '933445566', 1, SYSDATE);

-- Insertar direcciones de trabajadores (campos multivaluados)
INSERT INTO Trabajador_Direccion VALUES (seq_trabajador_direccion.NEXTVAL, '123456789', 'Calle Principal 123', 1, 1, 'S', SYSDATE);
INSERT INTO Trabajador_Direccion VALUES (seq_trabajador_direccion.NEXTVAL, '123456789', 'Calle Secundaria 456', 2, 1, 'N', SYSDATE);
INSERT INTO Trabajador_Direccion VALUES (seq_trabajador_direccion.NEXTVAL, '234567891', 'Av. Siempre Viva 789', 1, 2, 'S', SYSDATE);

-- Insertar proveedores
INSERT INTO Proveedor VALUES (seq_proveedor.NEXTVAL, '111111111', 'Distribuidora Alimentos S.A.', 'Distribución alimentos', SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Proveedor VALUES (seq_proveedor.NEXTVAL, '222222222', 'TecnoImport Ltda.', 'Importación electrónica', SYSDATE, 'ADMIN', NULL, NULL);
INSERT INTO Proveedor VALUES (seq_proveedor.NEXTVAL, '333333333', 'Textiles del Sur SpA', 'Fabricación textiles', SYSDATE, 'ADMIN', NULL, NULL);

-- Insertar direcciones de proveedores (campos multivaluados)
INSERT INTO Proveedor_Direccion VALUES (seq_provdir.NEXTVAL, 1, 'Av. Industrial 123', 1, 'S', SYSDATE);
INSERT INTO Proveedor_Direccion VALUES (seq_provdir.NEXTVAL, 2, 'Calle Tecnológica 456', 1, 'S', SYSDATE);
INSERT INTO Proveedor_Direccion VALUES (seq_provdir.NEXTVAL, 3, 'Ruta Textil 789', 3, 'S', SYSDATE);

-- Insertar teléfonos de proveedores (campos multivaluados)
INSERT INTO Proveedor_Telefono VALUES (seq_provtele.NEXTVAL, 1, '800100200', 3, SYSDATE);
INSERT INTO Proveedor_Telefono VALUES (seq_provtele.NEXTVAL, 1, '900200300', 2, SYSDATE);
INSERT INTO Proveedor_Telefono VALUES (seq_provtele.NEXTVAL, 2, '800300400', 3, SYSDATE);

-- Insertar relación proveedor-producto
INSERT INTO Proveedor_Producto VALUES (1, 1, SYSDATE, 'ADMIN');
INSERT INTO Proveedor_Producto VALUES (2, 2, SYSDATE, 'ADMIN');
INSERT INTO Proveedor_Producto VALUES (3, 3, SYSDATE, 'ADMIN');

-- Insertar tipos de documento
INSERT INTO Tipo_Documento VALUES (seq_tipo_documento.NEXTVAL, 'Boleta', SYSDATE, 'ADMIN');
INSERT INTO Tipo_Documento VALUES (seq_tipo_documento.NEXTVAL, 'Factura', SYSDATE, 'ADMIN');
INSERT INTO Tipo_Documento VALUES (seq_tipo_documento.NEXTVAL, 'Guía Despacho', SYSDATE, 'ADMIN');

-- Insertar documentos
INSERT INTO Documento VALUES (seq_documento.NEXTVAL, 1001, SYSDATE, 'A', 1200.00, 228.00, 1428.00, 1, 
                             '444444444', 'Cliente Uno', 'Particular', 1, '123456789', SYSDATE, 'ADMIN');
INSERT INTO Documento VALUES (seq_documento.NEXTVAL, 2001, SYSDATE, 'A', 450000.00, 85500.00, 535500.00, 2, 
                             '555555555', 'Empresa Dos', 'Comercio', 3, '345678902', SYSDATE, 'ADMIN');
INSERT INTO Documento VALUES (seq_documento.NEXTVAL, 1002, SYSDATE, 'E', 25000.00, 0.00, 25000.00, 1, 
                             '666666666', 'Cliente Tres', 'Particular', 3, '345678902', SYSDATE, 'ADMIN');

-- Insertar detalles de documento
INSERT INTO Detalle_Documento VALUES (seq_detalle_doc.NEXTVAL, 1, 1, 1, 1200.00, SYSDATE);
INSERT INTO Detalle_Documento VALUES (seq_detalle_doc.NEXTVAL, 2, 2, 1, 450000.00, SYSDATE);
INSERT INTO Detalle_Documento VALUES (seq_detalle_doc.NEXTVAL, 3, 3, 1, 25000.00, SYSDATE);

-- Creación de índices
CREATE INDEX idx_producto_nombre ON Producto(nombre_producto);
CREATE INDEX idx_documento_fecha ON Documento(fecha_emision);
CREATE INDEX idx_trabajador_nombre ON Trabajador(apaterno, amaterno, nombre);
CREATE INDEX idx_local_producto ON Local_Producto(id_producto, id_local);
CREATE INDEX idx_documento_cliente ON Documento(rut_cliente);
CREATE INDEX idx_documento_vendedor ON Documento(rut_vendedor);

-- Creación de vistas
CREATE VIEW ventas_por_local AS
SELECT l.nombre_local, ct.nombre_cadena, 
       SUM(d.neto) AS total_neto, 
       SUM(d.iva) AS total_iva,
       SUM(d.total) AS total_ventas,
       COUNT(*) AS cantidad_documentos
FROM Documento d
JOIN Local l ON d.id_local = l.id_local
JOIN Cadena_Tiendas ct ON l.id_cadena = ct.id_cadena
GROUP BY l.nombre_local, ct.nombre_cadena;

CREATE VIEW stock_critico AS
SELECT p.nombre_producto, cp.nombre_categoria, 
       l.nombre_local, lp.stock,
       pr.razon_social AS proveedor
FROM Local_Producto lp
JOIN Producto p ON lp.id_producto = p.id_producto
JOIN Categoria_Producto cp ON p.id_categoria = cp.id_categoria
JOIN Local l ON lp.id_local = l.id_local
JOIN Proveedor_Producto pp ON p.id_producto = pp.id_producto
JOIN Proveedor pr ON pp.id_proveedor = pr.id_proveedor
WHERE lp.stock < 10;

CREATE VIEW comisiones_vendedores AS
SELECT t.rut, t.nombre || ' ' || t.apaterno AS vendedor,
       l.nombre_local,
       SUM(d.total) AS total_ventas,
       t.comision || '%' AS porcentaje_comision,
       SUM(d.total) * t.comision / 100 AS comision_ganada
FROM Documento d
JOIN Trabajador t ON d.rut_vendedor = t.rut
JOIN Local l ON t.id_local = l.id_local
GROUP BY t.rut, t.nombre, t.apaterno, l.nombre_local, t.comision
ORDER BY comision_ganada DESC;

COMMIT; 