# Tu Aliado

Es una aplicación móvil desarrollada con Flutter que permite la gestión de prospectos, seguimiento
de actividades y sincronización local/remota. Está pensada para funcionar en entornos con
conectividad limitada, ofreciendo soporte offline mediante almacenamiento local con Hive.

---

## 🔧 Tecnologías utilizadas

- **Flutter** – Framework de UI multiplataforma
- **Dart** – Lenguaje de programación
- **BLoC** – Gestión de estado
- **Hive** – Almacenamiento local sin SQL
- **Dio** – Cliente HTTP robusto
- **Injectable + GetIt** – Inyección de dependencias modular
- **Flutter Navigator** – Navegación
- **Firebase Analytics** – Analítica de eventos
- **Shell Scripts** – Automatización de setup y build

## 🧱 Arquitectura

Este proyecto sigue una **arquitectura limpia y modular**, con separación clara de responsabilidades
entre:

modules/

├── api_source # Fuentes de datos remotos (API)

├── data # Repositorios y lógica de integración

├── db_source # Fuente de datos local (Hive)

├── domain # Casos de uso del dominio

├── models # Modelos de datos (DTOs y entidades)

└── user_interface # UI, lógica de presentación (Bloc), navegación


Otros directorios importantes:

- `scripts/` → Scripts para automatizar limpieza, generación de código y builds

---

## 🚀 Guia de inicio

### 1. Clonar el proyecto

```bash
git clone git@github.com:tuAliado/app-tualiado.git
cd app-tualiado
```

🧩 Características clave
🔐 Autenticación

📋 Registro de prospectos

📍 Geolocalización

🗂️ Sincronización offline con Hive

📡 Sincronización automática al detectar el inicio de sesión

🧩 Modular y altamente mantenible

## Ejecutar el menú de scripts para la configuración inicial

Despues de clonar el proyecto se debe obtener todos los paquetes y generar los archivos
complementarios de inyección de dependencias y serializable.
Para eso de creo una serie de script para automatizar el proceso que se encuentra en
#scripts/menu.sh.

Para automatizar el setup inicial del proyecto, ejecuta el menú de scripts:

```bash
sh scripts/menu.sh
```

| Paso | Opción  | Acción                                                        |
|------|---------|---------------------------------------------------------------|
| 1    | `2`     | Ejecuta `flutter pub get` en todos los módulos                |
| 2    | `4 → 1` | Corre `build_runner` para generar código en todos los módulos |

* Esto generará automáticamente:

- Archivos de inyección de dependencias (*.config.dart)

- Serializadores de modelos

- Adaptadores de Hive

- Código de injectable y json_serializable

## Scripts disponibles

| Nº | Script                 | Descripción                                                              |
|----|------------------------|--------------------------------------------------------------------------|
| 1  | `clean.sh`             | Limpia todos los módulos y el root (`flutter clean`)                     |
| 2  | `package_get.sh`       | Ejecuta `flutter pub get` en cada módulo                                 |
| 3  | `pub_upgrade.sh`       | Ejecuta `dart pub upgrade --major-versions`                              |
| 4  | `dart_build_runner.sh` | Corre el generador de código (`build_runner`) para `injectable`, Hive... |
| 5  | `gen_l10n.sh`          | Genera archivos de localización desde `user_interface`                   |
| 6  | `installers.sh`        | Genera artefactos Android/iOS/Web desde menú interactivo                 |
| -- | ---------------------- | ------------------------------------------------------------------------ |

💡 Puedes ejecutar estas opciones desde scripts/menu.sh seleccionando los números correspondientes.

## Inyección de dependencias

El proyecto utiliza get_it e injectable para la inyección de dependencias. Cada módulo contiene su
propia configuración di/ con un archivo *.module.dart donde se declaran las dependencias.

La configuración global se realiza en el archivo main.dart:

```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.init();                             // Inicializa Hive
  HiveTypeAdapterRegistrar.registerAll();              // Registra adaptadores Hive
  configureDependencies();                             // Ejecuta inyección global
  runApp(const BaseApp());                             // Lanza la aplicación
}
```


# Documentación técnica

## api_source
### Propósito: 
Encapsula toda la lógica relacionada con servicios web y consumo de APIs.

### Componentes clave:

- dio como cliente HTTP.

- interceptores.

- Archivos individuales por endpoint (authentication_api_source.dart, create_prospect_api_source.dart, etc).

Responsabilidad: Proveer datos desde el backend hacia los repositorios.

## user_interface

### Propósito: 
Encapsula toda la lógica de presentación y navegación.

### Componentes clave:
- blocs/: Estados y lógica de presentación por funcionalidad.

- pages/: Vistas por pantalla (ej. login_page.dart, home_page.dart).

- routes/: Mapeo central de rutas.

- resources/l10n: Traducciones e internacionalización.

Responsabilidad: Mostrar datos, recibir eventos del usuario y notificar al dominio.


## domain

### Propósito:
Define la lógica de negocio pura y los contratos de datos.

### Componentes clave:
- Casos de uso (create_prospect_use_case.dart).

- Interfaces de repositorios.

- Entidades de negocio puras.

Responsabilidad: Centralizar la lógica de negocio y facilitar testing.


## db_source

### Propósito:
Manejar almacenamiento local usando Hive.

### Componentes clave:
- adapters/: Adaptadores Hive para modelos.

- repositories/: Implementaciones locales de los repositorios del dominio.

- registrars/: Registro de adaptadores.

- hive_config.dart: Inicialización centralizada de Hive.

Responsabilidad: Almacenar y recuperar datos sin conexión.
