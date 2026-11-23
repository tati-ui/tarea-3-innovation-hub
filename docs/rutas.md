# 2.5 Diseño de dos rutas GET

No se implementan en C# en esta parte; son contratos de diseño para una futura API ASP.NET Core.

## Ruta 1 — GET /api/iniciativas/{id}
- **Autenticación:** no requiere sesión para lectura pública; si una iniciativa fuese privada, se agregaría autorización.
- **Tablas:** Iniciativas, Usuarios, IniciativaCompetencias, Competencias.
- **Consulta SQL:**
```sql
SELECT i.IniciativaId,i.Titulo,i.Descripcion,u.Nombre AS Propietario,c.Nombre AS Competencia
FROM Iniciativas i JOIN Usuarios u ON u.UsuarioId=i.PropietarioId
LEFT JOIN IniciativaCompetencias ic ON ic.IniciativaId=i.IniciativaId
LEFT JOIN Competencias c ON c.CompetenciaId=ic.CompetenciaId
WHERE i.IniciativaId=@id;
```
- **JSON de ejemplo:**
```json
{"iniciativaId":1,"titulo":"Plataforma ambiental","descripcion":"Monitoreo de iniciativas","propietario":"Ana Mora","competencias":["React","SQL Server"]}
```
- **Respuestas:** 200 si existe; 404 si no existe; 400 para ID inválido.
- **Montaje:** agrupar filas por `IniciativaId` y convertir competencias en un arreglo sin duplicados.

## Ruta 2 — GET /api/usuarios/{id}/competencias
- **Autenticación:** no requiere sesión si el perfil es público; restringir en caso de datos privados.
- **Tablas:** Usuarios, UsuarioCompetencias, Competencias.
- **Consulta SQL:**
```sql
SELECT u.UsuarioId,u.Nombre,c.CompetenciaId,c.Nombre AS Competencia
FROM Usuarios u LEFT JOIN UsuarioCompetencias uc ON uc.UsuarioId=u.UsuarioId
LEFT JOIN Competencias c ON c.CompetenciaId=uc.CompetenciaId
WHERE u.UsuarioId=@id;
```
- **JSON de ejemplo:**
```json
{"usuarioId":1,"nombre":"Ana Mora","competencias":[{"competenciaId":1,"nombre":"React"},{"competenciaId":3,"nombre":"UX"}]}
```
- **Respuestas:** 200 con arreglo (posiblemente vacío); 404 si usuario inexistente; 400 si ID inválido.
- **Montaje:** agrupar filas del usuario y excluir competencias NULL del arreglo.

**Compatibilidad:** los identificadores y nombres de campos son coherentes con el modelo de prueba, pero se deben comparar con el contrato real de la API Express del Avance 2, no suministrado.
