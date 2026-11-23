
-- INNOVATION HUB
-- Archivo: docs/consultas.sql
-- Consultas de prueba para SQL Server
--
-- Requisito: ejecutar primero sql/schema.sql
-- en una base de datos de prueba vacía.
--
-- Las consultas utilizan los datos ficticios del proyecto.
-- ============================================================


-- ============================================================
-- CONSULTA 1: JOIN UNO A MUCHOS (1:N)
-- Objetivo: mostrar cada iniciativa con su propietario.
--
-- Tablas utilizadas:
--   Iniciativas
--   Usuarios
--
-- Relación:
--   Iniciativas.PropietarioId = Usuarios.UsuarioId
--
-- Resultado esperado: 3 filas.
-- ============================================================

SELECT
    i.IniciativaId,
    i.Titulo,
    u.Nombre AS Propietario
FROM Iniciativas AS i
INNER JOIN Usuarios AS u
    ON i.PropietarioId = u.UsuarioId
ORDER BY i.IniciativaId;

-- RESULTADO ESPERADO:
--
-- 1 | Plataforma ambiental | Ana Mora
-- 2 | Educación digital    | Luis Vega
-- 3 | Movilidad sostenible | Ana Mora



-- ============================================================
-- CONSULTA 2: JOIN MUCHOS A MUCHOS (N:M)
-- Objetivo: mostrar las competencias de cada iniciativa.
--
-- Tablas utilizadas:
--   Iniciativas
--   IniciativaCompetencias
--   Competencias
--
-- La tabla intermedia permite resolver la relación N:M.
--
-- Resultado esperado: 5 filas.
-- ============================================================

SELECT
    i.Titulo,
    c.Nombre AS Competencia
FROM Iniciativas AS i
INNER JOIN IniciativaCompetencias AS ic
    ON i.IniciativaId = ic.IniciativaId
INNER JOIN Competencias AS c
    ON ic.CompetenciaId = c.CompetenciaId
ORDER BY
    i.IniciativaId,
    c.Nombre;

-- RESULTADO ESPERADO:
--
-- Plataforma ambiental | React
-- Plataforma ambiental | SQL Server
-- Educación digital    | Gestión
-- Educación digital    | UX
-- Movilidad sostenible | Python



-- ============================================================
-- CONSULTA 3: GROUP BY Y LEFT JOIN
-- Objetivo: contar las solicitudes de cada iniciativa.
--
-- Tablas utilizadas:
--   Iniciativas
--   Solicitudes
--
-- LEFT JOIN permite mostrar iniciativas sin solicitudes.
-- COUNT(s.SolicitudId) devuelve 0 cuando no hay solicitudes.
--
-- Resultado esperado: 3 filas.
-- ============================================================

SELECT
    i.Titulo,
    COUNT(s.SolicitudId) AS TotalSolicitudes
FROM Iniciativas AS i
LEFT JOIN Solicitudes AS s
    ON i.IniciativaId = s.IniciativaId
GROUP BY
    i.IniciativaId,
    i.Titulo
ORDER BY i.IniciativaId;

-- RESULTADO ESPERADO:
--
-- Plataforma ambiental | 1
-- Educación digital    | 1
-- Movilidad sostenible | 0



-- ============================================================
-- CONSULTA 4: UPDATE Y DELETE CON WHERE
-- Objetivo: demostrar la modificación y eliminación de datos.
--
-- Tabla utilizada:
--   Solicitudes
--
-- Se utiliza una transacción para evitar cambios permanentes.
-- ROLLBACK restaura los datos originales.
--
-- Resultado esperado:
--   UPDATE afecta 1 fila.
--   DELETE afecta 1 fila.
--   Los datos originales se conservan después del ROLLBACK.
-- ============================================================

BEGIN TRANSACTION;

-- Cambiar el estado de una solicitud.
UPDATE Solicitudes
SET Estado = 'aceptada'
WHERE SolicitudId = 1;

-- Eliminar temporalmente otra solicitud.
DELETE FROM Solicitudes
WHERE SolicitudId = 2;

-- Verificar los cambios antes de revertirlos.
SELECT
    SolicitudId,
    IniciativaId,
    UsuarioId,
    Estado
FROM Solicitudes
ORDER BY SolicitudId;

-- RESULTADO TEMPORAL ESPERADO:
--
-- SolicitudId = 1, Estado = aceptada
-- SolicitudId = 2 ya no aparece.

-- Revertir los cambios realizados.
ROLLBACK TRANSACTION;

-- Comprobar que los datos originales se restauraron.
SELECT
    SolicitudId,
    IniciativaId,
    UsuarioId,
    Estado
FROM Solicitudes
ORDER BY SolicitudId;

-- RESULTADO FINAL ESPERADO:
--
-- SolicitudId = 1, Estado = pendiente
-- SolicitudId = 2, Estado = aceptada
--
-- Ninguna modificación queda guardada.



-- ============================================================
-- CONSULTA 5: VALIDACIÓN DE CLAVE FORÁNEA
-- Objetivo: demostrar la integridad referencial.
--
-- Tabla utilizada:
--   Solicitudes
--
-- Se intenta insertar una solicitud con UsuarioId = 999999.
-- Este usuario no existe en los datos de prueba.
--
-- Resultado