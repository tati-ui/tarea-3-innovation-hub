# Investigación breve: Entity Framework Core

## Introducción

Entity Framework Core (EF Core) es un ORM (*Object-Relational Mapper*) desarrollado por Microsoft que permite trabajar con bases de datos relacionales utilizando clases y objetos de C#.

En el proyecto Innovation Hub, EF Core podría utilizarse para conectar una futura API desarrollada con ASP.NET Core y la base de datos SQL Server.

Esta investigación responde tres preguntas relacionadas con la consulta de datos, las relaciones muchos a muchos y la paginación.

Los ejemplos utilizan las entidades del modelo relacional propuesto en `sql/schema.sql`. Son ejemplos de diseño y no representan una implementación existente.

---

## 1. ¿Cómo consultar datos relacionados utilizando Select, Include y AsNoTracking?

Entity Framework Core proporciona diferentes métodos para consultar información y recuperar datos relacionados.

### Select: proyección de datos

`Select` permite seleccionar únicamente los campos necesarios para una respuesta.

Esto evita recuperar columnas que no se utilizarán y facilita construir objetos de transferencia de datos (DTO).

**Ejemplo aplicado a Innovation Hub**

La ruta `GET /api/iniciativas/{id}` necesita mostrar una iniciativa, el nombre de su propietario y las competencias asociadas.

```csharp
// Consultar una iniciativa y proyectar los datos
// necesarios para una respuesta de solo lectura.

var iniciativa = await db.Iniciativas
    .AsNoTracking()
    .Where(i => i.IniciativaId == id)
    .Select(i => new
    {
        i.IniciativaId,
        i.Titulo,
        i.Descripcion,
        Propietario = i.Propietario.Nombre,

        Competencias = i.IniciativaCompetencias
            .Select(ic => ic.Competencia.Nombre)
            .ToList()
    })
    .SingleOrDefaultAsync();
```

En este ejemplo:

- `Where` filtra la iniciativa solicitada.
- `Select` define los campos que se devolverán.
- La propiedad `Propietario` obtiene el nombre del usuario asociado.
- La colección `Competencias` recupera los nombres de las competencias vinculadas.
- `SingleOrDefaultAsync` devuelve la iniciativa encontrada o `null` si no existe.

La consulta presupone que las entidades C# tienen configuradas las propiedades de navegación correspondientes.

### Include: carga de entidades relacionadas

`Include` permite cargar entidades relacionadas junto con la entidad principal.

Es útil cuando se necesitan objetos completos y sus relaciones, por ejemplo, para procesar información de una iniciativa junto con sus competencias.

```csharp
// Cargar una iniciativa y sus entidades relacionadas.

var iniciativa = await db.Iniciativas
    .Include(i => i.Propietario)
    .Include(i => i.IniciativaCompetencias)
        .ThenInclude(ic => ic.Competencia)
    .SingleOrDefaultAsync(i => i.IniciativaId == id);
```

En este caso, `Include` y `ThenInclude` permiten recuperar las entidades relacionadas.

Sin embargo, cargar múltiples relaciones puede incrementar el volumen de información recuperada.

Por esa razón, cuando una ruta GET necesita únicamente campos específicos, suele ser preferible utilizar una proyección con `Select`.

### AsNoTracking: consultas de solo lectura

`AsNoTracking` desactiva el seguimiento de cambios de las entidades recuperadas.

Esto puede reducir el consumo de memoria y el trabajo realizado por EF Core cuando los datos no serán modificados.

```csharp
// Consultar iniciativas sin seguimiento de cambios.

var iniciativas = await db.Iniciativas
    .AsNoTracking()
    .OrderBy(i => i.IniciativaId)
    .ToListAsync();
```

Este enfoque resulta apropiado para rutas GET que únicamente consultan información.

### Decisión técnica para Innovation Hub

Para la ruta `GET /api/iniciativas/{id}` se recomienda utilizar `Select` para construir una respuesta con los campos necesarios.

`AsNoTracking` es apropiado para consultas de lectura que materializan entidades; en proyecciones que no contienen entidades rastreables, puede ser redundante.

`Include` sería útil cuando se necesiten entidades completas con sus relaciones.

---

## 2. ¿Cómo representar relaciones muchos a muchos con atributos propios?

Una relación muchos a muchos ocurre cuando varios registros de una tabla pueden relacionarse con varios registros de otra.

En Innovation Hub existen tres relaciones de este tipo:

| Relación | Tabla intermedia |
|---|---|
| Usuarios ↔ Competencias | UsuarioCompetencias |
| Iniciativas ↔ Competencias | IniciativaCompetencias |
| Equipos ↔ Usuarios | EquipoMiembros |

### Relaciones muchos a muchos simples

Entity Framework Core permite configurar relaciones muchos a muchos utilizando propiedades de navegación y una tabla intermedia.

Cuando la relación no necesita atributos adicionales, EF Core puede administrar la entidad de unión de forma implícita.

### Relaciones con atributos propios

Cuando una relación necesita almacenar información adicional, conviene definir una entidad intermedia explícita.

Por ejemplo:

- `UsuarioCompetencias` podría incorporar un campo `Nivel` para indicar el dominio de una habilidad.
- `EquipoMiembros` podría incorporar un campo `FechaIngreso` para registrar cuándo se incorporó una persona al equipo.

Estos campos son ejemplos de posibles ampliaciones y **no existen en el esquema SQL actual**.

### Ejemplo de entidad intermedia en C#

```csharp
// Entidad que representa la relación entre
// un usuario y una competencia.

public class UsuarioCompetencia
{
    public int UsuarioId { get; set; }

    public int CompetenciaId { get; set; }

    public Usuario Usuario { get; set; } = null!;

    public Competencia Competencia { get; set; } = null!;
}
```

Esta entidad representa la tabla `UsuarioCompetencias` definida en SQL Server.

### Configuración mediante Fluent API

La tabla utiliza una clave primaria compuesta por `UsuarioId` y `CompetenciaId`.

En Entity Framework Core, esta clave puede configurarse utilizando Fluent API:

```csharp
// Configurar la clave primaria compuesta
// de la tabla UsuarioCompetencias.

modelBuilder.Entity<UsuarioCompetencia>()
    .HasKey(uc => new
    {
        uc.UsuarioId,
        uc.CompetenciaId
    });
```

También es posible configurar explícitamente las relaciones con las entidades principales:

```csharp
// Configurar las claves foráneas y relaciones.

modelBuilder.Entity<UsuarioCompetencia>()
    .HasOne(uc => uc.Usuario)
    .WithMany(u => u.UsuarioCompetencias)
    .HasForeignKey(uc => uc.UsuarioId)
    .OnDelete(DeleteBehavior.NoAction);

modelBuilder.Entity<UsuarioCompetencia>()
    .HasOne(uc => uc.Competencia)
    .WithMany(c => c.UsuarioCompetencias)
    .HasForeignKey(uc => uc.CompetenciaId)
    .OnDelete(DeleteBehavior.NoAction);
```

Estas configuraciones presuponen que las clases `Usuario` y `Competencia` incluyen las propiedades de navegación indicadas.

`DeleteBehavior.NoAction` permite mantener el comportamiento de eliminación establecido en el esquema SQL Server del proyecto.

### Decisión técnica para Innovation Hub

Se propone utilizar entidades intermedias explícitas para las tres relaciones muchos a muchos.

Aunque actualmente no almacenan atributos adicionales, esta decisión facilita controlar las claves compuestas, configurar las relaciones y ampliar el modelo en el futuro.

---

## 3. ¿Cómo implementar paginación eficiente desde la base de datos?

La paginación permite dividir una colección de resultados en páginas para evitar recuperar todos los registros en una sola consulta.

En una aplicación como Innovation Hub, esto sería útil para mostrar listas de iniciativas, usuarios o solicitudes.

### Paginación con Skip y Take

Entity Framework Core permite implementar paginación utilizando:

- `OrderBy`: establece un orden estable.
- `Skip`: omite una cantidad determinada de registros.
- `Take`: limita la cantidad de registros recuperados.

En SQL Server, esta consulta suele traducirse a instrucciones que utilizan `OFFSET` y `FETCH`.

### Ejemplo aplicado a Innovation Hub

```csharp
// Obtener la segunda página de iniciativas.
// Cada página contiene 10 registros.

int pagina = 2;
int cantidadPorPagina = 10;

var iniciativas = await db.Iniciativas
    .AsNoTracking()
    .OrderBy(i => i.IniciativaId)
    .Skip((pagina - 1) * cantidadPorPagina)
    .Take(cantidadPorPagina)
    .ToListAsync();
```

**Explicación:**

- `pagina = 2`: solicita la segunda página.
- `cantidadPorPagina = 10`: establece un máximo de diez registros por página.
- `OrderBy`: ordena los registros por su identificador único.
- `Skip(10)`: omite los primeros diez registros.
- `Take(10)`: recupera como máximo los siguientes diez.

Con los tres registros ficticios actuales de `Iniciativas`, la segunda página estaría vacía. El ejemplo ilustra el funcionamiento para una base de datos con más registros.

### ¿Por qué no paginar en memoria?

No es recomendable recuperar todos los registros con `ToListAsync()` y después aplicar `Skip` y `Take` sobre la colección en memoria.

Ese procedimiento puede provocar un consumo innecesario de memoria y transferir más datos de los necesarios.

La paginación debe aplicarse antes de ejecutar la consulta, para que la base de datos procese el límite de resultados.

### Paginación por clave o keyset

Cuando existen muchas páginas, utilizar valores elevados en `Skip` puede resultar menos eficiente.

Una alternativa es la paginación por clave, también conocida como *keyset pagination*.

```csharp
// Recuperar las siguientes 20 iniciativas
// después del último identificador mostrado.

int ultimoId = 50;

var iniciativas = await db.Iniciativas
    .AsNoTracking()
    .Where(i => i.IniciativaId > ultimoId)
    .OrderBy(i => i.IniciativaId)
    .Take(20)
    .ToListAsync();
```

Este enfoque utiliza el último identificador mostrado para recuperar los siguientes registros.

Puede ser especialmente útil en interfaces con botones como «Cargar más» o navegación hacia la siguiente página.

### Decisión técnica para Innovation Hub

Para listas pequeñas o navegación por número de página, `Skip` y `Take` ofrecen una solución sencilla.

Para listas grandes o navegación secuencial, la paginación por clave puede ofrecer un mejor rendimiento.

En ambos casos es importante utilizar un orden único y estable para reducir el riesgo de repetir u omitir registros.

---

## Conclusión

Entity Framework Core ofrece herramientas para consultar datos relacionados, representar relaciones muchos a muchos y recuperar información de manera eficiente.

Para Innovation Hub, las principales decisiones propuestas son:

1. Utilizar `Select` para construir respuestas de API con los campos necesarios.
2. Utilizar `AsNoTracking` cuando corresponda en consultas de solo lectura.
3. Utilizar `Include` y `ThenInclude` cuando se necesiten entidades relacionadas completas.
4. Representar las relaciones muchos a muchos mediante entidades intermedias explícitas.
5. Configurar las claves primarias compuestas y las relaciones utilizando Fluent API.
6. Aplicar paginación en la base de datos mediante `OrderBy`, `Skip` y `Take`, o mediante paginación por clave cuando sea conveniente.

Estas decisiones son coherentes con el modelo relacional propuesto para SQL Server.

La investigación describe cómo podrían aplicarse estas herramientas en una futura API ASP.NET Core. No implica que Entity Framework Core ya esté implementado en el proyecto.

---

## Fuentes oficiales

La investigación se basa en la documentación de Microsoft Learn:

1. **Consultas con Entity Framework Core**  
   https://learn.microsoft.com/en-us/ef/core/querying/

2. **Carga de datos relacionados**  
   https://learn.microsoft.com/en-us/ef/core/querying/related-data/eager

3. **Consultas con seguimiento y sin seguimiento**  
   https://learn.microsoft.com/en-us/ef/core/querying/tracking

4. **Relaciones muchos a muchos**  
   https://learn.microsoft.com/en-us/ef/core/modeling/relationships/many-to-many

5. **Paginación**  
   https://learn.microsoft.com/en-us/ef/core/querying/pagination

6. **Migraciones de Entity Framework Core**  
   https://learn.microsoft.com/en-us/ef/core/managing-schemas/migrations/