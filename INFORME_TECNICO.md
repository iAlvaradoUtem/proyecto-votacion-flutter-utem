# Informe Tecnico: Proyecto Vota UTEM

Este documento detalla las decisiones tecnicas, la arquitectura y las soluciones implementadas en el desarrollo de la aplicacion de votaciones.

---

## 1. Arquitectura Empleada

[cite_start]La aplicacion se construyo siguiendo los principios de la **Arquitectura Limpia** (Clean Architecture), dividiendo el codigo en tres capas principales para asegurar la separacion de responsabilidades, la mantenibilidad y la escalabilidad del proyecto[cite: 17, 36, 27]:

* **Capa de Presentacion:** Contiene toda la interfaz de usuario (pantallas y widgets) y la logica de estado. Se utilizo el gestor de estado **Riverpod** para comunicar la UI con la logica de negocio de forma reactiva y eficiente.
* **Capa de Dominio:** Define las reglas de negocio y los "contratos" (interfaces o clases abstractas) de los repositorios. Esta capa no tiene dependencias de Flutter ni de fuentes de datos externas.
* **Capa de Datos:** Implementa los contratos definidos en el dominio. Es responsable de la comunicacion con fuentes de datos externas, como la API REST y el almacenamiento local (`SharedPreferences`).

Esta arquitectura permitio un desarrollo modular y facilitó la implementacion de pruebas unitarias aisladas.

---

## 2. Mapeo de Modelos

Para manejar los datos provenientes de la API, se crearon clases **modelo** en la capa de datos (dentro de `lib/data/models/`). [cite_start]Cada clase representa una estructura JSON especifica definida en la documentacion OpenAPI[cite: 18, 20].

Por ejemplo, la clase `Encuesta` se mapea directamente desde el JSON de una encuesta, utilizando un factory constructor `fromJson` para la deserializacion. Este enfoque garantiza un tipado seguro y evita errores al manejar los datos en la aplicacion.

---

## 3. Manejo de Errores

Se implemento un sistema de manejo de errores robusto y centralizado:

* **Errores de Red y Servidor:** Se utilizo un **interceptor de Dio** para capturar errores HTTP a nivel global. [cite_start]Se presto especial atencion al codigo de estado **401 (No Autorizado)**, el cual se convierte en una excepcion personalizada `SessionExpiredException`[cite: 15]. La UI detecta esta excepcion, notifica al usuario que su sesion ha expirado y lo redirige automaticamente a la pantalla de login.
* **Errores de Negocio:** Se manejan errores especificos de la API, como el intento de votar dos veces en la misma encuesta. [cite_start]La aplicacion detecta la respuesta del servidor (en este caso, un error 500 con un mensaje especifico) y muestra una notificacion clara al usuario, como "Ya emitiste tu voto en esta encuesta"[cite: 13, 15, 16].
* [cite_start]**Interfaz de Usuario:** Todas las pantallas que cargan datos utilizan widgets reutilizables para mostrar los estados de **carga**, **error (con boton de reintento)** y **datos vacios**, cumpliendo con los requisitos de la rubrica[cite: 15, 58].

---

## 4. Medidas de Seguridad

* [cite_start]**Autenticacion:** El flujo de inicio de sesion se gestiona de forma segura con **Firebase Authentication** y el proveedor de Google, garantizando la persistencia de la sesion[cite: 7, 9, 10, 29, 43].
* **Autorizacion en la API:** Para cada peticion a la API que requiere autenticacion, se utiliza un interceptor de Dio para anadir automaticamente el **Bearer Token (JWT)** del usuario en el encabezado `Authorization`. [cite_start]Esto asegura que solo los usuarios autenticados puedan acceder a los recursos protegidos[cite: 23].
* [cite_start]**Variables de Entorno:** Aunque en la version final se utilizo un token estatico para desarrollo, el proyecto esta preparado con el paquete `flutter_dotenv` para manejar credenciales y claves de API de forma segura, sin exponerlas en el codigo fuente[cite: 23, 44].

---

## 5. Resumen de Endpoints Utilizados

La aplicacion implementa las siguientes llamadas a la API REST:

| Metodo | Endpoint | Descripcion |
| :--- | :--- | :--- |
| `GET` | `/v1/polls/` | Obtiene la lista completa de encuestas disponibles. |
| `GET` | `/v1/polls/{pollToken}` | Obtiene el detalle de una encuesta especifica. |
| `POST` | `/v1/vote/election` | Registra el voto de un usuario en una encuesta. |
| `GET` | `/v1/vote/{pollToken}/results` | Obtiene los resultados de una encuesta especifica. |

---

## 6. Limitaciones y Decisiones de Diseno

Durante el desarrollo, se encontraron dos limitaciones clave en la API proporcionada que requirieron tomar decisiones de diseno especificas:

1.  **Validacion de Token de Autenticacion:** Se detecto que la API solo valida tokens JWT emitidos por un proyecto de Firebase especifico, diferente al utilizado para el desarrollo. Para poder avanzar y construir la aplicacion funcionalmente, se opto por **utilizar un token estatico valido** (obtenido manualmente) en el interceptor de Dio. El codigo esta preparado para cambiar a un token dinamico de Firebase con solo descomentar un bloque de codigo en el archivo `votacion_providers.dart`.
2.  **Historial de Votaciones:** La API no proporciona un endpoint para consultar el historial de votaciones de un usuario. Para cumplir con el requisito de la rubrica, se implemento un **sistema de historial local utilizando `SharedPreferences`**. Despues de que un voto es registrado exitosamente en la API, se guarda una referencia local en el dispositivo. Se informa al usuario en la pantalla de perfil que este historial es local y no esta sincronizado con su cuenta en la nube.