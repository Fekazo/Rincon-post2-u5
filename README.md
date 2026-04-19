# Dio Lab — Unidad 5

App Flutter que consume la API pública [JSONPlaceholder](https://jsonplaceholder.typicode.com/)
usando Dio, Riverpod y json_serializable.

---

## Setup

### Requisitos
- Flutter SDK 3.19 o superior
- Dart 3.x (incluido con Flutter)
- VS Code con extensión Flutter/Dart o Android Studio con plugin Flutter

### Pasos
1. Clonar el repositorio.
2. Instalar dependencias:
```bash
flutter pub get
```
3. Generar código de serialización:
```bash
dart run build_runner build --delete-conflicting-outputs
```
4. Ejecutar la app:
```bash
flutter run
```

---

## Arquitectura

El proyecto sigue una separación en capas:

lib/
data/
remote/
dto/          → PostDto + mapper toDomain()
network/      → buildDioClient() con interceptors
service/      → PostService + AppError + mapDioError()
domain/
model/          → Post (modelo de dominio)
presentation/
providers/      → postsProvider (AsyncNotifier + paginación)
screens/        → PostsScreen (scroll infinito + pull-to-refresh)

---

## Estados de la UI

| Estado | Descripción |
|--------|-------------|
| `loading` | Muestra `CircularProgressIndicator` mientras carga la primera página |
| `data` | Muestra la lista de posts con scroll infinito y pull-to-refresh |
| `error` | Muestra mensaje de error tipado y botón "Reintentar" |
| vacío | Muestra mensaje cuando la API no retorna posts |

---

## Interceptor de autenticación

En `dio_client.dart` se configuraron dos interceptores:

- **Interceptor de headers**: agrega automáticamente `X-App-Version: 1.0.0` y
  `X-Platform: flutter` a cada request mediante `InterceptorsWrapper.onRequest`,
  simulando un cliente autenticado sin duplicar lógica en cada llamada.
- **Interceptor de errores**: centraliza el log de `DioException` en
  `onError` antes de propagarlos, facilitando la depuración.
- **`LogInterceptor`**: registra en consola cada request y response completos
  incluyendo body y headers, equivalente al `HttpLoggingInterceptor` de OkHttp.

---

## Flujo de implementación

1. **DTO + generación de código**: `PostDto` usa `@JsonSerializable` para
   deserializar el JSON de la API. El archivo `.g.dart` se genera con `build_runner`.
2. **Mapper DTO → Dominio**: la extension `PostDtoMapper.toDomain()` convierte
   `PostDto` a `Post`, truncando `body` a 100 caracteres en `excerpt`,
   desacoplando la capa de red de la presentación.
3. **Manejo de errores tipado**: `AppError` es una sealed class que representa
   cada falla posible. `mapDioError()` convierte `DioException` al error de
   dominio correspondiente según tipo y código HTTP.
4. **Paginación con Riverpod**: `PostsNotifier` extiende `AsyncNotifier` y
   acumula posts página a página en `fetchNextPage()`. El scroll infinito
   dispara la carga automáticamente al acercarse al final de la lista.
5. **Pull-to-refresh**: `refresh()` reinicia la página a 1 y reemplaza el
   estado completo, permitiendo actualizar la lista desde el inicio.---

## Estados de la UI

| Estado | Descripción |
|--------|-------------|
| `loading` | Muestra `CircularProgressIndicator` mientras carga la primera página |
| `data` | Muestra la lista de posts con scroll infinito y pull-to-refresh |
| `error` | Muestra mensaje de error tipado y botón "Reintentar" |
| vacío | Muestra mensaje cuando la API no retorna posts |

---

## Interceptor de autenticación

En `dio_client.dart` se configuraron dos interceptores:

- **Interceptor de headers**: agrega automáticamente `X-App-Version: 1.0.0` y
  `X-Platform: flutter` a cada request mediante `InterceptorsWrapper.onRequest`,
  simulando un cliente autenticado sin duplicar lógica en cada llamada.
- **Interceptor de errores**: centraliza el log de `DioException` en
  `onError` antes de propagarlos, facilitando la depuración.
- **`LogInterceptor`**: registra en consola cada request y response completos
  incluyendo body y headers, equivalente al `HttpLoggingInterceptor` de OkHttp.

---

## Flujo de implementación

1. **DTO + generación de código**: `PostDto` usa `@JsonSerializable` para
   deserializar el JSON de la API. El archivo `.g.dart` se genera con `build_runner`.
2. **Mapper DTO → Dominio**: la extension `PostDtoMapper.toDomain()` convierte
   `PostDto` a `Post`, truncando `body` a 100 caracteres en `excerpt`,
   desacoplando la capa de red de la presentación.
3. **Manejo de errores tipado**: `AppError` es una sealed class que representa
   cada falla posible. `mapDioError()` convierte `DioException` al error de
   dominio correspondiente según tipo y código HTTP.
4. **Paginación con Riverpod**: `PostsNotifier` extiende `AsyncNotifier` y
   acumula posts página a página en `fetchNextPage()`. El scroll infinito
   dispara la carga automáticamente al acercarse al final de la lista.
5. **Pull-to-refresh**: `refresh()` reinicia la página a 1 y reemplaza el
   estado completo, permitiendo actualizar la lista desde el inicio.