Crea los módulos farmacéuticos dentro del proyecto Angular 16 existente
(plantilla Ultima NG + PrimeNG 16 ya inicializada en web-app/).
El backend corre en http://localhost:8080/api (Spring Boot 3.3.4 + JWT).

## STACK TECNOLÓGICO (respetar lo ya instalado)

- Angular 16 con NgModules (NO standalone components)
- PrimeNG 16 para todos los componentes UI
- PrimeFlex 3 para layout y utilidades CSS
- PrimeIcons 6 para íconos
- Plantilla Ultima NG ya instalada (layout/ y demo/ existen)
- HttpClient con interceptors
- Reactive Forms
- Chart.js 3 (ya disponible vía plantilla)

NO usar: Angular Material, TailwindCSS, Bootstrap.

---

## ESTRUCTURA DE CARPETAS A GENERAR

Dentro de src/app/ crear:

src/app/
├── core/
│   ├── auth/
│   │   ├── login/
│   │   │   ├── login.component.ts
│   │   │   ├── login.component.html    # Formulario: tenantId + email + password
│   │   │   └── login.component.scss
│   │   ├── auth.service.ts
│   │   ├── auth.guard.ts
│   │   └── models/
│   │       └── auth.model.ts
│   ├── interceptors/
│   │   └── auth.interceptor.ts         # Agrega Bearer + X-Tenant-ID header
│   └── services/
│       └── permission.service.ts
├── shared/
│   ├── directives/
│   │   └── permiso.directive.ts        # *appPermiso="'ventas:crear'"
│   ├── pipes/
│   │   └── estado-venta.pipe.ts
│   └── models/
│       └── api-response.model.ts
└── features/
    ├── dashboard/
    │   ├── dashboard.component.ts
    │   ├── dashboard.component.html
    │   ├── dashboard-routing.module.ts
    │   └── dashboard.module.ts
    ├── ventas/
    │   ├── pos/
    │   │   ├── pos.component.ts
    │   │   ├── pos.component.html
    │   │   └── pos.component.scss
    │   ├── historial/
    │   │   ├── historial-ventas.component.ts
    │   │   └── historial-ventas.component.html
    │   ├── models/
    │   │   ├── venta.model.ts
    │   │   └── detalle-venta.model.ts
    │   ├── services/
    │   │   └── venta.service.ts
    │   ├── ventas-routing.module.ts
    │   └── ventas.module.ts
    ├── inventario/
    │   ├── productos/
    │   │   ├── lista-productos.component.ts
    │   │   ├── lista-productos.component.html
    │   │   ├── form-producto/
    │   │   │   ├── form-producto.component.ts
    │   │   │   └── form-producto.component.html
    │   │   └── detalle-producto/
    │   │       ├── detalle-producto.component.ts
    │   │       └── detalle-producto.component.html
    │   ├── lotes/
    │   │   ├── lista-lotes.component.ts
    │   │   ├── lista-lotes.component.html
    │   │   └── form-lote.component.ts
    │   ├── precios/
    │   │   ├── lista-precios.component.ts
    │   │   └── form-precio.component.ts
    │   ├── movimientos/
    │   │   ├── movimientos.component.ts
    │   │   ├── movimientos.component.html
    │   │   └── form-movimiento.component.ts
    │   ├── stock/
    │   │   └── stock-actual.component.ts
    │   ├── alertas/
    │   │   └── alertas-inventario.component.ts
    │   ├── models/
    │   │   ├── producto.model.ts
    │   │   ├── producto-lote.model.ts
    │   │   ├── producto-precio.model.ts
    │   │   ├── inventario.model.ts
    │   │   └── movimiento.model.ts
    │   ├── services/
    │   │   ├── producto.service.ts
    │   │   ├── producto-lote.service.ts
    │   │   ├── producto-precio.service.ts
    │   │   └── inventario.service.ts
    │   ├── inventario-routing.module.ts
    │   └── inventario.module.ts
    ├── catalogos/
    │   ├── categorias/
    │   │   ├── categorias.component.ts
    │   │   └── categorias.component.html
    │   ├── formas/
    │   │   ├── formas.component.ts
    │   │   └── formas.component.html
    │   ├── vias/
    │   │   ├── vias.component.ts
    │   │   └── vias.component.html
    │   ├── principios-activos/
    │   │   ├── principios-activos.component.ts
    │   │   └── principios-activos.component.html
    │   ├── laboratorios/
    │   │   ├── laboratorios.component.ts
    │   │   ├── laboratorios.component.html
    │   │   └── form-laboratorio.component.ts
    │   ├── sucursales/
    │   │   ├── sucursales.component.ts
    │   │   ├── sucursales.component.html
    │   │   └── form-sucursal.component.ts
    │   ├── models/
    │   │   ├── catalogo.model.ts
    │   │   ├── principio-activo.model.ts
    │   │   ├── laboratorio.model.ts
    │   │   └── sucursal.model.ts
    │   ├── services/
    │   │   ├── catalogo.service.ts
    │   │   ├── principio-activo.service.ts
    │   │   ├── laboratorio.service.ts
    │   │   └── sucursal.service.ts
    │   ├── catalogos-routing.module.ts
    │   └── catalogos.module.ts
    ├── reportes/
    │   ├── reporte-ventas/
    │   │   ├── reporte-ventas.component.ts
    │   │   └── reporte-ventas.component.html
    │   ├── reporte-stock/
    │   │   ├── reporte-stock.component.ts
    │   │   └── reporte-stock.component.html
    │   ├── reporte-movimientos/
    │   │   └── reporte-movimientos.component.ts
    │   ├── models/
    │   │   ├── reporte-ventas.model.ts
    │   │   └── reporte-stock.model.ts
    │   ├── services/
    │   │   └── reporte.service.ts
    │   ├── reportes-routing.module.ts
    │   └── reportes.module.ts
    ├── usuarios/
    │   ├── gestion/
    │   │   ├── lista-usuarios.component.ts
    │   │   ├── lista-usuarios.component.html
    │   │   └── form-usuario.component.ts
    │   ├── perfiles/
    │   │   ├── lista-perfiles.component.ts
    │   │   ├── lista-perfiles.component.html
    │   │   └── form-perfil.component.ts
    │   ├── models/
    │   │   ├── usuario.model.ts
    │   │   ├── perfil.model.ts
    │   │   └── recurso.model.ts
    │   ├── services/
    │   │   ├── usuario.service.ts
    │   │   └── perfil.service.ts
    │   ├── usuarios-routing.module.ts
    │   └── usuarios.module.ts
    ├── auditoria/
    │   ├── lista-auditoria.component.ts
    │   ├── lista-auditoria.component.html
    │   ├── detalle-auditoria.component.ts
    │   ├── models/
    │   │   └── audit-log.model.ts
    │   ├── services/
    │   │   └── auditoria.service.ts
    │   ├── auditoria-routing.module.ts
    │   └── auditoria.module.ts
    └── parametros/
        ├── lista-parametros.component.ts
        ├── lista-parametros.component.html
        ├── models/
        │   └── parametro.model.ts
        ├── services/
        │   └── parametro.service.ts
        ├── parametros-routing.module.ts
        └── parametros.module.ts

---

## MODELOS TYPESCRIPT

### auth.model.ts
```typescript
interface LoginRequest {
  email: string;
  password: string;
  tenantId: string;
}

interface LoginResponse {
  token: string;
  email: string;
  nombre: string;
  recursos: string[];
}

interface JwtPayload {
  sub: string;         // email
  tenantId: string;
  userId: string;
  recursos: string[];
  exp: number;
}
```

### api-response.model.ts
```typescript
interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
  errors: string[] | null;
}

interface PageResponse<T> {
  content: T[];
  totalElements: number;
  totalPages: number;
  size: number;
  number: number;   // página actual (0-based)
}
```

### catalogo.model.ts
```typescript
// Shared para CategoriaTerapeutica, FormaFarmaceutica, ViaAdministracion
interface CatalogoDTO {
  id: string;
  nombre: string;
  descripcion: string | null;
  activo: boolean;
}
```

### principio-activo.model.ts
```typescript
interface PrincipioActivo {
  id: string;
  nombre: string;
  descripcion: string | null;
  activo: boolean;
}

interface ProductoPrincipioActivoDTO {
  id: string;
  principioActivoId: string;
  principioActivoNombre: string;
  concentracion: string | null;
}
```

### laboratorio.model.ts
```typescript
interface Laboratorio {
  id: string;
  nombre: string;
  pais: string | null;
  direccion: string | null;
  telefono: string | null;
  email: string | null;
  activo: boolean;
}
```

### sucursal.model.ts
```typescript
interface Sucursal {
  id: string;
  nombre: string;
  direccion: string;
  telefono: string | null;
  esMatriz: boolean;
  activo: boolean;
}
```

### producto.model.ts
```typescript
interface ProductoRequest {
  nombre: string;
  nombreComercial: string | null;
  codigo: string;
  codigoBarra: string | null;
  descripcion: string | null;
  concentracion: string | null;
  presentacion: string | null;
  requiereReceta: boolean;
  controlado: boolean;
  categoriaId: string;
  formaFarmaceuticaId: string;
  viaAdministracionId: string;
}

interface ProductoResponse {
  id: string;
  nombre: string;
  nombreComercial: string | null;
  codigo: string;
  codigoBarra: string | null;
  descripcion: string | null;
  concentracion: string | null;
  presentacion: string | null;
  requiereReceta: boolean;
  controlado: boolean;
  activo: boolean;
  categoriaNombre: string;
  formaFarmaceuticaNombre: string;
  viaAdministracionNombre: string;
  principiosActivos: ProductoPrincipioActivoDTO[];
  precios: ProductoPrecioDTO[];
}
```

### producto-lote.model.ts
```typescript
interface ProductoLoteRequest {
  laboratorioId: string;
  numeroLote: string;
  fechaFabricacion: string | null;   // ISO date "YYYY-MM-DD"
  fechaVencimiento: string;          // ISO date "YYYY-MM-DD"
  cantidadInicial: number;
  sucursalId: string;
}

interface ProductoLoteResponse {
  id: string;
  productoId: string;
  laboratorioId: string;
  laboratorioNombre: string;
  numeroLote: string;
  fechaFabricacion: string | null;
  fechaVencimiento: string;
  cantidadInicial: number;
  activo: boolean;
}
```

### producto-precio.model.ts
```typescript
type TipoPrecio = 'UNIDAD' | 'TIRA' | 'CAJA' | 'FRACCION';

interface ProductoPrecioDTO {
  id: string;
  productoId: string;
  tipoPrecio: TipoPrecio;
  precio: number;
  precioCompra: number | null;
  vigenciaDesde: string;      // ISO datetime
  vigenciaHasta: string | null;
  activo: boolean;
}
```

### inventario.model.ts
```typescript
interface InventarioResponse {
  id: string;
  loteId: string;
  sucursalId: string;
  sucursalNombre: string;
  productoId: string;
  productoNombre: string;
  numeroLote: string;
  fechaVencimiento: string;
  stockActual: number;
  stockMinimo: number;
  ubicacion: string | null;
}
```

### movimiento.model.ts
```typescript
type TipoMovimiento = 'ENTRADA' | 'SALIDA' | 'AJUSTE' | 'TRANSFERENCIA';

interface MovimientoRequest {
  inventarioId: string;
  cantidad: number;
  observacion: string | null;
}

interface MovimientoResponse {
  id: string;
  inventarioId: string;
  loteId: string;
  productoId: string;
  productoNombre: string;
  sucursalId: string;
  sucursalNombre: string;
  tipo: TipoMovimiento;
  cantidad: number;
  stockAnterior: number;
  stockResultante: number;
  fecha: string;
  usuarioId: string;
  observacion: string | null;
}
```

### venta.model.ts
```typescript
interface VentaRequest {
  detalles: DetalleVentaRequest[];
  descuento: number;
  // usuarioId NO se incluye: el backend lo extrae automáticamente del JWT Bearer token
}

interface DetalleVentaRequest {
  inventarioId: string;
  loteId: string;
  productoId: string;
  tipoPrecio: TipoPrecio;
  cantidad: number;
  precioUnitario: number;
}

interface VentaResponse {
  id: string;
  fecha: string;
  total: number;
  descuento: number;
  usuarioId: string;
  estado: 'COMPLETADA' | 'ANULADA';
  detalles: DetalleVentaResponse[];
}

interface DetalleVentaResponse {
  id: string;
  productoId: string;
  productoNombre: string;
  loteId: string;
  numeroLote: string;
  tipoPrecio: TipoPrecio;
  cantidad: number;
  precioUnitario: number;
  subtotal: number;
}

// Modelo local del carrito (no se envía al API tal cual)
interface ItemCarrito {
  inventarioId: string;
  loteId: string;
  productoId: string;
  productoNombre: string;
  numeroLote: string;
  fechaVencimiento: string;
  sucursalId: string;
  tipoPrecio: TipoPrecio;
  cantidad: number;
  precioUnitario: number;
  stockDisponible: number;
  subtotal: number;
}
```

### audit-log.model.ts
```typescript
type AccionAudit = 'CREAR' | 'EDITAR' | 'ELIMINAR' | 'VER' | 'LOGIN' | 'LOGOUT' | 'ANULAR';

interface AuditLogResponse {
  id: string;
  usuarioId: string;
  usuarioEmail: string;
  accion: AccionAudit;
  modulo: string;
  entidad: string;
  entidadId: string | null;
  valorAnterior: string | null;   // JSON string
  valorNuevo: string | null;      // JSON string
  descripcion: string;
  ipOrigen: string | null;
  userAgent: string | null;
  fecha: string;
  exitoso: boolean;
}

interface AuditFiltro {
  usuarioId?: string;
  modulo?: string;
  entidad?: string;
  accion?: AccionAudit;
  desde?: string;   // ISO datetime
  hasta?: string;   // ISO datetime
  page?: number;
  size?: number;
}
```

### parametro.model.ts
```typescript
type TipoParametro = 'STRING' | 'INTEGER' | 'DECIMAL' | 'BOOLEAN';

interface ParametroResponse {
  id: string;
  clave: string;
  valor: string;
  descripcion: string;
  tipo: TipoParametro;
  modulo: string;
  editable: boolean;
  activo: boolean;
  updatedAt: string;
  updatedBy: string;
}

interface ParametroRequest {
  valor: string;
}
```

### usuario.model.ts
```typescript
interface UsuarioRequest {
  nombre: string;
  email: string;
  password: string;
  activo: boolean;
}

interface UsuarioResponse {
  id: string;
  nombre: string;
  email: string;
  activo: boolean;
  createdAt: string;
  perfiles: PerfilResponse[];
}
```

### perfil.model.ts
```typescript
interface PerfilRequest {
  nombre: string;
  descripcion: string;
  recursosIds: string[];
}

interface PerfilResponse {
  id: string;
  nombre: string;
  descripcion: string;
  recursos: RecursoResponse[];
}
```

### recurso.model.ts
```typescript
interface RecursoResponse {
  id: string;
  nombre: string;   // ej: "ventas:crear"
  modulo: string;   // ej: "VENTAS"
}
```

---

## IMPLEMENTACIONES CLAVE

### auth.service.ts
```typescript
// Métodos requeridos:
login(request: LoginRequest): Observable<LoginResponse>
// Guarda en localStorage: token, email, nombre, tenantId, recursos[]
// Decodifica JWT para extraer tenantId del claim
logout(): void
// Limpia localStorage, redirige a /login
getToken(): string | null
getTenantId(): string
getRecursos(): string[]
isLoggedIn(): boolean  // verifica exp del JWT
```

### auth.interceptor.ts
```typescript
// Implementa HttpInterceptorFn o HttpInterceptor (para Angular 16 con NgModules)
// En intercept(): clona el request agregando:
//   Authorization: Bearer {token}
//   X-Tenant-ID: {tenantId}
// NO interceptar la ruta que contenga /auth/login
```

### auth.guard.ts
```typescript
// CanActivate: si !authService.isLoggedIn() → redirigir a /login
// CanMatch compatible con Angular 16
```

### permission.service.ts
```typescript
recursos$: BehaviorSubject<string[]>
tienePermiso(recurso: string): boolean
tieneAlgunPermiso(recursos: string[]): boolean
// Se sincroniza con los recursos del JWT al hacer login
```

### permiso.directive.ts
```typescript
// Directiva estructural: *appPermiso="'ventas:crear'"
// Si el usuario tiene el recurso: renderiza el elemento (ViewContainerRef.createEmbeddedView)
// Si no: ViewContainerRef.clear()
```

### estado-venta.pipe.ts
```typescript
// 'COMPLETADA' → 'Completada'
// 'ANULADA'    → 'Anulada'
```

---

## SERVICIOS HTTP

Cada servicio debe:
- Usar `HttpClient` tipado con `ApiResponse<T>`
- Retornar `Observable` extrayendo `.data` del `ApiResponse`
- Manejar errores con `catchError` y `throwError`
- El base URL se lee desde `environment.apiUrl` (http://localhost:8080/api)

### catalogo.service.ts
```
GET    /api/catalogos/categorias
POST   /api/catalogos/categorias
PUT    /api/catalogos/categorias/{id}
DELETE /api/catalogos/categorias/{id}

GET    /api/catalogos/formas-farmaceuticas
POST   /api/catalogos/formas-farmaceuticas
PUT    /api/catalogos/formas-farmaceuticas/{id}
DELETE /api/catalogos/formas-farmaceuticas/{id}

GET    /api/catalogos/vias-administracion
POST   /api/catalogos/vias-administracion
PUT    /api/catalogos/vias-administracion/{id}
DELETE /api/catalogos/vias-administracion/{id}
```

### principio-activo.service.ts
```
GET    /api/principios-activos          (params: nombre, page, size)
POST   /api/principios-activos
PUT    /api/principios-activos/{id}
DELETE /api/principios-activos/{id}
```

### laboratorio.service.ts
```
GET    /api/laboratorios                (params: nombre, pais, page, size)
POST   /api/laboratorios
PUT    /api/laboratorios/{id}
DELETE /api/laboratorios/{id}
```

### sucursal.service.ts
```
GET    /api/sucursales
POST   /api/sucursales
PUT    /api/sucursales/{id}
DELETE /api/sucursales/{id}
GET    /api/sucursales/{id}/inventario
```

### producto.service.ts
```
getProductos(page, size, filtros): Observable<PageResponse<ProductoResponse>>
  GET /api/productos (params: nombre, codigo, codigoBarra, categoriaId,
                      formaId, laboratorioId, principioActivoId,
                      requiereReceta, controlado, page, size)
getProductoById(id): Observable<ProductoResponse>
  GET /api/productos/{id}
buscarProductos(search): Observable<ProductoResponse[]>
  GET /api/productos?nombre={search}&size=20
crearProducto(request): Observable<ProductoResponse>
  POST /api/productos
editarProducto(id, request): Observable<ProductoResponse>
  PUT /api/productos/{id}
desactivarProducto(id): Observable<void>
  DELETE /api/productos/{id}
getProductosBajoStock(): Observable<ProductoResponse[]>
  GET /api/productos/bajo-stock
getProductosProximosVencer(): Observable<ProductoResponse[]>
  GET /api/productos/proximos-vencer
getProductosSinStock(): Observable<ProductoResponse[]>
  GET /api/productos/sin-stock

// Principios activos del producto
getPrincipiosActivos(productoId): Observable<ProductoPrincipioActivoDTO[]>
  GET /api/productos/{id}/principios-activos
asociarPrincipioActivo(productoId, paId, concentracion): Observable<void>
  POST /api/productos/{id}/principios-activos
desasociarPrincipioActivo(productoId, paId): Observable<void>
  DELETE /api/productos/{id}/principios-activos/{paId}
```

### producto-lote.service.ts
```
getLotes(productoId): Observable<ProductoLoteResponse[]>
  GET /api/productos/{id}/lotes
crearLote(productoId, request): Observable<ProductoLoteResponse>
  POST /api/productos/{id}/lotes
getLotesProximosVencer(productoId): Observable<ProductoLoteResponse[]>
  GET /api/productos/{id}/lotes/proximos-vencer
getLotesVencidos(productoId): Observable<ProductoLoteResponse[]>
  GET /api/productos/{id}/lotes/vencidos
```

### producto-precio.service.ts
```
getPrecios(productoId): Observable<ProductoPrecioDTO[]>
  GET /api/productos/{id}/precios
crearPrecio(productoId, request): Observable<ProductoPrecioDTO>
  POST /api/productos/{id}/precios
editarPrecio(productoId, precioId, request): Observable<ProductoPrecioDTO>
  PUT /api/productos/{id}/precios/{precioId}
desactivarPrecio(productoId, precioId): Observable<void>
  DELETE /api/productos/{id}/precios/{precioId}
```

### inventario.service.ts
```
getStock(filtros): Observable<InventarioResponse[]>
  GET /api/inventario/stock (params: productoId, sucursalId, loteId, productoNombre, soloConStock)
getMovimientos(page, size, filtros): Observable<PageResponse<MovimientoResponse>>
  GET /api/inventario/movimientos (params: productoId, sucursalId, loteId,
                                   tipo, usuarioId, desde, hasta)
registrarEntrada(request): Observable<MovimientoResponse>
  POST /api/inventario/entrada
registrarSalida(request): Observable<MovimientoResponse>
  POST /api/inventario/salida
registrarAjuste(inventarioId, stockNuevo, observacion): Observable<MovimientoResponse>
  POST /api/inventario/ajuste
```

### venta.service.ts
```
getVentas(page, size, filtros): Observable<PageResponse<VentaResponse>>
  GET /api/ventas (params: desde, hasta, estado, usuarioId)
getVentaById(id): Observable<VentaResponse>
  GET /api/ventas/{id}
crearVenta(request): Observable<VentaResponse>
  POST /api/ventas
anularVenta(id): Observable<void>
  PUT /api/ventas/{id}/anular
```

### reporte.service.ts
```
getReporteVentas(desde, hasta, usuarioId?, laboratorio?): Observable<any>
  GET /api/reportes/ventas
getProductosMasVendidos(desde, hasta): Observable<any[]>
  GET /api/reportes/productos-vendidos
getReporteStock(): Observable<any>
  GET /api/reportes/stock
getReporteMovimientos(desde, hasta): Observable<any[]>
  GET /api/reportes/movimientos
```

### usuario.service.ts
```
getUsuarios(page, size): Observable<PageResponse<UsuarioResponse>>
  GET /api/usuarios
crearUsuario(request): Observable<UsuarioResponse>
  POST /api/usuarios
editarUsuario(id, request): Observable<UsuarioResponse>
  PUT /api/usuarios/{id}
desactivarUsuario(id): Observable<void>
  DELETE /api/usuarios/{id}
asignarPerfiles(usuarioId, perfilesIds): Observable<void>
  POST /api/usuarios/{id}/perfiles
```

### perfil.service.ts
```
getPerfiles(): Observable<PerfilResponse[]>
  GET /api/perfiles
crearPerfil(request): Observable<PerfilResponse>
  POST /api/perfiles
editarPerfil(id, request): Observable<PerfilResponse>
  PUT /api/perfiles/{id}
asignarRecursos(perfilId, recursosIds): Observable<void>
  POST /api/perfiles/{id}/recursos
getRecursos(): Observable<RecursoResponse[]>
  GET /api/perfiles/recursos
```

### auditoria.service.ts
```
getLogs(filtros: AuditFiltro): Observable<PageResponse<AuditLogResponse>>
  GET /api/auditoria (params: usuarioId, modulo, entidad, accion, desde, hasta, page, size)
getLogById(id): Observable<AuditLogResponse>
  GET /api/auditoria/{id}
getHistorialEntidad(entidad, entidadId): Observable<AuditLogResponse[]>
  GET /api/auditoria/entidad/{entidad}/{entidadId}
getActividadUsuario(usuarioId): Observable<AuditLogResponse[]>
  GET /api/auditoria/usuario/{usuarioId}
getResumen(desde, hasta): Observable<any>
  GET /api/auditoria/resumen
```

### parametro.service.ts
```
getAll(): Observable<ParametroResponse[]>
  GET /api/parametros
getByModulo(modulo): Observable<ParametroResponse[]>
  GET /api/parametros/modulo/{modulo}
getByClave(clave): Observable<ParametroResponse>
  GET /api/parametros/{clave}
actualizar(clave, request: ParametroRequest): Observable<ParametroResponse>
  PUT /api/parametros/{clave}
```

---

## PANTALLAS Y COMPONENTES

### Login (core/auth/login)
- Formulario ReactiveForm con 3 campos usando p-inputText de PrimeNG:
  Empresa (tenantId), Email, Contraseña
- Botón "Ingresar" con p-button y [loading]="cargando"
- p-message de error si credenciales inválidas
- Diseño centrado con logo/nombre del sistema
- Al éxito: redirige a /dashboard

### Integración con Ultima NG Layout
- Usar el layout principal ya existente (app-layout del template Ultima NG)
- El sidebar (app-menu) debe mostrar solo los ítems según permisos:
  - Dashboard                            (todos los autenticados)
  - Ventas > POS / Historial             (requiere ventas:ver)
  - Inventario > Productos / Movimientos / Stock / Alertas
                                         (requiere inventario:ver)
  - Catálogos > Categorías / Formas / Vías / Principios Activos
                / Laboratorios / Sucursales
                                         (requiere catalogos:ver)
  - Reportes > Ventas / Stock / Movimientos
                                         (requiere reportes:ventas)
  - Usuarios > Gestión / Perfiles        (requiere usuarios:ver)
  - Auditoría                            (requiere auditoria:ver)
  - Parámetros                           (requiere parametros:ver)

El menú se configura en app.menu.service o donde Ultima NG lo gestione.
La propiedad del ítem visible se controla via PermissionService.

### Dashboard (features/dashboard)
- Tarjetas de resumen (p-card):
  - Total ventas del día
  - Productos con bajo stock (badge rojo con conteo)
  - Lotes por vencer en 30 días (badge amarillo)
  - Número de movimientos del día
- Gráfico de ventas últimos 7 días (p-chart tipo 'line' con Chart.js)
- Tabla de últimas 5 ventas del día (p-table sin paginación)
- Datos se obtienen de /api/reportes/ventas y /api/inventario/stock

### POS — pos.component.ts
Estado del componente:
- busqueda: string
- resultadosBusqueda: InventarioResponse[] (stock disponible)
- carrito: ItemCarrito[]
- sucursalSeleccionada: string (id de la sucursal activa)
- descuentoPorcentaje: number (visible solo con ventas:descuento)
- totalCalculado: number (computed a partir del carrito)
- cargando: boolean

Funcionalidades:
1. Selector de sucursal al inicio (p-dropdown con sucursales activas)
2. Input de búsqueda p-autoComplete con debounce 400ms →
   llama GET /api/inventario/stock?productoNombre={q}&sucursalId={id}&soloConStock=true
3. Al seleccionar ítem del autocomplete: agregar al carrito o incrementar cantidad
4. En cada fila del carrito (p-table editable):
   - p-dropdown para tipoPrecio (UNIDAD/TIRA/CAJA)
   - p-inputNumber para cantidad (max = stockDisponible)
   - precio unitario se actualiza automáticamente según tipoPrecio elegido
   - botón eliminar ítem (p-button icon="pi pi-trash")
5. Panel resumen:
   - Subtotal, descuento (p-inputNumber, solo si ventas:descuento),
     IVA (calculado con parámetro IVA_PORCENTAJE), total
6. Botón "Confirmar Venta" → POST /api/ventas → p-toast de éxito →
   limpiar carrito
7. Botón "Cancelar" limpia el carrito (con p-confirmDialog previo)
8. Alerta p-message si algún lote vence en < 30 días

### Historial de Ventas — historial-ventas.component.ts
- p-table paginada con columnas: Fecha, Usuario, Total, Descuento, Estado
- p-badge para estado: verde=COMPLETADA, rojo=ANULADA
- Filtros en toolbar: p-calendar rango de fechas, p-dropdown estado
- Botón "Ver detalle" → p-dialog con p-table de productos de la venta
- Botón "Anular" visible solo con *appPermiso="'ventas:anular'" →
  p-confirmDialog previo → PUT /api/ventas/{id}/anular

### Lista de Productos — lista-productos.component.ts
- p-table paginada (lazy loading, server-side) con columnas:
  Código, Nombre, Categoría, Forma, Requiere Receta, Controlado, Estado
- Fila con clase CSS 'bg-yellow-100' si hay lote próximo a vencer
- Fila con clase CSS 'bg-red-100' si stock <= stockMinimo
- p-toolbar con filtros: p-inputText buscar, p-dropdown categoría,
  p-multiSelect forma farmacéutica, p-toggleButton requiereReceta/controlado
- Botones con *appPermiso: Nuevo, Editar, Desactivar
- p-tabMenu o p-badge mostrando conteo de alertas (bajo stock / por vencer)
- Clic en fila abre detalle del producto

### Detalle Producto — detalle-producto.component.ts
- p-tabView con pestañas:
  1. "Datos Generales": campos del producto + principios activos (p-chips)
  2. "Lotes": p-table de lotes con columnas: Laboratorio, N° Lote,
     Fabricación, Vencimiento, Cantidad Inicial; botón "Nuevo Lote"
  3. "Precios": p-table de precios activos: Tipo, Precio, Compra,
     Vigencia; botón "Nuevo Precio" o "Editar"
  4. "Stock por Sucursal": p-table con Sucursal, N° Lote, Stock Actual,
     Stock Mínimo, Ubicación

### Formulario Producto — form-producto.component.ts
- p-dialog con ReactiveForm y validaciones:
  nombre: required
  codigo: required, validador async que llama GET /api/productos?codigo={v}
  categoriaId: required (p-dropdown)
  formaFarmaceuticaId: required (p-dropdown)
  viaAdministracionId: required (p-dropdown)
  requiereReceta, controlado: p-checkbox
- Modo crear y editar (recibe producto? como Input)

### Formulario Lote — form-lote.component.ts
- p-dialog con ReactiveForm:
  laboratorioId: required (p-dropdown)
  numeroLote: required
  fechaVencimiento: required, fecha futura (p-calendar)
  fechaFabricacion: opcional (p-calendar)
  cantidadInicial: required, min(1) (p-inputNumber)
  sucursalId: required (p-dropdown)
- Al guardar: POST /api/productos/{id}/lotes
- Automáticamente crea el Inventario en el backend

### Formulario Precio — form-precio.component.ts
- p-dialog con ReactiveForm:
  tipoPrecio: required (p-dropdown: UNIDAD/TIRA/CAJA/FRACCION)
  precio: required, min(0.01) (p-inputNumber mode="currency")
  precioCompra: opcional (p-inputNumber mode="currency")
  vigenciaDesde: required (p-calendar con hora)
- Al crear un precio para un tipo existente, el backend cierra el anterior

### Movimientos de Inventario — movimientos.component.ts
- p-table lazy con columnas: Fecha, Producto, Lote, Sucursal, Tipo,
  Cantidad, Stock Anterior, Stock Resultante, Usuario, Observación
- p-badge color por tipo: verde=ENTRADA, rojo=SALIDA, amarillo=AJUSTE,
  azul=TRANSFERENCIA
- Filtros: p-calendar desde/hasta, p-dropdown tipo, p-dropdown sucursal
- Botones flotantes (p-speedDial o p-button group):
  "Registrar Entrada", "Registrar Salida", "Ajustar Stock"
  (requieren *appPermiso="'inventario:movimientos'")
- Cada botón abre p-dialog con:
  inventarioId (p-dropdown autocomplete por producto+sucursal+lote),
  cantidad (p-inputNumber), observación (p-inputTextarea)

### Stock Actual — stock-actual.component.ts
- p-table con columnas: Producto, Lote, Sucursal, Vencimiento,
  Stock Actual, Stock Mínimo, Ubicación
- Fila roja si stockActual <= stockMinimo
- Fila amarilla si vencimiento <= 30 días
- Filtros: p-dropdown sucursal, p-toggleButton soloConStock

### Alertas de Inventario — alertas-inventario.component.ts
- p-tabView con 3 pestañas:
  1. "Bajo Stock": lista de InventarioResponse con stock crítico
  2. "Próximos a Vencer": lotes que vencen en <= DIAS_ALERTA_VENCIMIENTO
  3. "Sin Stock": productos sin ningún lote con stock > 0
- p-badge con conteo en cada pestaña
- p-button "Ver producto" en cada fila

### Catálogos (Categorías, Formas, Vías, Principios Activos)
- Componente genérico reutilizable con p-table + p-dialog
- Columnas: Nombre, Descripción, Activo
- Botones CRUD con *appPermiso="'catalogos:editar'"
- Soft delete: toggle del campo activo

### Laboratorios — laboratorios.component.ts
- p-table paginada con columnas: Nombre, País, Teléfono, Email, Activo
- p-dialog para crear/editar con campos: nombre, pais, direccion,
  telefono, email (todos con p-inputText o p-inputMask para teléfono)
- Requiere *appPermiso="'laboratorios:editar'"

### Sucursales — sucursales.component.ts
- p-table con columnas: Nombre, Dirección, Teléfono, Matriz, Activo
- p-badge "Matriz" para la sucursal con esMatriz=true
- p-dialog para crear/editar
- Requiere *appPermiso="'sucursales:editar'"

### Reportes — reporte-ventas.component.ts
- p-calendar rango desde/hasta, p-dropdown laboratorio (opcional)
- p-chart tipo 'bar' con ventas por día
- p-table con totales: Fecha, N° Ventas, Total Vendido
- Resumen en p-card: total período, promedio por venta,
  N° ventas, producto más vendido
- p-button "Exportar CSV" (construye CSV del lado cliente desde los datos)

### Reporte Stock — reporte-stock.component.ts
- p-dropdown sucursal para filtrar
- p-table: Producto, Código, Lote, Sucursal, Stock Actual, Stock Mínimo,
  Precio Unidad, Valor Total (stock × precio)
- Totales al pie de tabla
- Alertas resaltadas (bajo stock / vencimiento)

### Gestión Usuarios — lista-usuarios.component.ts
- p-table: Nombre, Email, Perfiles (p-chips), Activo
- p-dialog para crear: nombre, email, contraseña (p-password),
  perfiles (p-multiSelect de perfiles disponibles)
- p-dialog para editar: nombre, email, activo, perfiles
- Botón "Gestionar Perfiles" abre dialog con p-pickList de perfiles
- Requiere *appPermiso="'usuarios:ver'" / "'usuarios:crear'"

### Gestión Perfiles — lista-perfiles.component.ts
- p-dataView o p-table con nombre, descripción y recursos (p-chip por módulo)
- p-dialog para crear/editar perfil:
  nombre: required, descripcion: required
  recursos: p-tree o p-listbox con checkboxes agrupados por módulo
  (VENTAS, INVENTARIO, LABORATORIOS, SUCURSALES, CATALOGOS,
   PRINCIPIOS_ACTIVOS, REPORTES, USUARIOS, AUDITORIA, PARAMETROS)
- POST /api/perfiles/{id}/recursos con array de recursosIds
- Requiere *appPermiso="'perfiles:ver'" / "'perfiles:crear'"

### Auditoría — lista-auditoria.component.ts
- p-table lazy paginada con columnas: Fecha, Usuario, Acción,
  Módulo, Entidad, Descripción, IP, Éxito
- p-badge por acción: azul=CREAR, amarillo=EDITAR, rojo=ELIMINAR/ANULAR,
  verde=LOGIN, gris=VER
- Filtros: p-dropdown módulo, p-dropdown acción, p-calendar desde/hasta,
  p-inputText usuario
- Clic en fila → p-dialog "Detalle del Log" con:
  valorAnterior y valorNuevo mostrados en p-codeHighlight o p-scrollPanel
  con el JSON formateado (JSON.parse + JSON.stringify con indent)
- Requiere *appPermiso="'auditoria:ver'"

### Parámetros — lista-parametros.component.ts
- p-tabView con tabs por módulo (GENERAL, VENTAS, INVENTARIO, SISTEMA)
- Cada tab muestra p-table: Clave, Descripción, Valor, Tipo, Editable
- Para parámetros con editable=true: botón editar → p-inplace o
  p-dialog con input según tipo:
  - STRING: p-inputText
  - INTEGER/DECIMAL: p-inputNumber (currency="BOB" locale="es-BO" para montos)
  - BOOLEAN: p-toggleButton o p-inputSwitch
- PUT /api/parametros/{clave} con { valor: "..." }
- Requiere *appPermiso="'parametros:ver'" para ver
- Requiere *appPermiso="'parametros:editar'" para el botón editar

---

## ROUTING (app-routing.module.ts)

```typescript
const routes: Routes = [
  { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  {
    path: '',
    // Usar el MainLayout de Ultima NG (AppLayoutComponent)
    component: AppLayoutComponent,
    canActivate: [AuthGuard],
    children: [
      {
        path: 'dashboard',
        loadChildren: () => import('./features/dashboard/dashboard.module')
          .then(m => m.DashboardModule)
      },
      {
        path: 'ventas',
        loadChildren: () => import('./features/ventas/ventas.module')
          .then(m => m.VentasModule)
      },
      {
        path: 'inventario',
        loadChildren: () => import('./features/inventario/inventario.module')
          .then(m => m.InventarioModule)
      },
      {
        path: 'catalogos',
        loadChildren: () => import('./features/catalogos/catalogos.module')
          .then(m => m.CatalogosModule)
      },
      {
        path: 'reportes',
        loadChildren: () => import('./features/reportes/reportes.module')
          .then(m => m.ReportesModule)
      },
      {
        path: 'usuarios',
        loadChildren: () => import('./features/usuarios/usuarios.module')
          .then(m => m.UsuariosModule)
      },
      {
        path: 'auditoria',
        loadChildren: () => import('./features/auditoria/auditoria.module')
          .then(m => m.AuditoriaModule)
      },
      {
        path: 'parametros',
        loadChildren: () => import('./features/parametros/parametros.module')
          .then(m => m.ParametrosModule)
      }
    ]
  },
  { path: '**', redirectTo: 'dashboard' }
];
```

### Rutas por feature module:

ventas-routing.module.ts:
- /ventas/pos           → PosComponent
- /ventas/historial     → HistorialVentasComponent

inventario-routing.module.ts:
- /inventario/productos          → ListaProductosComponent
- /inventario/productos/:id      → DetalleProductoComponent
- /inventario/movimientos        → MovimientosComponent
- /inventario/stock              → StockActualComponent
- /inventario/alertas            → AlertasInventarioComponent

catalogos-routing.module.ts:
- /catalogos/categorias          → CategoriasComponent
- /catalogos/formas              → FormasComponent
- /catalogos/vias                → ViasComponent
- /catalogos/principios-activos  → PrincipiosActivosComponent
- /catalogos/laboratorios        → LaboratoriosComponent
- /catalogos/sucursales          → SucursalesComponent

reportes-routing.module.ts:
- /reportes/ventas               → ReporteVentasComponent
- /reportes/stock                → ReporteStockComponent
- /reportes/movimientos          → ReporteMovimientosComponent

usuarios-routing.module.ts:
- /usuarios/gestion              → ListaUsuariosComponent
- /usuarios/perfiles             → ListaPerfilesComponent

auditoria-routing.module.ts:
- /auditoria                     → ListaAuditoriaComponent

parametros-routing.module.ts:
- /parametros                    → ListaParametrosComponent

---

## CONFIGURACIÓN DEL ENTORNO

### environment.ts
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080/api'
};
```

### environment.prod.ts
```typescript
export const environment = {
  production: true,
  apiUrl: '/api'
};
```

### proxy.conf.json
```json
{
  "/api": {
    "target": "http://localhost:8080",
    "secure": false,
    "changeOrigin": true
  }
}
```
Configurar en angular.json: `"proxyConfig": "proxy.conf.json"`

---

## MÓDULOS PRIMENG NECESARIOS (importar en cada feature module)

Importar según uso:
- TableModule, PaginatorModule (p-table, p-paginator)
- ButtonModule, SplitButtonModule (p-button)
- InputTextModule, InputNumberModule, InputTextareaModule (p-inputText, etc.)
- DropdownModule, MultiSelectModule (p-dropdown, p-multiSelect)
- CalendarModule (p-calendar)
- DialogModule, ConfirmDialogModule (p-dialog, p-confirmDialog)
- ToastModule, MessageModule, MessagesModule (p-toast, p-message)
- TabViewModule (p-tabView)
- ChipModule, BadgeModule (p-chip, p-badge)
- CardModule (p-card)
- ToolbarModule (p-toolbar)
- AutoCompleteModule (p-autoComplete)
- CheckboxModule, ToggleButtonModule, InputSwitchModule
- PasswordModule (p-password)
- TagModule (p-tag)
- ProgressSpinnerModule (p-progressSpinner)
- ChartModule (p-chart) — solo en dashboard y reportes
- PickListModule (p-pickList) — en gestión de perfiles
- OverlayPanelModule (p-overlayPanel) — en POS para detalle de producto
- InplaceModule (p-inplace) — en parámetros
- ScrollPanelModule (p-scrollPanel) — en auditoría detalle
- SkeletonModule (p-skeleton) — para estados de carga

Todos importados en el CoreModule o en cada FeatureModule según scope.
ConfirmationService y MessageService proveídos en AppModule o CoreModule.

---

## CREDENCIALES DE PRUEBA (datos del seed del backend)

- admin@demo.com     / Admin1234   (tenantId: farmacia_demo) → perfil ADMIN
- supervisor@demo.com / Super1234  (tenantId: farmacia_demo) → perfil SUPERVISOR
- cajero@demo.com   / Cajero1234  (tenantId: farmacia_demo) → perfil CAJERO

---

## ARCHIVOS FINALES A GENERAR

- environment.ts y environment.prod.ts
- proxy.conf.json
- core/auth/* (login, service, guard, interceptor, models)
- core/services/permission.service.ts
- shared/directives/permiso.directive.ts
- shared/pipes/estado-venta.pipe.ts
- shared/models/api-response.model.ts
- features/**/* (todos los módulos descritos arriba)
- Actualizar app-routing.module.ts con las rutas de los features
- Actualizar el menú de Ultima NG (app.menu.service o equivalente)
  para incluir los ítems de navegación farmacéuticos con control de permisos
- README.md con pasos: instalar dependencias, configurar proxy,
  correr con ng serve, credenciales de prueba
