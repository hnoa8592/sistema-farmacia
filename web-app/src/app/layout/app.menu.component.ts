import { OnInit } from '@angular/core';
import { Component } from '@angular/core';
import { PermissionService } from 'src/app/core/services/permission.service';

@Component({
    selector: 'app-menu',
    templateUrl: './app.menu.component.html'
})
export class AppMenuComponent implements OnInit {

    model: any[] = [];

    constructor(private permissionService: PermissionService) {}

    ngOnInit() {
        this.model = this.buildMenu();

        // Re-build menu on permission changes (e.g., after login)
        this.permissionService.recursos$.subscribe(() => {
            this.model = this.buildMenu();
        });
    }

    private has(recurso: string): boolean {
        return this.permissionService.tienePermiso(recurso);
    }

    private hasAny(recursos: string[]): boolean {
        return this.permissionService.tieneAlgunPermiso(recursos);
    }

    private buildMenu(): any[] {
        const menu: any[] = [];

        // Dashboard - visible para todos los autenticados
        menu.push({
            label: 'Principal',
            icon: 'pi pi-home',
            items: [
                {
                    label: 'Dashboard',
                    icon: 'pi pi-fw pi-chart-pie',
                    routerLink: ['/dashboard']
                }
            ]
        });

        // Ventas
        if (this.hasAny(['ventas:ver', 'ventas:crear'])) {
            menu.push({
                label: 'Ventas',
                icon: 'pi pi-shopping-cart',
                items: [
                    {
                        label: 'Punto de Venta',
                        icon: 'pi pi-fw pi-shopping-cart',
                        routerLink: ['/ventas/pos']
                    },
                    {
                        label: 'Historial de Ventas',
                        icon: 'pi pi-fw pi-history',
                        routerLink: ['/ventas/historial']
                    }
                ]
            });
        }

        // Inventario
        if (this.hasAny(['inventario:ver', 'inventario:crear'])) {
            menu.push({
                label: 'Inventario',
                icon: 'pi pi-box',
                items: [
                    {
                        label: 'Productos',
                        icon: 'pi pi-fw pi-box',
                        routerLink: ['/inventario/productos']
                    },
                    {
                        label: 'Movimientos',
                        icon: 'pi pi-fw pi-arrows-v',
                        routerLink: ['/inventario/movimientos']
                    },
                    {
                        label: 'Stock Actual',
                        icon: 'pi pi-fw pi-database',
                        routerLink: ['/inventario/stock']
                    },
                    {
                        label: 'Alertas',
                        icon: 'pi pi-fw pi-bell',
                        routerLink: ['/inventario/alertas']
                    }
                ]
            });
        }

        // Catálogos
        if (this.hasAny(['catalogos:ver', 'catalogos:editar'])) {
            menu.push({
                label: 'Catálogos',
                icon: 'pi pi-list',
                items: [
                    {
                        label: 'Categorías',
                        icon: 'pi pi-fw pi-tags',
                        routerLink: ['/catalogos/categorias']
                    },
                    {
                        label: 'Formas Farmacéuticas',
                        icon: 'pi pi-fw pi-inbox',
                        routerLink: ['/catalogos/formas']
                    },
                    {
                        label: 'Vías de Administración',
                        icon: 'pi pi-fw pi-sitemap',
                        routerLink: ['/catalogos/vias']
                    },
                    {
                        label: 'Principios Activos',
                        icon: 'pi pi-fw pi-prime',
                        routerLink: ['/catalogos/principios-activos']
                    },
                    {
                        label: 'Laboratorios',
                        icon: 'pi pi-fw pi-building',
                        routerLink: ['/catalogos/laboratorios']
                    },
                    {
                        label: 'Sucursales',
                        icon: 'pi pi-fw pi-map-marker',
                        routerLink: ['/catalogos/sucursales']
                    }
                ]
            });
        }

        // Reportes
        if (this.hasAny(['reportes:ventas', 'reportes:ver'])) {
            menu.push({
                label: 'Reportes',
                icon: 'pi pi-chart-bar',
                items: [
                    {
                        label: 'Reporte de Ventas',
                        icon: 'pi pi-fw pi-chart-bar',
                        routerLink: ['/reportes/ventas']
                    },
                    {
                        label: 'Reporte de Stock',
                        icon: 'pi pi-fw pi-chart-line',
                        routerLink: ['/reportes/stock']
                    },
                    {
                        label: 'Movimientos',
                        icon: 'pi pi-fw pi-list',
                        routerLink: ['/reportes/movimientos']
                    }
                ]
            });
        }

        // Usuarios
        if (this.hasAny(['usuarios:ver', 'perfiles:ver'])) {
            menu.push({
                label: 'Usuarios',
                icon: 'pi pi-users',
                items: [
                    {
                        label: 'Gestión de Usuarios',
                        icon: 'pi pi-fw pi-users',
                        routerLink: ['/usuarios/gestion']
                    },
                    {
                        label: 'Perfiles',
                        icon: 'pi pi-fw pi-id-card',
                        routerLink: ['/usuarios/perfiles']
                    }
                ]
            });
        }

        // Auditoría
        if (this.has('auditoria:ver')) {
            menu.push({
                label: 'Auditoría',
                icon: 'pi pi-shield',
                items: [
                    {
                        label: 'Registro de Auditoría',
                        icon: 'pi pi-fw pi-shield',
                        routerLink: ['/auditoria']
                    }
                ]
            });
        }

        // Parámetros
        if (this.has('parametros:ver')) {
            menu.push({
                label: 'Sistema',
                icon: 'pi pi-cog',
                items: [
                    {
                        label: 'Parámetros',
                        icon: 'pi pi-fw pi-cog',
                        routerLink: ['/parametros']
                    }
                ]
            });
        }

        return menu;
    }
}
