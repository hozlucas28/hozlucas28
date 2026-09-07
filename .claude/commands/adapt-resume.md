Adapta el CV/Resume para que matchee con la siguiente Job Description (JD):

$ARGUMENTS

---

Segui estos pasos en orden:

## Paso 1: Detectar idioma del JD

Analiza el texto del JD de arriba y determina si esta escrito en **espanol** o **ingles**.

## Paso 2: Seleccionar archivo fuente

- Si el JD esta en **espanol**, el archivo fuente es `resumes/cv.yaml`.
- Si el JD esta en **ingles**, el archivo fuente es `resumes/resume.yaml`.

Lee el archivo fuente completo.

## Paso 3: Extraer nombre del puesto

Identifica el titulo/nombre del puesto de la vacante del JD. Este nombre se usara para:

- Nombrar la copia del archivo (en kebab-case, todo minusculas, sin caracteres especiales ni tildes).
- Reemplazar el campo `headline` del YAML.

## Paso 4: Crear copia del archivo

Copia el archivo fuente a `resumes/<nombre-del-puesto-en-kebab-case>.yaml` usando el comando `cp`.

## Paso 5: Modificar headline

En la copia creada, cambia el valor del campo `headline` para que sea exactamente el nombre del puesto de la vacante (en el idioma original del JD, con mayusculas normales de titulo).

## Paso 6: Comentar/Descomentar items

Analiza el JD y adapta **la copia** (nunca el archivo fuente) comentando o descomentando items en TODAS las secciones para maximizar el match con la JD. Las reglas son:

### Reglas de comentado/descomentado

- **Para comentar un item activo**: Agrega `# ` al inicio de CADA linea del item, manteniendo la indentacion original. Ejemplo:
  - Antes: `      - bullet: "texto"`
  - Despues: `      # - bullet: "texto"`

- **Para descomentar un item inactivo**: Elimina `# ` del inicio de CADA linea del item. Ejemplo:
  - Antes: `      # - bullet: "texto"`
  - Despues: `      - bullet: "texto"`

- Los items multi-linea (como proyectos, experiencias, publicaciones) requieren comentar/descomentar CADA linea individualmente.
- Respeta siempre la indentacion original.
- No modifiques el texto de ningun item, solo togglea su estado comentado/descomentado.

### Criterios de seleccion

Para cada seccion, decide que items activar o desactivar basandote en:

- **Relevancia directa**: El item menciona tecnologias, habilidades o experiencias que la JD pide explicitamente.
- **Relevancia indirecta**: El item demuestra competencias transferibles o complementarias a lo que la JD busca.
- **Evitar ruido**: Comenta items que no aportan valor para esta postulacion especifica o que podrian distraer del perfil buscado.

### Secciones adaptables

Todas las secciones del YAML son adaptables:

- **Perfil profesional / Professional profile**
- **Logros destacables / Notable achievements**
- **Experiencia / Experience** (experiencias completas y/o highlights individuales)
- **Proyectos / Projects**
- **Educacion / Education**
- **Certificados / Certificates**
- **Habilidades / Skills**
- **Publicaciones / Publications**
- **Reconocimientos y premios / Recognitions and awards**

## Paso 7: Generar PDF

Ejecuta el script de generacion con los argumentos correspondientes:

```bash
python3 scripts/generate-resumes.py --resume resumes/<nombre-del-puesto-en-kebab-case>.yaml --locale <IDIOMA>
```

Donde `<IDIOMA>` es `spanish` si el JD esta en espanol, o `english` si esta en ingles.

## Paso 8: Resumen

Muestra un resumen con:

- Idioma detectado.
- Archivo fuente utilizado.
- Nombre de la copia creada.
- Headline asignado.
- Cantidad de items activados y desactivados por seccion.
- Resultado de la generacion del PDF.
