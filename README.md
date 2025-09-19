# Guía de Uso del Módulo libro-tecnico

## Descripción General

El módulo `s-libro-tecnico.mkxl` proporciona estilos y configuraciones especializadas para la composición de libros técnicos en español usando ConTeXt LMTX. Incluye configuración tipográfica con fuente Erewhon, layout optimizado, elementos de contenido, páginas especiales y gestión de autores.

## Características Principales

- **Tipografía**: Fuente Erewhon con características avanzadas
- **Layout**: Optimizado para libros técnicos (170×240mm)
- **Idioma**: Configuración completa para español
- **Elementos**: Tablas, figuras, listas, notas al pie
- **Páginas especiales**: Portada, legal, colofón automáticos
- **Autores**: Gestión completa de autores y colaboradores
- **Modos**: PDF/A, imprenta, pantalla

## Uso Básico

### 1. Cargar el módulo

```tex
\usemodule[libro-tecnico]
```

### 2. Configurar variables del documento

```tex
\setupdocument[
  title={Título del Libro},
  subtitle={Subtítulo},
  autores={autor1,autor2},
  roles={autores}, % Rol colectivo de los autores
  afiliacion={Institución},
  fecha={2025},
  isbn={978-1234567890},
  isbne={978-1234567891},
  doi={123456},
  editorial={Editorial},
  editorialDireccion={Dirección},
  editorialTelefono={+57 1 234 5678},
  editorialUrl={www.editorial.com},
  editorialEmail={contacto@editorial.com},
  copyright={2025},
  edicion={Primera},
  ejemplares={1000},
  institucion={Universidad},
  biblioteca={Biblioteca Central},
  catalografica={Descripción catalográfica},
  tematicas={Temas del libro},
  CDD={123.45},
  CDDEdicion={23},
  inp={123456},
  logotipoinstitucion={logo.png},
  logotipofacultad={facultad.png},
  logotipoeditorial={editorial.png},
  colaboradores={colaborador1,colaborador2},
  reconocimiento={Reconocimiento como Universidad: Decreto 1345 del 15 de marzo de 1972. Reconocimiento como personería jurídica: Resolución 56 del 26 de abril de 1934 del Ministerio de Gobierno.},
  impresores={impresor},
]
```

### 3. Definir autores y colaboradores

```tex
% Definir autores
\defineautor[autor1][nombres={Juan},apellidos={Pérez}, rol={autor}]
\defineautor[autor2][nombres={María},apellidos={García}, rol={editora académica}]

% Definir colaboradores
\definecolaborador[colaborador1][rol={Editor},nombre={Ana López}]
\definecolaborador[colaborador2][rol={Diseñador},nombre={Carlos Ruiz}]
```

## Estructura del Documento

### Páginas Automáticas

El módulo genera automáticamente:

1. **Antetítulo**: Título y subtítulo
2. **Portadilla**: Portada principal con autores
3. **Página legal**: Información editorial y colaboradores
4. **Colofón**: Información técnica (al final)

### Capítulos

```tex
\startchapter[title={Introducción}][autores={{Juan Pérez},{María García}}]
Contenido del capítulo...
\stopchapter
```

### Secciones

```tex
\startsection[title={Sección Principal}]
Contenido de la sección...
\stopsection

\startsubsection[title={Subsección}]
Contenido de la subsección...
\stopsubsection
```

## Elementos de Contenido

### Tablas

```tex
% Tabla simple
\startxtable
  \startxtablehead
    \startxrow
      \startxcell Columna 1 \stopxcell
      \startxcell Columna 2 \stopxcell
    \stopxrow
  \stopxtablehead
  \startxtablebody
    \startxrow
      \startxcell Dato 1 \stopxcell
      \startxcell Dato 2 \stopxcell
    \stopxrow
  \stopxtablebody
\stopxtable
\propiat

% Tabla con marco
\startTABLE
  \NC Columna 1 \NC Columna 2 \NC\NR
  \NC Dato 1 \NC Dato 2 \NC\NR
\stopTABLE
\propia
```

### Figuras

```tex
\startfigure[location=here]
  \externalfigure[imagen.png][width=0.8\textwidth]
  \caption{Título de la figura}
  \propia % Esta macro produce "Fuente: elaboracíon propia"
\stopfigure
```

### Listas

```tex
% Lista con viñetas
\startitemize
  \item Primer elemento
  \item Segundo elemento
\stopitemize

% Lista enumerada
\startenumerate
  \item Primer elemento
  \item Segundo elemento
\stopenumerate

% Lista de descripción
\startdescription
  \item[Término] Definición del término
\stopdescription
```

### Notas al pie

```tex
Texto con nota al pie\footnote{Contenido de la nota}
```

## Modos de Compilación

### Modo Pantalla (por defecto)
```bash
context documento.tex
```

### Modo PDF/A
```bash
context --mode=pdfa documento.tex
```

### Modo Imprenta (produce marcas de corte)
```bash
context --mode=imprenta documento.tex
```

## Comandos Especializados

### Colores
```tex
\rojo{Texto en rojo}
\grisoscuro{Texto en gris oscuro}
\versalita{TEXTO EN VERSALITAS}
\osf{1234567890}  % Números old-style
```

### Espaciado
```tex
A \dosem  B   % 2em de espacio
A \tresem B   % 3em de espacio
A \doscm  B   % 2cm de espacio
```

### Kerning
```tex
\apretar{Texto}      % Kerning -0.01
\apretarmas{Texto}   % Kerning -0.02
\apretarmucho{Texto} % Kerning -0.03
```

## Personalización

### Colores personalizados
```tex
\definecolor[micolor][s=0.6]
\definehighlight[micolor][color=micolor]
```

### Espacios personalizados
```tex
\definehspace[miespacio][1.5em]
```

### Marcos personalizados
```tex
\defineframed[mimarco][
  frame=on,
  framecolor=rojo,
  rulethickness=2pt
]
```

## Filtros Externos

### Markdown
```tex
\startmarkdown
# Título en Markdown

Contenido en **markdown** con *énfasis*.
\stopmarkdown
```

## Variables de Documento Requeridas

Para que el módulo funcione correctamente, deben definirse estas variables:

- `title`: Título del libro
- `subtitle`: Subtítulo
- `autores`: Lista de autores
- `roles`: Roles de los autores
- `fecha`: Año de publicación
- `isbn`: ISBN impreso
- `isbne`: ISBN electrónico
- `editorial`: Nombre de la editorial

## Solución de Problemas

### Errores comunes

1. **Variable no definida**: Asegúrate de definir todas las variables requeridas
2. **Imagen no encontrada**: Verifica las rutas en `\setupexternalfigures`
3. **Autor no definido**: Define todos los autores con `\defineautor`

### Debugging

Para ver las variables definidas:
```tex
\showdocumentvariables
```

## Ejemplo Completo

```tex
\usemodule[libro-tecnico]

\setupdocument[
  title={Matemáticas Avanzadas},
  subtitle={Teoría y Aplicaciones},
  autores={autor1,autor2},
  roles={autores}, % Rol colectivo de los autores
  fecha={2025},
  isbn={978-1234567890},
  isbne={978-1234567891},
  editorial={Editorial Universitaria},
  editorialDireccion={Calle 123 #45-67},
  editorialTelefono={+57 1 234 5678},
  editorialUrl={www.editorial.edu},
  editorialEmail={contacto@editorial.edu},
  copyright={2025},
  edicion={Primera},
  ejemplares={1000},
  institucion={Universidad Nacional},
  biblioteca={Biblioteca Central},
  catalografica={Matemáticas -- Teoría},
  tematicas={Matemáticas, Álgebra, Análisis},
  CDD={510},
  CDDEdicion={23},
  inp={123456},
  logotipoinstitucion={logo-un.png},
  colaboradores={colaborador1},
  reconocimiento={Agradecemos a todos los colaboradores},
  impresores={impresor1},
]

\defineautor[autor1][nombres={Juan Carlos},apellidos={Pérez García}, rol={autor}]
\defineautor[autor2][nombres={María Elena},apellidos={Rodríguez López}, rol={editora académica}]
\definecolaborador[colaborador1][rol={Editor},nombre={Ana María Silva}]
\definecolaborador[impresor1][nombre={Impresiones del Norte}, rol={impresor}]

\starttext

\startchapter[title={Introducción}][autores={{Juan Carlos Pérez García},{María Elena Rodríguez López}}]

Este es un libro sobre matemáticas avanzadas que cubre teoría y aplicaciones.

\startsection[title={Conceptos Fundamentales}]

Los conceptos fundamentales incluyen:

\startitemize
  \item Álgebra lineal
  \item Análisis matemático
  \item Geometría diferencial
\stopitemize

\stopsection

\stopchapter

\stoptext
```

## Licencia

MIT License - Ver archivo LICENSE para más detalles.

## Soporte

Para reportar problemas o solicitar características, crear un issue en el repositorio del proyecto.
