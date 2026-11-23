# Lista de verificación de rúbrica — Innovation Hub

Este documento permite comprobar el avance de los entregables de la Tarea 3 de Programación Web Avanzada.

Los estados distinguen entre documentación preparada, pruebas pendientes y requisitos que todavía necesitan evidencia.

## Estado de los criterios

| Criterio | Evidencia disponible | Estado |
|---|---|---|
| Laboratorios React del curso | Aplicación React de seguimiento de series funcional; laboratorios originales no adjuntos | Parcial: verificar correspondencia con los laboratorios |
| Diagrama entidad-relación | `docs/diagrama-relaciones.png` y `docs/modelo-datos.md` | Documentado |
| Descripción de las ocho tablas | `docs/modelo-datos.md`: columnas, tipos, nulabilidad, PK, FK, restricciones y borrado | Documentado |
| Migración MongoDB → SQL Server | `docs/modelo-datos.md`: seis pasos, orden de creación, correspondencia de IDs y validación | Plan documentado; migración real no ejecutada |
| Cinco consultas SQL | `docs/consultas.sql`: JOIN 1:N, JOIN N:M, GROUP BY, UPDATE/DELETE e INSERT rechazado | Documentadas; ejecución pendiente |
| Dos rutas GET | `docs/rutas.md`: contratos, tablas, SQL, JSON y códigos de respuesta | Diseñadas; no implementadas en ASP.NET Core |
| Investigación de EF Core | `docs/investigacion-efcore.md`: consultas relacionadas, relaciones N:M, paginación y fuentes oficiales | Documentado |
| Organización de repositorios | Carpetas `tarea-3-react` e `innovation-hub`, archivos README | Preparado localmente; publicación por verificar |
| Correspondencia con el Avance 2 | Modelo propuesto y referencias a una futura API | Pendiente: comparar con el esquema y código originales |
| Defensa individual | Código y documentación disponibles para estudiar | Pendiente: preparar explicación y modificaciones en vivo |

## Aspectos que requieren verificación

### 1. Laboratorios React

La aplicación de seguimiento de series se encuentra funcional y permite demostrar el uso de React y la comunicación con un servidor Express.

Sin embargo, debe verificarse que los ejercicios y componentes solicitados específicamente en los laboratorios del curso estén incluidos.

### 2. Base de datos SQL Server

El archivo `sql/schema.sql` define ocho tablas y contiene datos ficticios de prueba.

El diseño está documentado, pero todavía debe comprobarse su ejecución en SQL Server.

También deben ejecutarse las cinco consultas de `docs/consultas.sql` y contrastar los resultados con los ejemplos esperados.

### 3. Modelo de MongoDB

Las correspondencias entre MongoDB y SQL Server son propuestas de diseño.

Antes de presentar una equivalencia definitiva, es necesario compararlas con la estructura real utilizada en el Avance 2.

### 4. Rutas de API

Las rutas GET están definidas como contratos para una futura API ASP.NET Core.

El documento especifica las tablas involucradas, las consultas SQL y las respuestas JSON esperadas.

No se afirma que estas rutas ya estén implementadas.

### 5. Repositorios GitHub

Se deben comprobar los siguientes aspectos antes de la entrega:

- Existencia de los dos repositorios solicitados.
- Nombre y organización requeridos por el docente.
- Archivos README con instrucciones claras.
- Historial de commits descriptivos y progresivos.
- Participación de ambos integrantes, cuando corresponda.
- Exclusión de `node_modules`, `bin`, `obj` y archivos con información sensible.

### 6. Defensa individual

Cada integrante debe poder explicar:

- La estructura de la aplicación React y Express.
- El flujo de información entre frontend y backend.
- El modelo relacional y sus claves.
- Las consultas SQL y sus resultados esperados.
- Las decisiones de migración de MongoDB a SQL Server.
- Las rutas GET propuestas.
- Las decisiones técnicas relacionadas con Entity Framework Core.
- Los cambios básicos que podrían solicitarse durante la defensa.

## Conclusión

La documentación principal de Innovation Hub está preparada para su revisión académica.

Los pendientes más importantes son verificar la ejecución de SQL Server, contrastar el diseño con el Avance 2, comprobar los requisitos de los repositorios GitHub y preparar la defensa individual.

Ningún apartado se considera ejecutado o publicado únicamente por estar documentado.