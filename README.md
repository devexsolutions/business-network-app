# Business Network App

Aplicación móvil Flutter para la red de networking empresarial. Conecta empresarios, facilita reuniones 1 a 1, gestiona recomendaciones de negocio y permite el seguimiento de oportunidades.

## 🚀 Características

- **Autenticación segura** con tokens JWT
- **Perfil profesional completo** estilo BNI
- **Red de contactos** con sistema de conexiones
- **Feed social** con posts y interacciones
- **Gestión de eventos** empresariales
- **Reuniones 1 a 1** con workflow completo
- **Recomendaciones de negocio** (A recomienda C a B)
- **Seguimiento detallado** de reuniones
- **Búsqueda avanzada** por palabras clave
- **Estadísticas** y métricas de actividad

## 🏗️ Arquitectura

### Estructura del proyecto:
```
lib/
├── core/
│   ├── constants/          # Constantes de la app
│   ├── services/           # Servicios (API, storage)
│   ├── router/             # Configuración de navegación
│   └── utils/              # Utilidades
├── data/
│   ├── models/             # Modelos de datos
│   ├── repositories/       # Repositorios
│   └── datasources/        # Fuentes de datos
└── presentation/
    ├── screens/            # Pantallas de la app
    ├── widgets/            # Widgets reutilizables
    └── providers/          # Providers de Riverpod
```

### Stack tecnológico:
- **Flutter** - Framework de desarrollo
- **Riverpod** - Gestión de estado
- **GoRouter** - Navegación
- **Dio** - Cliente HTTP
- **Flutter Secure Storage** - Almacenamiento seguro
- **JSON Serializable** - Serialización de datos

## 🛠️ Configuración

### Prerrequisitos:
- Flutter SDK (>=3.4.1)
- Dart SDK
- Android Studio / VS Code
- Dispositivo Android/iOS o emulador

### Instalación:

1. **Clonar el repositorio:**
```bash
git clone <repository-url>
cd business_network_app
```

2. **Instalar dependencias:**
```bash
flutter pub get
```

3. **Generar archivos de código:**
```bash
flutter packages pub run build_runner build
```

4. **Configurar la API:**
Edita `lib/core/constants/api_constants.dart` y cambia la `baseUrl`:
```dart
static const String baseUrl = 'http://TU_IP:8000/api';
```

5. **Ejecutar la aplicación:**
```bash
flutter run
```

## 📱 Pantallas principales

### Autenticación:
- **Login** - Inicio de sesión con email/contraseña
- **Registro** - Creación de cuenta nueva

### Principal:
- **Home** - Dashboard con estadísticas y acciones rápidas
- **Perfil** - Gestión del perfil profesional
- **Red** - Lista de conexiones y sugerencias
- **Eventos** - Eventos empresariales disponibles
- **Negocios** - Recomendaciones y oportunidades

### Funcionalidades específicas:
- **Reuniones 1 a 1** - Solicitar y gestionar reuniones
- **Recomendaciones** - Sistema de recomendaciones de negocio
- **Seguimientos** - Registro detallado de reuniones BNI

## 🔧 Configuración de desarrollo

### Variables de entorno:
Crea un archivo `.env` en la raíz del proyecto:
```
API_BASE_URL=http://localhost:8000/api
DEBUG_MODE=true
```

### Datos de prueba:
Para testing, usa estas credenciales:
- **Email:** juan@example.com
- **Contraseña:** password

### Comandos útiles:

```bash
# Análisis de código
flutter analyze

# Ejecutar tests
flutter test

# Generar código
flutter packages pub run build_runner build --delete-conflicting-outputs

# Limpiar proyecto
flutter clean && flutter pub get

# Construir para producción
flutter build apk --release
flutter build ios --release
```

## 🎨 Diseño

### Colores principales:
- **Primario:** #D32F2F (Rojo BNI)
- **Secundario:** #1976D2 (Azul)
- **Acento:** #FF9800 (Naranja)

### Tipografía:
- Material Design 3
- Fuente del sistema
- Escalado accesible (0.8x - 1.2x)

## 🔗 Integración con API

La app se conecta con la API Laravel desarrollada previamente:

### Endpoints principales:
- `POST /auth/login` - Autenticación
- `GET /profile` - Perfil del usuario
- `GET /users` - Lista de usuarios
- `GET /recommendations` - Recomendaciones
- `GET /follow-ups` - Seguimientos
- `GET /meetings` - Reuniones 1 a 1

### Autenticación:
- Tokens JWT almacenados de forma segura
- Renovación automática de tokens
- Logout automático en caso de token expirado

## 🧪 Testing

### Tipos de tests:
- **Unit tests** - Lógica de negocio
- **Widget tests** - Componentes UI
- **Integration tests** - Flujos completos

### Ejecutar tests:
```bash
# Todos los tests
flutter test

# Tests específicos
flutter test test/unit/
flutter test test/widget/
flutter test test/integration/
```

## 📦 Build y Deploy

### Android:
```bash
# Debug
flutter build apk --debug

# Release
flutter build apk --release
flutter build appbundle --release
```

### iOS:
```bash
# Debug
flutter build ios --debug

# Release
flutter build ios --release
```

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT.

## 🆘 Soporte

Para reportar bugs o solicitar nuevas funcionalidades, abre un issue en el repositorio.

---

**Desarrollado con ❤️ para la comunidad empresarial**# business_network_api
