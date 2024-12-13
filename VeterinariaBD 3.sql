CREATE DATABASE [VeterinariaBD]
USE [VeterinariaBD]
GO
/****** Object:  Table [dbo].[Animales]    Script Date: 06/11/2024 19:45:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Animales](
	[ID_Animal] [int] IDENTITY(1,1) NOT NULL,
	[TipoAnimal] [varchar](50) NOT NULL,
	[Descripcion] [varchar](100) NULL,
	[Especie] [varchar](50) NULL,
	[Raza] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Animal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AnimalPorClientes]    Script Date: 06/11/2024 19:45:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AnimalPorClientes](
	[ID_AnimalPorCliente] [int] IDENTITY(1,1) NOT NULL,
	[ID_Cliente] [int] NOT NULL,
	[ID_Animal] [int] NULL,
	[NombreAnimal] [varchar](50) NULL,
	[FechaIngreso] [date] NOT NULL,
	[Edad] [int] NULL,
	[Peso] [decimal](5, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_AnimalPorCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AtencionAnimal]    Script Date: 06/11/2024 19:45:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AtencionAnimal](
	[ID_Atencion] [int] IDENTITY(1,1) NOT NULL,
	[ID_AnimalPorCliente] [int] NOT NULL,
	[TipoAnimal] [varchar](50) NOT NULL,
	[ID_Tratamiento] [int] NULL,
	[Fecha] [date] NOT NULL,
	[Diagnostico] [varchar](100) NULL,
	[Veterinario] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Atencion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AtencionTratamiento]    Script Date: 06/11/2024 19:45:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AtencionTratamiento](
	[ID_Atencion] [int] NOT NULL,
	[ID_Tratamiento] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Atencion] ASC,
	[ID_Tratamiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) 
)ON [PRIMARY];
GO
/****** Object:  Table [dbo].[Clientes]    Script Date: 06/11/2024 19:45:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
	[ID_Cliente] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Apellido1] [varchar](50) NOT NULL,
	[Apellido2] [varchar](50) NULL,
	[Telefono] [varchar](20) NULL,
	[Correo] [varchar](100) NULL,
	[Direccion] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tratamiento]    Script Date: 06/11/2024 19:45:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tratamiento](
	[ID_Tratamiento] [int] IDENTITY(1,1) NOT NULL,
	[Tratamiento] [varchar](100) NOT NULL,
	[Descripcion] [varchar](100) NULL,
	[Costo] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Tratamiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE AnimalesHistorial (
    ID_Historial INT IDENTITY(1,1) PRIMARY KEY,
    ID_Animal INT,
    TipoAnimal VARCHAR(50),
    Descripcion VARCHAR(100),
    Especie VARCHAR(50),
    Raza VARCHAR(50),
    FechaModificacion DATETIME DEFAULT GETDATE()
);


/****** Creacion de tabla AnimalesEliminados ******/
CREATE TABLE AnimalesEliminados (
    ID_Historial INT IDENTITY(1,1) PRIMARY KEY,
    ID_Animal INT,
    TipoAnimal VARCHAR(50),
    Descripcion VARCHAR(100),
    Especie VARCHAR(50),
    Raza VARCHAR(50),
    FechaEliminacion DATETIME DEFAULT GETDATE()
);

/****** Trigger para  la tabla AnimalesEliminados ******/

CREATE TRIGGER Trigger_Delete_Animales
ON Animales
AFTER DELETE
AS
BEGIN
    INSERT INTO AnimalesEliminados (ID_Animal, TipoAnimal, Descripcion, Especie, Raza)
    SELECT ID_Animal, TipoAnimal, Descripcion, Especie, Raza
    FROM DELETED;

    PRINT 'Información de animal eliminado registrada.';
END;

/*****/

ALTER TABLE [dbo].[AnimalPorClientes] 
WITH CHECK ADD FOREIGN KEY([ID_Animal])
REFERENCES [dbo].[Animales] ([ID_Animal])
ON DELETE NO ACTION;

ALTER TABLE [dbo].[AnimalPorClientes] 
WITH CHECK ADD FOREIGN KEY([ID_Cliente])
REFERENCES [dbo].[Clientes] ([ID_Cliente])
ON DELETE CASCADE;

ALTER TABLE [dbo].[AtencionAnimal] 
WITH CHECK ADD FOREIGN KEY([ID_AnimalPorCliente])
REFERENCES [dbo].[AnimalPorClientes] ([ID_AnimalPorCliente])
ON DELETE CASCADE;

ALTER TABLE [dbo].[AtencionTratamiento] 
WITH CHECK ADD FOREIGN KEY([ID_Atencion])
REFERENCES [dbo].[AtencionAnimal] ([ID_Atencion])
ON DELETE CASCADE;

ALTER TABLE [dbo].[AtencionTratamiento] 
WITH CHECK ADD FOREIGN KEY([ID_Tratamiento])
REFERENCES [dbo].[Tratamiento] ([ID_Tratamiento])
ON DELETE CASCADE;

/***Procedimientos de Inserción de Datos****/

CREATE PROCEDURE InsertarAnimal
    @TipoAnimal VARCHAR(50),
    @Descripcion VARCHAR(100),
    @Especie VARCHAR(50),
    @Raza VARCHAR(50)
AS
BEGIN
    INSERT INTO Animales (TipoAnimal, Descripcion, Especie, Raza)
    VALUES (@TipoAnimal, @Descripcion, @Especie, @Raza);
END;

/***Trigger de Modificación de Datos*/

CREATE TRIGGER Trigger_Update_Animales
ON Animales
AFTER UPDATE
AS
BEGIN
    -- Registrar datos antiguos en la tabla de historial
    INSERT INTO AnimalesHistorial (ID_Animal, TipoAnimal, Descripcion, Especie, Raza)
    SELECT ID_Animal, TipoAnimal, Descripcion, Especie, Raza
    FROM DELETED;

    PRINT 'Historial de actualización registrado.';
END;


/***Procedimientos de Modificación de Datos*/

CREATE PROCEDURE ModificarAnimal
    @ID_Animal INT,
    @TipoAnimal VARCHAR(50),
    @Descripcion VARCHAR(100),
    @Especie VARCHAR(50),
    @Raza VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        UPDATE Animales
        SET TipoAnimal = @TipoAnimal,
            Descripcion = @Descripcion,
            Especie = @Especie,
            Raza = @Raza
        WHERE ID_Animal = @ID_Animal;

        PRINT 'Animal actualizado correctamente.';
    END TRY
    BEGIN CATCH
        RAISERROR('Error al actualizar el animal', 16, 1);
    END CATCH;
END;

/***Procedimientos de Eliminación Lógica de Datos*/
/*Modificación de tablas para agregar columna*/

ALTER TABLE Animales ADD Activo BIT DEFAULT 1;
ALTER TABLE AnimalPorClientes ADD Activo BIT DEFAULT 1;
ALTER TABLE AtencionAnimal ADD Activo BIT DEFAULT 1;
ALTER TABLE Clientes ADD Activo BIT DEFAULT 1;
ALTER TABLE Tratamiento ADD Activo BIT DEFAULT 1;
ALTER TABLE AtencionTratamiento ADD Activo BIT DEFAULT 1;

/*Trigger para eliminación lógica en la tabla*/

CREATE TRIGGER Trigger_Prevent_Delete_Animales
ON Animales
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM DELETED d
        JOIN AnimalPorClientes ac ON d.ID_Animal = ac.ID_Animal
    )
    BEGIN
        RAISERROR ('No se puede eliminar un animal con clientes asociados.', 16, 1);
        RETURN;
    END

    -- Permitir eliminación física si no hay asociaciones
    DELETE FROM Animales
    WHERE ID_Animal IN (SELECT ID_Animal FROM DELETED);

    PRINT 'Animal eliminado físicamente (sin asociaciones).';
END;

/*SP para eliminación lógica en la tabla*/

CREATE PROCEDURE EliminarLogicoAnimal
    @ID_Animal INT
AS
BEGIN
    BEGIN TRY
        UPDATE Animales
        SET Activo = 0
        WHERE ID_Animal = @ID_Animal;

        PRINT 'Animal eliminado lógicamente.';
    END TRY
    BEGIN CATCH
        RAISERROR('Error al eliminar lógicamente el animal', 16, 1);
    END CATCH;
END;




-----Agregados pendientes-----

-- Procedimiento para insertar un cliente
CREATE PROCEDURE InsertarCliente
    @Nombre VARCHAR(50),
    @Apellido1 VARCHAR(50),
    @Apellido2 VARCHAR(50) = NULL,
    @Telefono VARCHAR(20) = NULL,
    @Correo VARCHAR(100) = NULL,
    @Direccion VARCHAR(100) = NULL
AS
BEGIN
    INSERT INTO Clientes (Nombre, Apellido1, Apellido2, Telefono, Correo, Direccion)
    VALUES (@Nombre, @Apellido1, @Apellido2, @Telefono, @Correo, @Direccion);
END;

-- Procedimiento para insertar una atención de un animal
CREATE PROCEDURE InsertarAtencionAnimal
    @ID_AnimalPorCliente INT,
    @ID_Tratamiento INT,
    @Fecha DATE,
    @Diagnostico VARCHAR(100) = NULL,
    @Veterinario VARCHAR(50) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM AnimalPorClientes WHERE ID_AnimalPorCliente = @ID_AnimalPorCliente AND Activo = 1)
    BEGIN
        RAISERROR ('Animal no existe o está inactivo', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM Tratamiento WHERE ID_Tratamiento = @ID_Tratamiento AND Activo = 1)
    BEGIN
        RAISERROR ('Tratamiento no existe o está inactivo', 16, 1);
        RETURN;
    END
    INSERT INTO AtencionAnimal (ID_AnimalPorCliente, ID_Tratamiento, Fecha, Diagnostico, Veterinario, Activo)
    VALUES (@ID_AnimalPorCliente, @ID_Tratamiento, @Fecha, @Diagnostico, @Veterinario, 1);
END;


-- Procedimiento para insertar un tratamiento
CREATE PROCEDURE InsertarTratamiento
    @Tratamiento VARCHAR(100),
    @Descripcion [varchar](100) = NULL,
    @Costo DECIMAL(10, 2) = NULL
AS
BEGIN
    INSERT INTO Tratamiento (Tratamiento, Descripcion, Costo)
    VALUES (@Tratamiento, @Descripcion, @Costo);
END;

-- Procedimiento para insertar una relación entre atención y tratamiento
CREATE PROCEDURE InsertarAtencionTratamiento
    @ID_Atencion INT,
    @ID_Tratamiento INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM AtencionAnimal WHERE ID_Atencion = @ID_Atencion)
       AND EXISTS (SELECT 1 FROM Tratamiento WHERE ID_Tratamiento = @ID_Tratamiento)
    BEGIN
        INSERT INTO AtencionTratamiento (ID_Atencion, ID_Tratamiento)
        VALUES (@ID_Atencion, @ID_Tratamiento);
    END
    ELSE
    BEGIN
        RAISERROR('Atención o Tratamiento no existe', 16, 1);
    END
END;


-- Procedimiento para modificar un cliente
CREATE PROCEDURE ModificarCliente
    @ID_Cliente INT,
    @Nombre VARCHAR(50),
    @Apellido1 VARCHAR(50),
    @Apellido2 VARCHAR(50) = NULL,
    @Telefono VARCHAR(20) = NULL,
    @Correo VARCHAR(100) = NULL,
    @Direccion VARCHAR(MAX) = NULL
AS
BEGIN
    BEGIN TRY
        UPDATE Clientes
        SET Nombre = @Nombre,
            Apellido1 = @Apellido1,
            Apellido2 = @Apellido2,
            Telefono = @Telefono,
            Correo = @Correo,
            Direccion = @Direccion
        WHERE ID_Cliente = @ID_Cliente AND Activo = 1;
    END TRY
    BEGIN CATCH
        RAISERROR('Error al modificar el cliente', 16, 1);
    END CATCH;
END;


-- Procedimiento para modificar una atención animal
CREATE PROCEDURE ModificarAtencionAnimal
    @ID_Atencion INT,
    @TipoAnimal VARCHAR(50),
    @ID_Tratamiento INT,
    @Fecha DATE,
    @Diagnostico VARCHAR(100) = NULL,
    @Veterinario VARCHAR(50) = NULL
AS
BEGIN
    UPDATE AtencionAnimal
    SET TipoAnimal = @TipoAnimal,
        ID_Tratamiento = @ID_Tratamiento,
        Fecha = @Fecha,
        Diagnostico = @Diagnostico,
        Veterinario = @Veterinario
    WHERE ID_Atencion = @ID_Atencion AND Activo = 1;
END;

-- Procedimiento para modificar un tratamiento
CREATE PROCEDURE ModificarTratamiento
    @ID_Tratamiento INT,
    @Tratamiento VARCHAR(100),
    @Descripcion VARCHAR(100) = NULL,
    @Costo DECIMAL(10, 2) = NULL
AS
BEGIN
    UPDATE Tratamiento
    SET Tratamiento = @Tratamiento,
        Descripcion = @Descripcion,
        Costo = @Costo
    WHERE ID_Tratamiento = @ID_Tratamiento AND Activo = 1;
END;

-- Procedimiento para eliminación lógica de un cliente
CREATE PROCEDURE EliminarLogicoCliente
    @ID_Cliente INT
AS
BEGIN
    UPDATE Clientes
    SET Activo = 0
    WHERE ID_Cliente = @ID_Cliente;
END;

-- Procedimiento para eliminación lógica de una atención animal
CREATE PROCEDURE EliminarLogicoAtencionAnimal
    @ID_Atencion INT
AS
BEGIN
    UPDATE AtencionAnimal
    SET Activo = 0
    WHERE ID_Atencion = @ID_Atencion;
END;

-- Procedimiento para eliminación lógica de un tratamiento
CREATE PROCEDURE EliminarLogicoTratamiento
    @ID_Tratamiento INT
AS
BEGIN
    UPDATE Tratamiento
    SET Activo = 0
    WHERE ID_Tratamiento = @ID_Tratamiento;
END;

-- Procedimiento para eliminación lógica de un animal por cliente
CREATE PROCEDURE EliminarLogicoAnimalPorCliente
    @ID_AnimalPorCliente INT
AS
BEGIN
    UPDATE AnimalPorClientes
    SET Activo = 0
    WHERE ID_AnimalPorCliente = @ID_AnimalPorCliente;
END;


-----Fin de lo agregado adicional-----


/***Consulta para obtener los tratamientos de tipo vacuna de cada animal*/

CREATE FUNCTION dbo.TratamientosVacunaPorAnimal()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        a.ID_Animal,
        ac.NombreAnimal,
        t.Tratamiento,
        t.Descripcion,
        t.Costo
    FROM 
        Animales a
    JOIN 
        AnimalPorClientes ac ON a.ID_Animal = ac.ID_Animal
    JOIN 
        AtencionAnimal aa ON ac.ID_AnimalPorCliente = aa.ID_AnimalPorCliente
    JOIN 
        AtencionTratamiento at ON aa.ID_Atencion = at.ID_Atencion
    JOIN 
        Tratamiento t ON at.ID_Tratamiento = t.ID_Tratamiento
    WHERE 
        t.Tratamiento COLLATE Latin1_General_CI_AI LIKE '%vacuna%'
);

SELECT * 
FROM Tratamiento
WHERE Tratamiento COLLATE Latin1_General_CI_AI LIKE '%vacuna%';

SELECT 
    a.ID_Animal,
    ac.NombreAnimal,
    t.Tratamiento,
    t.Descripcion,
    t.Costo
FROM 
    Animales a
JOIN 
    AnimalPorClientes ac ON a.ID_Animal = ac.ID_Animal
JOIN 
    AtencionAnimal aa ON ac.ID_AnimalPorCliente = aa.ID_AnimalPorCliente
JOIN 
    AtencionTratamiento at ON aa.ID_Atencion = at.ID_Atencion
JOIN 
    Tratamiento t ON at.ID_Tratamiento = t.ID_Tratamiento
WHERE 
	t.Tratamiento COLLATE Latin1_General_CI_AI LIKE '%vacuna%'

SELECT * FROM Animales;
SELECT * FROM AnimalPorClientes;
SELECT * FROM AtencionAnimal;
SELECT * FROM AtencionTratamiento;
SELECT * FROM Tratamiento;

/***Integridad de Datos en Inserciones y Modificaciones*/
CREATE PROCEDURE InsertarAnimalPorCliente
    @ID_Cliente INT,
    @ID_Animal INT,
    @NombreAnimal VARCHAR(50),
    @FechaIngreso DATE,
    @Edad INT,
    @Peso DECIMAL(5, 2)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Clientes WHERE ID_Cliente = @ID_Cliente AND Activo = 1)
    BEGIN
        RAISERROR ('Cliente no existe o está inactivo', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Animales WHERE ID_Animal = @ID_Animal AND Activo = 1)
    BEGIN
        RAISERROR ('Animal no existe o está inactivo', 16, 1);
        RETURN;
    END

    INSERT INTO AnimalPorClientes (ID_Cliente, ID_Animal, NombreAnimal, FechaIngreso, Edad, Peso)
    VALUES (@ID_Cliente, @ID_Animal, @NombreAnimal, @FechaIngreso, @Edad, @Peso);
END;


-----Puntos 11,12,13,14-----

INSERT INTO Animales (TipoAnimal, Descripcion, Especie, Raza, Activo) VALUES
('Perro', 'Animal doméstico común', 'Canis lupus familiaris', 'Golden Retriever', 1),
('Gato', 'Animal doméstico', 'Felis catus', 'Persa', 1),
('Ave', 'Ave doméstica común', 'Serinus canaria', 'Canario', 1),
('Conejo', 'Animal pequeño y doméstico', 'Oryctolagus cuniculus', 'Rex', 1),
('Tortuga', 'Animal de lenta movilidad', 'Chelonoidis nigra', 'Galápago', 1);

INSERT INTO Clientes (Nombre, Apellido1, Apellido2, Telefono, Correo, Direccion, Activo) VALUES
('Carlos', 'González', 'López', '123456789', 'carlosg@gmail.com', 'Calle 123', 1),
('María', 'Martínez', 'Ruiz', '987654321', 'mariam@gmail.com', 'Avenida 45', 1),
('Jorge', 'Pérez', 'Soto', '456789123', 'jorgep@gmail.com', 'Calle 88', 1),
('Ana', 'Lopez', 'Jiménez', '321654987', 'anaj@gmail.com', 'Calle 12', 1),
('Sofía', 'Ramírez', 'Ortiz', '654321987', 'sofiar@gmail.com', 'Avenida 99', 1);

INSERT INTO Tratamiento (Tratamiento, Descripcion, Costo, Activo) VALUES
('Vacunación', 'Administración de vacuna', 10000, 1),
('Desparasitación', 'Eliminación de parásitos', 15000, 1),
('Corte de uñas', 'Corte de uñas para perros y gatos', 5000, 1),
('Limpieza dental', 'Limpieza dental completa', 15000, 1),
('Chequeo general', 'Chequeo general de salud', 20000, 1);

INSERT INTO AnimalPorClientes (ID_Cliente, ID_Animal, NombreAnimal, FechaIngreso, Edad, Peso, Activo) VALUES
(1, 1, 'Max', '2023-01-15', 2, 20.5, 1),
(2, 2, 'Luna', '2023-03-20', 3, 3.2, 1),
(3, 1, 'Rocky', '2023-02-10', 4, 22.0, 1),
(4, 4, 'Bunny', '2023-04-25', 1, 1.5, 1),
(5, 3, 'Sunny', '2023-05-30', 2, 0.1, 1),
(1, 2, 'Mia', '2023-06-20', 5, 3.5, 1),
(2, 3, 'Lucky', '2023-07-15', 3, 2.8, 1),
(3, 5, 'Shelly', '2023-08-25', 8, 12.0, 1),
(4, 1, 'Buddy', '2023-09-10', 4, 25.0, 1),
(5, 4, 'Pepper', '2023-10-05', 2, 1.2, 1),
(1, 5, 'Turbo', '2023-11-01', 9, 10.5, 1),
(2, 2, 'Charlie', '2023-12-20', 7, 4.0, 1),
(3, 3, 'Buster', '2024-01-15', 6, 2.3, 1),
(4, 1, 'Spot', '2024-02-10', 5, 30.0, 1),
(5, 5, 'Flash', '2024-03-25', 12, 15.0, 1);

INSERT INTO AtencionAnimal (ID_AnimalPorCliente, TipoAnimal, ID_Tratamiento, Fecha, Diagnostico, Veterinario, Activo) VALUES
(1, 'Perro', 1, '2023-01-20', 'Vacuna anual', 'Dr. López', 1),
(2, 'Gato', 2, '2023-03-25', 'Desparasitación regular', 'Dr. García', 1),
(3, 'Perro', 3, '2023-02-15', 'Examen anual', 'Dr. Martínez', 1),
(4, 'Conejo', 4, '2023-04-30', 'Corte de uñas', 'Dr. Rivera', 1),
(5, 'Ave', 5, '2023-05-05', 'Examen de rutina', 'Dr. Jiménez', 1),
(1, 'Perro', 1, '2023-06-10', 'Limpieza profunda', 'Dr. Hernández', 1),
(2, 'Gato', 2, '2023-07-20', 'Examen completo', 'Dr. Sánchez', 1),
(3, 'Tortuga', 3, '2023-08-15', 'Vacuna específica', 'Dr. Pérez', 1),
(4, 'Perro', 4, '2023-09-05', 'Parásitos internos', 'Dr. Suárez', 1),
(5, 'Conejo', 5, '2023-10-01', 'Vacuna específica', 'Dr. Mora', 1),
(1, 'Perro', 1, '2023-11-10', 'Corte estacional', 'Dr. López', 1),
(2, 'Gato', 2, '2023-12-15', 'Limpieza anual', 'Dr. García', 1),
(3, 'Perro', 3, '2024-01-25', 'Chequeo general', 'Dr. Martínez', 1),
(4, 'Conejo', 4, '2024-02-18', 'Desparasitación completa', 'Dr. Rivera', 1),
(5, 'Ave', 5, '2024-03-12', 'Vacuna preventiva', 'Dr. Jiménez', 1);

INSERT INTO AtencionTratamiento (ID_Atencion, ID_Tratamiento)
VALUES 
    (1, 1),  -- Relaciona la atención con ID 1 y el tratamiento con ID 1
    (2, 2),  -- Relaciona la atención con ID 2 y el tratamiento con ID 2
    (3, 1),  -- Relaciona la atención con ID 3 y el tratamiento con ID 1
    (4, 3),  -- Ajusta los valores según los datos existentes en AtencionAnimal y Tratamiento
    (5, 4);

CREATE FUNCTION ListaTratamientoPorAnimal()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        ac.ID_Animal,
        ac.NombreAnimal,
        t.Tratamiento,
        t.Descripcion,
        t.Costo
    FROM 
        AnimalPorClientes ac
    JOIN 
        AtencionAnimal aa ON ac.ID_AnimalPorCliente = aa.ID_AnimalPorCliente
    JOIN 
        AtencionTratamiento at ON aa.ID_Atencion = at.ID_Atencion
    JOIN 
        Tratamiento t ON at.ID_Tratamiento = t.ID_Tratamiento
);

--Diccionario
SELECT 
    TABLE_NAME AS 'Tabla',
    COLUMN_NAME AS 'Campo',
    DATA_TYPE AS 'Tipo de dato',
    CHARACTER_MAXIMUM_LENGTH AS 'Tamaño',
    IS_NULLABLE AS 'Permite nulos'
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_SCHEMA = 'dbo';

--Preubas--
-----1. Verificar la Estructura de las Tablas

SELECT 
    TABLE_NAME AS 'Tabla',
    COLUMN_NAME AS 'Campo',
    DATA_TYPE AS 'Tipo de dato',
    CHARACTER_MAXIMUM_LENGTH AS 'Tamaño',
    IS_NULLABLE AS 'Permite nulos'
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_SCHEMA = 'dbo';

-----2. Verificar Inserciones en Tablas Maestras

SELECT * FROM Animales;
SELECT * FROM Clientes;
SELECT * FROM Tratamiento;

-----3. Verificar Inserciones en Tablas de Detalle

SELECT * FROM AnimalPorClientes;
SELECT * FROM AtencionAnimal;
SELECT * FROM AtencionTratamiento;

SELECT * FROM [dbo].[Animales]
SELECT * FROM [dbo].[AnimalesEliminados]
SELECT * FROM [dbo].[Clientes]
SELECT * FROM [dbo].[Tratamiento]

-----4. Verificar Funcionalidad de la Función ListaTratamientoPorAnimal

SELECT * FROM ListaTratamientoPorAnimal();

-----5. Validar Procedimientos de Inserción

EXEC InsertarAnimal 'Ave', 'Ave doméstica', 'Psittaciformes', 'Loro';
EXEC InsertarCliente 'Juan', 'Pérez', 'Gómez', '1234567890', 'juan@gmail.com', 'Calle 123';
EXEC InsertarTratamiento 'Vacunación antirrábica', 'Vacuna contra la rabia', 120.00;

-----6. Validar Procedimientos de Actualización

EXEC ModificarAnimal 1, 'Perro', 'Animal modificado', 'Canis lupus familiaris', 'Labrador';
EXEC ModificarCliente 1, 'Carlos', 'González', 'López', '0987654321', 'carlos_modificado@gmail.com', 'Calle Modificada';
EXEC ModificarTratamiento 1, 'Vacunación general', 'Vacuna modificada', 150.00;

------7. Validar Procedimientos de Eliminación Lógica

EXEC EliminarLogicoAnimal 1;
EXEC EliminarLogicoCliente 1;
EXEC EliminarLogicoTratamiento 1;
