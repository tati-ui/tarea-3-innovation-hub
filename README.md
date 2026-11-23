# Parte B — Innovation Hub

## Descripción del proyecto

Innovation Hub es una propuesta de diseño de base de datos relacional desarrollada para la Tarea 3 del curso Programación Web Avanzada de la Universidad Cenfotec.

El objetivo es diseñar una estructura en SQL Server que permita administrar usuarios, competencias, iniciativas, solicitudes de participación y equipos de trabajo.

La entrega incluye el modelo entidad-relación, la descripción de las tablas, un plan de migración desde MongoDB, consultas SQL, el diseño de dos rutas GET y una investigación sobre Entity Framework Core.

## 1. Estructura de archivos

```text
innovation-hub/
├── docs/
│   ├── consultas.sql
│   ├── diagrama-relaciones.png
│   ├── investigacion-efcore.md
│   ├── modelo-datos.md
│   ├── rubrica-verificacion.md
│   └── rutas.md
├── sql/
│   └── schema.sql
└── README.md
```

## 2. Modelo de base de datos

Se propone una base de datos relacional formada por ocho tablas:

| Tabla | Función |
|---|---|
| Usuarios | Almacena los usuarios de la plataforma |
| Competencias | Registra las habilidades disponibles |
| Iniciativas | Almacena los proyectos propuestos por los usuarios |
| Solicitudes | Registra las solicitudes de participación en iniciativas |
| Equipos | Organiza los equipos asociados a las iniciativas |
| UsuarioCompetencias | Relaciona usuarios con sus competencias |
| IniciativaCompetencias | Relaciona iniciativas con las competencias requeridas |
| EquipoMiembros | Relaciona equipos con sus integrantes |

Las últimas tres tablas representan relaciones muchos a muchos mediante claves primarias compuestas.

El diseño también utiliza claves foráneas y restricciones para proteger la integridad de los datos.

El diagrama se encuentra en `docs/diagrama-relaciones.png` y su explicación detallada en `docs/modelo-datos.md`.

## 3. Plan de migración de MongoDB a SQL Server

El documento `docs/modelo-datos.md` describe seis etapas:

1. Identificar las colecciones y sus campos.
2. Definir la correspondencia entre documentos y tablas.
3. Crear las tablas respetando el orden de las claves foráneas.
4. Conservar las asociaciones entre identificadores originales y nuevos.
5. Insertar los datos en el modelo relacional.
6. Verificar las relaciones y la integridad de los registros.

**Importante:** Se trata de un plan de migración documentado, no de una migración real ejecutada.

El esquema MongoDB original del Avance 2 no se encuentra disponible en esta entrega. Por ello, el modelo debe compararse con los documentos originales antes de afirmar una equivalencia definitiva.

## 4. Script de SQL Server

El archivo `sql/schema.sql` contiene:

- La definición de las ocho tablas.
- Las claves primarias y foráneas.
- Restricciones `UNIQUE` y `CHECK`.
- Las relaciones muchos a muchos.
- Datos ficticios para realizar pruebas.

### Ejecución opcional

Para probar el modelo:

1. Abrir SQL Server Management Studio o una herramienta compatible.
2. Crear una base de datos de prueba vacía.
3. Seleccionar esa base de datos.
4. Abrir `sql/schema.sql`.
5. Ejecutar el script.
6. Verificar la creación de las ocho tablas y sus datos.

El script debe ejecutarse sobre una base de datos de prueba, ya que utiliza identificadores y datos de ejemplo.

La ejecución en SQL Server no se ha verificado como parte de esta documentación.

## 5. Consultas SQL

El archivo `docs/consultas.sql` contiene cinco ejercicios:

| Consulta | Objetivo |
|---|---|
| 1 | Consultar iniciativas junto con sus propietarios mediante JOIN |
| 2 | Consultar competencias asociadas a iniciativas mediante una relación muchos a muchos |
| 3 | Contar solicitudes por iniciativa utilizando GROUP BY |
| 4 | Demostrar operaciones UPDATE y DELETE dentro de una transacción reversible |
| 5 | Comprobar el rechazo de un INSERT que incumple una clave foránea |

Cada ejercicio incluye comentarios y resultados esperados basados en los datos de prueba.

La consulta que provoca un error de clave foránea debe ejecutarse por separado.

## 6. Diseño de rutas GET

El documento `docs/rutas.md` presenta dos rutas propuestas para una futura API ASP.NET Core.

### GET /api/iniciativas/{id}

Permite consultar una iniciativa junto con su propietario y las competencias relacionadas.

Utiliza las tablas:

- Iniciativas.
- Usuarios.
- IniciativaCompetencias.
- Competencias.

### GET /api/usuarios/{id}/competencias

Permite consultar un usuario y sus competencias.

Utiliza las tablas:

- Usuarios.
- UsuarioCompetencias.
- Competencias.

Ambas rutas incluyen las consultas SQL correspondientes, ejemplos de respuesta JSON y códigos HTTP esperados.

**Estas rutas están diseñadas, pero no implementadas en una API ASP.NET Core dentro de Innovation Hub.**

## 7. Investigación de Entity Framework Core

El archivo `docs/investigacion-efcore.md` desarrolla tres temas:

1. Consulta de datos relacionados mediante `Select`, `Include` y `AsNoTracking`.
2. Representación de relaciones muchos a muchos mediante entidades intermedias y Fluent API.
3. Paginación eficiente mediante `Skip`, `Take` y paginación por clave.

Se incluyen ejemplos de C# relacionados con el modelo de Innovation Hub y referencias a la documentación oficial de Microsoft.

Los ejemplos son ilustrativos y no representan una implementación ejecutada.

## 8. Verificación de la entrega

Para revisar los materiales:

1. Abrir `docs/modelo-datos.md` y consultar el diagrama de relaciones.
2. Revisar las ocho tablas y sus restricciones.
3. Consultar el plan de migración.
4. Revisar `sql/schema.sql` y los datos ficticios.
5. Examinar las cinco consultas de `docs/consultas.sql`.
6. Revisar los contratos de API en `docs/rutas.md`.
7. Leer la investigación de EF Core.
8. Consultar `docs/rubrica-verificacion.md` para conocer los requisitos pendientes.

## 9. Alcance y limitaciones

Esta entrega presenta un diseño relacional documentado para Innovation Hub.

El modelo se basa en las entidades mencionadas en la consigna, debido a que no se dispone del esquema original de MongoDB del Avance 2.

Las consultas SQL y los resultados esperados están preparados para revisión, pero requieren ejecución en SQL Server para confirmar su funcionamiento.

La migración y las rutas ASP.NET Core se presentan como propuestas técnicas, no como procesos implementados y verificados.

## Conclusión

Innovation Hub reúne una propuesta estructurada de base de datos SQL Server y documentación técnica relacionada con el diseño de sistemas web.

El trabajo permite demostrar conocimientos sobre modelado relacional, integridad referencial, consultas SQL, migración de datos, diseño de API y Entity Framework Core.