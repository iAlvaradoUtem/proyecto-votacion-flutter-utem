# Informe Técnico: Proyecto Vota UTEM

Este documento detalla las decisiones técnicas, la arquitectura y las soluciones implementadas en el desarrollo de la aplicación de votaciones.

---

## 1. Arquitectura Empleada

La aplicación se construyó siguiendo los principios de la **Arquitectura Limpia** (Clean Architecture), dividiendo el código en tres capas principales para asegurar la separación de responsabilidades, la mantenibilidad y la escalabilidad del proyecto:

* **Capa de Presentación:** Contiene toda la interfaz de usuario (pantallas y widgets) y la lógica de estado. Se utilizó el gestor de estado **Riverpod** para comunicar la UI con la lógica de negocio de forma reactiva y eficiente.
* **Capa de Dominio:** Define las reglas de negocio y los "contratos" (interfaces o clases abstractas) de los repositorios. Esta capa no tiene dependencias de Flutter ni de fuentes de datos externas.
* **Capa de Datos:** Implementa los contratos definidos en el dominio. Es responsable de la comunicación con fuentes de datos externas, como la API REST y el almacenamiento local (`SharedPreferences`).

---

## 2. Mapeo de Modelos

Para manejar los datos provenientes de la API, se crearon clases **modelo** en la capa de datos (dentro de `lib/data/models/`). Cada clase representa una estructura JSON específica definida en la documentación OpenAPI.

Por ejemplo, la clase `Encuesta` se mapea directamente desde el JSON de una encuesta, utilizando un factory constructor `fromJson` para la deserialización. Este enfoque garantiza un tipado seguro y evita errores al manejar los datos en la aplicación.

---

## 3. Manejo de Errores

Se implementó un sistema de manejo de errores robusto y centralizado:

* **Errores de Red y Servidor:** Se utilizó un **interceptor de Dio** para capturar errores HTTP a nivel global. Se prestó especial atención al código de estado **401 (No Autorizado)**, el cual se convierte en una excepción personalizada `SessionExpiredException`. La UI detecta esta excepción, notifica al usuario que su sesión ha expirado y lo redirige automáticamente a la pantalla de login.
* **Errores de Negocio:** Se manejan errores específicos de la API, como el intento de votar dos veces en la misma encuesta. La aplicación detecta la respuesta del servidor (en este caso, un error 500 con un mensaje específico) y muestra una notificación clara al usuario, como "Ya emitiste tu voto en esta encuesta".
* **Interfaz de Usuario:** Todas las pantallas que cargan datos utilizan widgets reutilizables para mostrar los estados de **carga**, **error (con botón de reintento)** y **datos vacíos**, cumpliendo con los requisitos de la rúbrica.

---

## 4. Medidas de Seguridad

* **Autenticación:** El flujo de inicio de sesión se gestiona de forma segura con **Firebase Authentication** y el proveedor de Google, garantizando la persistencia de la sesión.
* **Autorización en la API:** Para cada petición a la API que requiere autenticación, se utiliza un interceptor de Dio para añadir automáticamente el **Bearer Token (JWT)** del usuario en el encabezado `Authorization`. Esto asegura que solo los usuarios autenticados puedan acceder a los recursos protegidos.
* **Variables de Entorno:** Aunque en la versión final se utilizó un token estático para desarrollo, el proyecto está preparado con el paquete `flutter_dotenv` para manejar credenciales y claves de API de forma segura, sin exponerlas en el código fuente.

---

## 5. Resumen de Endpoints Utilizados

La aplicación implementa las siguientes llamadas a la API REST:

| Método | Endpoint                    | Descripción                                      |
| :----- | :-------------------------- | :----------------------------------------------- |
| `GET`  | `/v1/polls/`                | Obtiene la lista completa de encuestas disponibles. |
| `GET`  | `/v1/polls/{pollToken}`     | Obtiene el detalle de una encuesta específica.      |
| `POST` | `/v1/vote/election`         | Registra el voto de un usuario en una encuesta.     |
| `GET`  | `/v1/vote/{pollToken}/results` | Obtiene los resultados de una encuesta específica. |

---

## 6. Limitaciones y Decisiones de Diseño

Durante el desarrollo, se encontraron dos limitaciones clave en la API proporcionada que requirieron tomar decisiones de diseño específicas:

1.  **Validación de Token de Autenticación:** Se detectó que la API solo valida tokens JWT emitidos por un proyecto de Firebase específico, diferente al utilizado para el desarrollo. Para poder avanzar y construir la aplicación funcionalmente, se optó por **utilizar un token temporal estático válido** (obtenido manualmente en `https://api.sebastian.cl/`) en el interceptor de Dio. El código está preparado para cambiar a un token dinámico de Firebase con solo descomentar un bloque de código en el archivo `votacion_providers.dart`.
2.  **Historial de Votaciones:** La API no proporciona un endpoint para consultar el historial de votaciones de un usuario. Para cumplir con el requisito de la rúbrica, se implementó un **sistema de historial local utilizando `SharedPreferences`**. Después de que un voto es registrado exitosamente en la API, se guarda una referencia local en el dispositivo. Se informa al usuario en la pantalla de perfil que este historial es local y no está sincronizado con su cuenta en la nube.