import {Component, OnInit, OnDestroy} from '@angular/core';
import {ConfirmationService, MessageService} from 'primeng/api';
import {Subject, debounceTime, distinctUntilChanged, switchMap, of, takeUntil} from 'rxjs';
import {InventarioService} from '../../inventario/services/inventario.service';
import {VentaService} from '../services/venta.service';
import {SucursalService} from '../../catalogos/services/sucursal.service';
import {ParametroService} from '../../parametros/services/parametro.service';
import {ItemCarrito, VentaRequest} from '../models/venta.model';
import {InventarioResponse} from '../../inventario/models/inventario.model';
import {TipoPrecio} from '../../inventario/models/producto-precio.model';
import {Sucursal} from '../../catalogos/models/sucursal.model';

@Component({
    selector: 'app-pos',
    templateUrl: './pos.component.html',
    styleUrls: ['./pos.component.scss'],
    providers: [ConfirmationService, MessageService]
})
export class PosComponent implements OnInit, OnDestroy {
    sucursales: Sucursal[] = [];
    sucursalSeleccionada = '';
    sugerencias: InventarioResponse[] = [];
    busquedaTexto: any = null;
    carrito: ItemCarrito[] = [];
    descuentoPorcentaje = 0;
    cargando = false;
    igvPorcentaje = 13;

    tiposPrecio = [
        {label: 'Unidad', value: 'UNIDAD' as TipoPrecio},
        {label: 'Tira', value: 'TIRA' as TipoPrecio},
        {label: 'Caja', value: 'CAJA' as TipoPrecio},
        {label: 'Fracción', value: 'FRACCION' as TipoPrecio}
    ];

    private busquedaSubject = new Subject<string>();
    private destroy$ = new Subject<void>();

    constructor(
        private inventarioService: InventarioService,
        private ventaService: VentaService,
        private sucursalService: SucursalService,
        private parametroService: ParametroService,
        private confirmationService: ConfirmationService,
        private messageService: MessageService
    ) {
    }

    ngOnInit(): void {
        this.cargarSucursales();
        this.cargarParametros();

        this.busquedaSubject.pipe(
            debounceTime(400),
            distinctUntilChanged(),
            switchMap(q => q.length >= 2
                ? this.inventarioService.getStock({
                    productoNombre: q,
                    sucursalId: this.sucursalSeleccionada,
                    soloConStock: true
                })
                : of([])),
            takeUntil(this.destroy$)
        ).subscribe(r => this.sugerencias = r);
    }

    ngOnDestroy(): void {
        this.destroy$.next();
        this.destroy$.complete();
    }

    cargarSucursales(): void {
        this.sucursalService.getSucursales().subscribe({
            next: s => {
                this.sucursales = s.filter(x => x.activo);
                if (this.sucursales.length > 0) this.sucursalSeleccionada = this.sucursales[0].id;
            },
            error: () => {
            }
        });
    }

    cargarParametros(): void {
        this.parametroService.getByClave('IVA_PORCENTAJE').subscribe({
            next: p => this.igvPorcentaje = parseFloat(p.valor) || 13,
            error: () => {
            }
        });
    }

    onBuscar(event: any): void {
        this.busquedaSubject.next(event.query ?? '');
    }

    /**
     * Called when the user selects a suggestion.
     * In PrimeNG 16, p-autoComplete emits the item directly (not {value: item}).
     */
    agregarAlCarrito(item: InventarioResponse): void {
        if (!item) return;

        // Clear the autocomplete input for the next search
        this.busquedaTexto = null;
        this.sugerencias = [];

        const existe = this.carrito.find(c => c.inventarioId === item.id);

        if (existe) {
            if (existe.cantidad < item.stockActual) {
                existe.cantidad++;
                existe.subtotal = +(existe.cantidad * existe.precioUnitario).toFixed(2);
                this.messageService.add({
                    severity: 'info',
                    summary: 'Cantidad actualizada',
                    detail: `${item.productoNombre}: ${existe.cantidad} unidades`,
                    life: 2000
                });
            } else {
                this.messageService.add({
                    severity: 'warn',
                    summary: 'Stock insuficiente',
                    detail: `Solo hay ${item.stockActual} unidades disponibles`,
                    life: 3000
                });
            }
            return;
        }

        const precioUnidad = item.precios?.find(p => p.tipoPrecio === 'UNIDAD')?.precio
            ?? item.precios?.[0]?.precio
            ?? 0;

        const nuevoItem: ItemCarrito = {
            inventarioId: item.id,
            loteId: item.loteId,
            productoId: item.productoId,
            productoNombre: item.productoNombre,
            numeroLote: item.numeroLote,
            fechaVencimiento: item.fechaVencimiento,
            sucursalId: item.sucursalId,
            tipoPrecio: 'UNIDAD',
            cantidad: 1,
            precioUnitario: precioUnidad,
            stockDisponible: item.stockActual,
            precios: item.precios,
            subtotal: +precioUnidad.toFixed(2)
        };

        this.carrito = [...this.carrito, nuevoItem];

        this.messageService.add({
            severity: 'success',
            summary: 'Producto agregado',
            detail: item.productoNombre,
            life: 2000
        });
    }

    cambiarTipoPrecio(item: ItemCarrito): void {
        const precio = item.precios?.find(p => p.tipoPrecio === item.tipoPrecio)?.precio;

        if (precio !== null && precio !== undefined){
            item.precioUnitario = precio;
            item.subtotal = +(item.cantidad * precio).toFixed(2);
        } else {
            this.messageService.add({
                severity: 'warn',
                summary: 'Precio no encontrado',
                detail: `No hay precio para ${item.tipoPrecio}`,
                life: 2000
            });
            item.subtotal = +(item.cantidad * item.precioUnitario).toFixed(2);
        }
    }

    actualizarSubtotal(item: ItemCarrito): void {
        if (item.cantidad < 1) item.cantidad = 1;
        if (item.cantidad > item.stockDisponible) item.cantidad = item.stockDisponible;
        item.subtotal = +(item.cantidad * item.precioUnitario).toFixed(2);
    }

    eliminarItem(item: ItemCarrito): void {
        this.carrito = this.carrito.filter(c => c !== item);
    }

    get subtotal(): number {
        return +this.carrito.reduce((acc, i) => acc + i.subtotal, 0).toFixed(2);
    }

    get descuentoMonto(): number {
        return +(this.subtotal * (this.descuentoPorcentaje / 100)).toFixed(2);
    }

    get igvMonto(): number {
        return +((this.subtotal - this.descuentoMonto) * (this.igvPorcentaje / 100)).toFixed(2);
    }

    get total(): number {
        return +(this.subtotal - this.descuentoMonto + this.igvMonto).toFixed(2);
    }

    get lotesProximosVencer(): ItemCarrito[] {
        const en30dias = new Date();
        en30dias.setDate(en30dias.getDate() + 30);
        return this.carrito.filter(i => i.fechaVencimiento && new Date(i.fechaVencimiento) <= en30dias);
    }

    confirmarVenta(): void {
        if (this.carrito.length === 0) return;
        if (!this.sucursalSeleccionada) {
            this.messageService.add({
                severity: 'warn',
                summary: 'Atención',
                detail: 'Seleccione una sucursal antes de confirmar',
                life: 3000
            });
            return;
        }

        const request: VentaRequest = {
            descuento: this.descuentoMonto,
            detalles: this.carrito.map(i => ({
                inventarioId: i.inventarioId,
                loteId: i.loteId,
                productoId: i.productoId,
                tipoPrecio: i.tipoPrecio,
                cantidad: i.cantidad,
                precioUnitario: i.precioUnitario
            }))
        };

        this.cargando = true;
        this.ventaService.crearVenta(request).subscribe({
            next: () => {
                this.messageService.add({
                    severity: 'success',
                    summary: 'Venta registrada',
                    detail: `Total S/ ${this.total.toFixed(2)} — venta realizada correctamente`,
                    life: 4000
                });
                this.limpiarCarrito();
                this.cargando = false;
            },
            error: (err) => {
                this.messageService.add({
                    severity: 'error',
                    summary: 'Error al registrar venta',
                    detail: err?.error?.message || 'No se pudo registrar la venta. Intente nuevamente.',
                    life: 5000
                });
                this.cargando = false;
            }
        });
    }

    cancelarVenta(): void {
        if (this.carrito.length === 0) return;
        this.confirmationService.confirm({
            message: '¿Desea cancelar la venta actual? Se perderán todos los ítems del carrito.',
            header: 'Cancelar Venta',
            icon: 'pi pi-exclamation-triangle',
            acceptLabel: 'Sí, cancelar',
            rejectLabel: 'No',
            acceptButtonStyleClass: 'p-button-danger',
            accept: () => {
                this.limpiarCarrito();
                this.messageService.add({
                    severity: 'info',
                    summary: 'Venta cancelada',
                    detail: 'El carrito fue vaciado',
                    life: 2000
                });
            }
        });
    }

    private limpiarCarrito(): void {
        this.carrito = [];
        this.descuentoPorcentaje = 0;
        this.busquedaTexto = null;
    }
}
