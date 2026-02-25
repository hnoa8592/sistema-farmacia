import { NgModule } from '@angular/core';
import { ExtraOptions, RouterModule, Routes } from '@angular/router';
import { AppLayoutComponent } from './layout/app.layout.component';
import { AuthGuard } from './core/auth/auth.guard';

const routerOptions: ExtraOptions = {
    anchorScrolling: 'enabled'
};

const routes: Routes = [
    {
        path: '',
        redirectTo: 'dashboard',
        pathMatch: 'full'
    },
    {
        path: 'login',
        loadChildren: () => import('./features/login/login.module').then(m => m.LoginModule)
    },
    {
        path: '',
        component: AppLayoutComponent,
        canActivate: [AuthGuard],
        children: [
            {
                path: 'dashboard',
                loadChildren: () => import('./features/dashboard/dashboard.module').then(m => m.DashboardModule)
            },
            {
                path: 'ventas',
                loadChildren: () => import('./features/ventas/ventas.module').then(m => m.VentasModule)
            },
            {
                path: 'inventario',
                loadChildren: () => import('./features/inventario/inventario.module').then(m => m.InventarioModule)
            },
            {
                path: 'catalogos',
                loadChildren: () => import('./features/catalogos/catalogos.module').then(m => m.CatalogosModule)
            },
            {
                path: 'reportes',
                loadChildren: () => import('./features/reportes/reportes.module').then(m => m.ReportesModule)
            },
            {
                path: 'usuarios',
                loadChildren: () => import('./features/usuarios/usuarios.module').then(m => m.UsuariosModule)
            },
            {
                path: 'auditoria',
                loadChildren: () => import('./features/auditoria/auditoria.module').then(m => m.AuditoriaModule)
            },
            {
                path: 'parametros',
                loadChildren: () => import('./features/parametros/parametros.module').then(m => m.ParametrosModule)
            }
        ]
    },
    { path: 'auth', loadChildren: () => import('./demo/components/auth/auth.module').then(m => m.AuthModule) },
    { path: 'notfound', loadChildren: () => import('./demo/components/notfound/notfound.module').then(m => m.NotfoundModule) },
    { path: '**', redirectTo: '/dashboard' }
];

@NgModule({
    imports: [RouterModule.forRoot(routes, routerOptions)],
    exports: [RouterModule]
})
export class AppRoutingModule { }
