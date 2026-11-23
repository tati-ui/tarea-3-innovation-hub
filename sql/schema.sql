-- Script de diseño y datos ficticios. Ejecutar en una base de prueba vacía.
CREATE TABLE Usuarios (UsuarioId INT IDENTITY(1,1) PRIMARY KEY, Nombre NVARCHAR(100) NOT NULL, Correo NVARCHAR(255) NOT NULL UNIQUE);
CREATE TABLE Competencias (CompetenciaId INT IDENTITY(1,1) PRIMARY KEY, Nombre NVARCHAR(100) NOT NULL UNIQUE);
CREATE TABLE Iniciativas (IniciativaId INT IDENTITY(1,1) PRIMARY KEY, PropietarioId INT NOT NULL REFERENCES Usuarios(UsuarioId), Titulo NVARCHAR(160) NOT NULL, Descripcion NVARCHAR(1000) NULL);
CREATE TABLE Solicitudes (SolicitudId INT IDENTITY(1,1) PRIMARY KEY, IniciativaId INT NOT NULL REFERENCES Iniciativas(IniciativaId), UsuarioId INT NOT NULL REFERENCES Usuarios(UsuarioId), Estado NVARCHAR(20) NOT NULL DEFAULT 'pendiente', CONSTRAINT CK_Solicitudes_Estado CHECK (Estado IN ('pendiente','aceptada','rechazada')), CONSTRAINT UQ_Solicitudes UNIQUE(IniciativaId,UsuarioId));
CREATE TABLE Equipos (EquipoId INT IDENTITY(1,1) PRIMARY KEY, IniciativaId INT NOT NULL REFERENCES Iniciativas(IniciativaId), Nombre NVARCHAR(100) NOT NULL);
CREATE TABLE UsuarioCompetencias (UsuarioId INT NOT NULL REFERENCES Usuarios(UsuarioId), CompetenciaId INT NOT NULL REFERENCES Competencias(CompetenciaId), CONSTRAINT PK_UsuarioCompetencias PRIMARY KEY(UsuarioId,CompetenciaId));
CREATE TABLE IniciativaCompetencias (IniciativaId INT NOT NULL REFERENCES Iniciativas(IniciativaId), CompetenciaId INT NOT NULL REFERENCES Competencias(CompetenciaId), CONSTRAINT PK_IniciativaCompetencias PRIMARY KEY(IniciativaId,CompetenciaId));
CREATE TABLE EquipoMiembros (EquipoId INT NOT NULL REFERENCES Equipos(EquipoId), UsuarioId INT NOT NULL REFERENCES Usuarios(UsuarioId), CONSTRAINT PK_EquipoMiembros PRIMARY KEY(EquipoId,UsuarioId));
INSERT INTO Usuarios(Nombre,Correo) VALUES ('Ana Mora','ana@example.test'),('Luis Vega','luis@example.test'),('Sara Rojas','sara@example.test');
INSERT INTO Competencias(Nombre) VALUES ('React'),('SQL Server'),('UX'),('Python'),('Gestión');
INSERT INTO Iniciativas(PropietarioId,Titulo,Descripcion) VALUES (1,'Plataforma ambiental','Monitoreo de iniciativas'),(2,'Educación digital','Materiales de aprendizaje'),(1,'Movilidad sostenible','Propuestas de movilidad');
INSERT INTO Equipos(IniciativaId,Nombre) VALUES (1,'Equipo Verde'),(2,'Equipo Aula');
INSERT INTO Solicitudes(IniciativaId,UsuarioId,Estado) VALUES (1,2,'pendiente'),(2,3,'aceptada');
INSERT INTO UsuarioCompetencias(UsuarioId,CompetenciaId) VALUES (1,1),(1,3),(2,2),(2,4),(3,3),(3,5);
INSERT INTO IniciativaCompetencias(IniciativaId,CompetenciaId) VALUES (1,1),(1,2),(2,3),(2,5),(3,4);
INSERT INTO EquipoMiembros(EquipoId,UsuarioId) VALUES (1,1),(1,2),(2,2),(2,3);
