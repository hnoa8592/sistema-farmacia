# Farmacia POS Backend

Sistema POS de farmacia multi-tenant con Spring Boot 3.x, Java 21 y PostgreSQL.

## Requisitos

- Java 21+
- Maven 3.9+
- Docker & Docker Compose

## Inicio rápido

### 1. Clonar y configurar variables de entorno

```bash
cp .env.example .env
# Editar .env con tus valores
```

### 2. Levantar la base de datos

```bash
docker-compose up -d
```

Servicios:
- PostgreSQL: `localhost:5432`
- pgAdmin: `http://localhost:5050` (admin@admin.com / admin)

### 3. Inicializar la base de datos

Conectar a PostgreSQL y ejecutar el script inicial:

```bash
docker exec -i farmacia-postgres psql -U postgres -d farmacia_pos < src/main/resources/db/01-init-public.sql
```

### 4. Ejecutar la aplicación

```bash
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

La API estará disponible en: `http://localhost:8080/api`

### 5. Crear el primer tenant

```bash
curl -X POST http://localhost:8080/api/admin/tenants \
  -H "Content-Type: application/json" \
  -d '{"nombre":"Farmacia Demo","schemaName":"farmacia_demo"}'
```

Esto crea automáticamente el schema con todas las tablas, recursos, perfiles y parámetros iniciales.

### 6. Cargar datos demo (opcional)

```bash
docker exec -i farmacia-postgres psql -U postgres -d farmacia_pos < src/main/resources/db/07-seed-data-demo.sql
```

Usuarios demo:
- `admin@demo.com` / `Admin1234`
- `supervisor@demo.com` / `Super1234`
- `cajero@demo.com` / `Cajero1234`

## Documentación API

Swagger UI disponible en: `http://localhost:8080/api/swagger-ui.html`

## Módulos

| Módulo | Endpoints base |
|--------|----------------|
| Auth | `/api/auth` |
| Tenants | `/api/admin/tenants` |
| Usuarios | `/api/usuarios` |
| Perfiles | `/api/perfiles` |
| Catálogos | `/api/catalogos` |
| Principios Activos | `/api/principios-activos` |
| Laboratorios | `/api/laboratorios` |
| Sucursales | `/api/sucursales` |
| Productos | `/api/productos` |
| Inventario | `/api/inventario` |
| Ventas | `/api/ventas` |
| Reportes | `/api/reportes` |
| Auditoría | `/api/auditoria` |
| Parámetros | `/api/parametros` |
