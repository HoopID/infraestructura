# PROYECTO.md - HoopID

## 1. Definición Inicial del Objetivo Principal (Paso 1)
* **Nombre del Proyecto:** HoopID (Plataforma de Perfil Atleta y Métricas de Básquetbol)
* **Modalidad:** Individual
* **Problema que resuelve:** Permite a basquetbolistas organizar sus métricas físicas y de afiliación, llevar un control de sus entrenamientos de tiro con posibilidad de corregir errores, y registrar sus estadísticas de partidos mediante selecciones por fecha para visualizar su evolución mensual.
* **Qué hace la aplicación:** Centraliza la información del atleta (física y club/selección), calcula automáticamente promedios de partidos, porcentajes de efectividad en tiro y permite la edición o eliminación de registros previos con visualización de progreso mensual.

---

## 2. Límites, Alcances y Objetivos (Paso 2)

### Límites del Sistema
* **Dentro del alcance:** Autenticación JWT, gestión de perfil físico y afiliación (Club/Selección), CRUD completo (Crear, Leer, Editar, Borrar) de sesiones de tiro con calendario, CRUD completo de partidos (boxscore) con calendario, cálculo automático de promedios/efectividad y visualización de progreso mensual.
* **Fuera del alcance:** Tracking en vivo durante el partido, video-análisis por IA, integración con dispositivos wearable (relojes inteligentes), redes sociales o chat entre jugadores.

### Alcances Funcionales
* **Autenticación:** Registro e inicio de sesión seguro con contraseñas encriptadas y tokens JWT.
* **Perfil Atleta:** Modificación de datos físicos (altura, peso, envergadura, posición, mano hábil, salto vertical) y datos de afiliación deportiva (Club Actual, Selección Provincial/Nacional).
* **Entrenamiento Individual (CRUD Completo de Tiros):** Alta, lectura, modificación y eliminación de registros de tiro. Parámetros: fecha seleccionada mediante calendario (*Datepicker*), zona de tiro (libres, media distancia, triples), intentos totales y aciertos. Permite corregir errores o borrar sesiones erróneas.
* **Partidos Jugados (CRUD Completo de Boxscore):** Alta, lectura, modificación y eliminación de planillas de partidos. Parámetros: fecha mediante calendario (*Datepicker*), rival, minutos jugados, puntos, rebotes, asistencias, robos, tapones, pérdidas y faltas. Permite la actualización o eliminación de partidos mal cargados.
* **Dashboard y Evolución Mensual:** Ficha del Jugador estilo "Carta Atleta" con sus datos corporales y club/selección, junto a un filtro interactivo por mes/año para analizar el rendimiento acumulado.

### Alcances No Funcionales
* **Infraestructura:** Base de datos relacional PostgreSQL ejecutada en un contenedor Docker con volumen para persistencia de datos.
* **Backend:** Servicio REST desarrollado con 100% de paridad de endpoints en Node.js (Express) y Python (FastAPI).
* **Frontend:** Aplicación web desarrollada con 100% de paridad de vistas y flujos en React y Vue.js.
* **Control de Versiones:** Repositorio estructurado respetando la especificación *Conventional Commits* (`feat`, `fix`, `docs`, etc.).

### Objetivos Específicos y Medibles
* Implementar 2 servicios backend (Express y FastAPI) capaces de procesar operaciones de edición/borrado (`PUT`/`DELETE`) y responder con exactamente los mismos JSONs.
* Implementar 2 aplicaciones frontend (React y Vue) con modales/formularios para editar y confirmar la eliminación de registros cargados por error.
* Garantizar el inicio completo de la base de datos y su persistencia mediante `docker-compose up`.

---

## 3. Estrategia Multirepositorio y Planificación de Issues (Pasos 2 y 3)

El proyecto estará dividido en 5 repositorios independientes:

### 1. Repositorio: `hoopid-infra`
* **Issue #1 (Docker Compose & PostgreSQL):** Crear `docker-compose.yml` para levantar PostgreSQL en puerto `5432` con volúmenes persistentes.
* **Issue #2 (Esquema de BD):** Crear scripts SQL con las tablas `users`, `profiles` (incluyendo campos `club` y `selection`), `shooting_sessions` y `match_boxscores`.
* **Issue #3 (Documentación Central):** Incluir este archivo `PROYECTO.md` y el `README.md` con las instrucciones de la infraestructura.

### 2. Repositorio: `hoopid-backend-express`
* **Issue #1 (Setup & Conexión BD):** Estructurar Node.js/Express y conectar con la BD en Docker.
* **Issue #2 (Auth & JWT):** Implementar `/api/auth/register` y `/api/auth/login` con encriptación de claves y tokens JWT.
* **Issue #3 (CRUD Perfil):** Endpoints `GET` y `PUT` sobre `/api/profile` incluyendo campos de Club y Selección.
* **Issue #4 (CRUD Completo Tiros):** Endpoints `GET`, `POST`, `PUT` (edición) y `DELETE` (eliminación) en `/api/shooting-sessions`.
* **Issue #5 (CRUD Completo Boxscore & Métricas Mensuales):** Endpoints `GET`, `POST`, `PUT` y `DELETE` en `/api/matches`, más `/api/stats/monthly` (agrupamiento por mes).

### 3. Repositorio: `hoopid-backend-fastapi`
* **Issue #1 (Setup & Conexión BD):** Estructurar Python/FastAPI y conectar con la misma BD en Docker.
* **Issue #2 (Paridad Auth):** Replicar exactamente la autenticación y emisión de JWT de Express.
* **Issue #3 (Paridad Perfil):** Replicar `GET` y `PUT` sobre `/api/profile` agregando Club y Selección con Pydantic.
* **Issue #4 (Paridad CRUD Tiros):** Replicar endpoints de consulta, edición y borrado de tiros procesando % de efectividad.
* **Issue #5 (Paridad CRUD Boxscore & Métricas):** Replicar operaciones de actualización/borrado de partidos y consulta mensual con paridad total de JSON.

### 4. Repositorio: `hoopid-frontend-react`
* **Issue #1 (Setup & Router):** Inicializar app en React, React Router, Axios y manejo de tokens en localStorage.
* **Issue #2 (Vistas Auth):** Formularios de Login y Registro conectados a la API.
* **Issue #3 (Perfil & Carga/Edición Tiros):** Edición de perfil corporal/club y tabla de tiros con opciones de **editar, eliminar y seleccionar fecha por calendario**.
* **Issue #4 (Boxscore & Dashboard Mensual):** Carga y edición de planillas de partidos con calendario, modal de confirmación de borrado y Dashboard con filtro por mes.

### 5. Repositorio: `hoopid-frontend-vue`
* **Issue #1 (Setup & Router):** Inicializar app en Vue.js, Vue Router, Axios y manejo de tokens.
* **Issue #2 (Paridad Vistas Auth):** Replicar vistas y flujos de Login/Registro de React.
* **Issue #3 (Paridad Perfil & Tiros):** Replicar perfil (club/selección) y gestión de tiros (edición/eliminación) con **calendario**.
* **Issue #4 (Paridad Boxscore & Dashboard):** Replicar edición/borrado de partidos con **calendario** y Dashboard con filtro por mes garantizando paridad de UI.