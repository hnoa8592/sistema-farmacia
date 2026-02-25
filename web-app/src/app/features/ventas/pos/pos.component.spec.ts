import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { HttpClientTestingModule } from '@angular/common/http/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { of, throwError } from 'rxjs';
import { ConfirmationService, MessageService } from 'primeng/api';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { NO_ERRORS_SCHEMA } from '@angular/core';

import { PosComponent } from './pos.component';
import { InventarioService } from '../../inventario/services/inventario.service';
import { VentaService } from '../services/venta.service';
import { SucursalService } from '../../catalogos/services/sucursal.service';
import { ParametroService } from '../../parametros/services/parametro.service';
import { InventarioResponse } from '../../inventario/models/inventario.model';
import { VentaResponse } from '../models/venta.model';

// ────────────────────── helpers ──────────────────────

function makeInventario(overrides: Partial<InventarioResponse> = {}): InventarioResponse {
  return {
    id: 'inv-001',
    loteId: 'lote-001',
    sucursalId: 'suc-001',
    sucursalNombre: 'Sucursal Central',
    productoId: 'prod-001',
    productoNombre: 'Paracetamol 500mg',
    numeroLote: 'L2024-001',
    fechaVencimiento: '2026-12-31',
    stockActual: 100,
    stockMinimo: 10,
    ubicacion: null,
    precios: [
      { id: 'p1', productoId: 'prod-001', tipoPrecio: 'UNIDAD', precio: 2.50,
        precioCompra: 1.20, vigenciaDesde: '2024-01-01', vigenciaHasta: null, activo: true }
    ],
    ...overrides
  };
}

function makeVentaResponse(): VentaResponse {
  return {
    id: 'venta-001',
    fecha: new Date().toISOString(),
    total: 2.95,
    descuento: 0,
    usuarioId: 'user-001',
    estado: 'COMPLETADA',
    detalles: []
  };
}

// ────────────────────── suite ──────────────────────

describe('PosComponent', () => {
  let component: PosComponent;
  let fixture: ComponentFixture<PosComponent>;
  let inventarioSvc: jasmine.SpyObj<InventarioService>;
  let ventaSvc: jasmine.SpyObj<VentaService>;
  let sucursalSvc: jasmine.SpyObj<SucursalService>;
  let parametroSvc: jasmine.SpyObj<ParametroService>;
  let messageSvc: jasmine.SpyObj<MessageService>;

  beforeEach(async () => {
    inventarioSvc = jasmine.createSpyObj('InventarioService', ['getStock', 'getMovimientos']);
    ventaSvc      = jasmine.createSpyObj('VentaService',      ['crearVenta', 'getVentas', 'anularVenta']);
    sucursalSvc   = jasmine.createSpyObj('SucursalService',   ['getSucursales']);
    parametroSvc  = jasmine.createSpyObj('ParametroService',  ['getByClave']);
    messageSvc    = jasmine.createSpyObj('MessageService',    ['add']);

    sucursalSvc.getSucursales.and.returnValue(of([
      { id: 'suc-001', nombre: 'Central', direccion: '', telefono: '', activo: true, esMatriz: true }
    ]));
    parametroSvc.getByClave.and.returnValue(of({ id: '1', clave: 'IVA_PORCENTAJE', valor: '18', modulo: 'GENERAL', descripcion: '', tipo: 'DECIMAL' as const, editable: true, activo: true, updatedAt: '', updatedBy: '' }));
    inventarioSvc.getStock.and.returnValue(of([]));

    await TestBed.configureTestingModule({
      imports: [
        CommonModule,
        FormsModule,
        ReactiveFormsModule,
        HttpClientTestingModule,
        RouterTestingModule,
        NoopAnimationsModule
      ],
      declarations: [PosComponent],
      providers: [
        { provide: InventarioService, useValue: inventarioSvc },
        { provide: VentaService,      useValue: ventaSvc },
        { provide: SucursalService,   useValue: sucursalSvc },
        { provide: ParametroService,  useValue: parametroSvc }
      ],
      schemas: [NO_ERRORS_SCHEMA]
    })
    // Override component-level providers so our spies are used instead
    .overrideComponent(PosComponent, {
      set: {
        providers: [
          { provide: MessageService,    useValue: messageSvc },
          { provide: ConfirmationService, useClass: ConfirmationService }
        ]
      }
    })
    // Override template so [(ngModel)] on PrimeNG stubs don't cause NG01203
    .overrideTemplate(PosComponent, '<div></div>')
    .compileComponents();

    fixture   = TestBed.createComponent(PosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  // ── inicialización ──────────────────────────────────────────────

  describe('inicialización', () => {
    it('debe crear el componente', () => {
      expect(component).toBeTruthy();
    });

    it('debe cargar sucursales y seleccionar la primera', () => {
      expect(sucursalSvc.getSucursales).toHaveBeenCalled();
      expect(component.sucursalSeleccionada).toBe('suc-001');
    });

    it('debe cargar el parámetro de IGV', () => {
      expect(parametroSvc.getByClave).toHaveBeenCalledWith('IVA_PORCENTAJE');
      expect(component.igvPorcentaje).toBe(18);
    });

    it('debe iniciar con carrito vacío', () => {
      expect(component.carrito.length).toBe(0);
    });

    it('debe iniciar con descuento 0', () => {
      expect(component.descuentoPorcentaje).toBe(0);
    });
  });

  // ── búsqueda con debounce ────────────────────────────────────────

  describe('búsqueda de productos', () => {
    it('debe disparar búsqueda al recibir query de 2+ caracteres', fakeAsync(() => {
      const mockStock = [makeInventario()];
      inventarioSvc.getStock.and.returnValue(of(mockStock));

      component.onBuscar({ query: 'Par' });
      tick(400);

      expect(inventarioSvc.getStock).toHaveBeenCalledWith(
        jasmine.objectContaining({ productoNombre: 'Par', soloConStock: true })
      );
      expect(component.sugerencias).toEqual(mockStock);
    }));

    it('NO debe buscar si query tiene menos de 2 caracteres', fakeAsync(() => {
      inventarioSvc.getStock.calls.reset();
      component.onBuscar({ query: 'P' });
      tick(400);
      expect(inventarioSvc.getStock).not.toHaveBeenCalled();
      expect(component.sugerencias.length).toBe(0);
    }));

    it('debe incluir sucursalId en la búsqueda', fakeAsync(() => {
      inventarioSvc.getStock.and.returnValue(of([]));
      component.sucursalSeleccionada = 'suc-002';
      component.onBuscar({ query: 'Am' });
      tick(400);
      expect(inventarioSvc.getStock).toHaveBeenCalledWith(
        jasmine.objectContaining({ sucursalId: 'suc-002' })
      );
    }));
  });

  // ── agregar al carrito ───────────────────────────────────────────

  describe('agregarAlCarrito', () => {
    it('debe agregar un nuevo item con precio UNIDAD', () => {
      const inv = makeInventario();
      component.agregarAlCarrito(inv);

      expect(component.carrito.length).toBe(1);
      const item = component.carrito[0];
      expect(item.inventarioId).toBe('inv-001');
      expect(item.productoNombre).toBe('Paracetamol 500mg');
      expect(item.cantidad).toBe(1);
      expect(item.precioUnitario).toBe(2.50);
      expect(item.subtotal).toBe(2.50);
      expect(item.tipoPrecio).toBe('UNIDAD');
    });

    it('debe limpiar busquedaTexto después de agregar', () => {
      component.busquedaTexto = 'Para';
      component.agregarAlCarrito(makeInventario());
      expect(component.busquedaTexto).toBeNull();
    });

    it('debe incrementar cantidad si el producto ya está en el carrito', () => {
      const inv = makeInventario();
      component.agregarAlCarrito(inv);
      component.agregarAlCarrito(inv);

      expect(component.carrito.length).toBe(1);
      expect(component.carrito[0].cantidad).toBe(2);
    });

    it('NO debe superar el stock disponible al incrementar', () => {
      const inv = makeInventario({ stockActual: 1 });
      component.agregarAlCarrito(inv);
      component.agregarAlCarrito(inv); // intento de exceder stock

      expect(component.carrito[0].cantidad).toBe(1);
      expect(messageSvc.add).toHaveBeenCalledWith(
        jasmine.objectContaining({ severity: 'warn' })
      );
    });

    it('debe usar precio del primer elemento si no hay precio UNIDAD', () => {
      const inv = makeInventario({
        precios: [
          { id: 'p1', productoId: 'prod-001', tipoPrecio: 'CAJA', precio: 25.00,
            precioCompra: null, vigenciaDesde: '2024-01-01', vigenciaHasta: null, activo: true }
        ]
      });
      component.agregarAlCarrito(inv);
      expect(component.carrito[0].precioUnitario).toBe(25.00);
    });

    it('debe usar precio 0 si no hay precios definidos', () => {
      const inv = makeInventario({ precios: undefined });
      component.agregarAlCarrito(inv);
      expect(component.carrito[0].precioUnitario).toBe(0);
    });

    it('debe ignorar llamadas con item nulo/undefined', () => {
      component.agregarAlCarrito(null as any);
      expect(component.carrito.length).toBe(0);
    });

    it('debe mostrar toast de éxito al agregar nuevo producto', () => {
      component.agregarAlCarrito(makeInventario());
      expect(messageSvc.add).toHaveBeenCalledWith(
        jasmine.objectContaining({ severity: 'success' })
      );
    });
  });

  // ── operaciones sobre items del carrito ──────────────────────────

  describe('actualizarSubtotal', () => {
    it('debe recalcular subtotal al cambiar cantidad', () => {
      component.agregarAlCarrito(makeInventario());
      const item = component.carrito[0];
      item.cantidad = 3;
      component.actualizarSubtotal(item);
      expect(item.subtotal).toBe(7.50);
    });

    it('debe corregir cantidad menor a 1', () => {
      component.agregarAlCarrito(makeInventario());
      const item = component.carrito[0];
      item.cantidad = 0;
      component.actualizarSubtotal(item);
      expect(item.cantidad).toBe(1);
    });

    it('debe corregir cantidad mayor al stock disponible', () => {
      component.agregarAlCarrito(makeInventario({ stockActual: 5 }));
      const item = component.carrito[0];
      item.cantidad = 999;
      component.actualizarSubtotal(item);
      expect(item.cantidad).toBe(5);
    });
  });

  describe('eliminarItem', () => {
    it('debe eliminar el item del carrito', () => {
      component.agregarAlCarrito(makeInventario());
      component.agregarAlCarrito(makeInventario({ id: 'inv-002', productoNombre: 'Ibuprofeno' }));

      expect(component.carrito.length).toBe(2);
      component.eliminarItem(component.carrito[0]);
      expect(component.carrito.length).toBe(1);
      expect(component.carrito[0].productoNombre).toBe('Ibuprofeno');
    });
  });

  // ── cálculos de totales ──────────────────────────────────────────

  describe('cálculos de totales', () => {
    beforeEach(() => {
      component.agregarAlCarrito(makeInventario());                          // S/ 2.50
      component.agregarAlCarrito(makeInventario({ id: 'inv-002',
        productoNombre: 'Ibuprofeno',
        precios: [{ id: 'p2', productoId: 'prod-002', tipoPrecio: 'UNIDAD',
          precio: 7.50, precioCompra: null, vigenciaDesde: '2024-01-01',
          vigenciaHasta: null, activo: true }]
      }));                                                                    // S/ 7.50
    });

    it('subtotal debe sumar los subtotales de todos los items', () => {
      expect(component.subtotal).toBe(10.00);
    });

    it('descuentoMonto debe calcularse sobre el subtotal', () => {
      component.descuentoPorcentaje = 10;
      expect(component.descuentoMonto).toBe(1.00);
    });

    it('igvMonto debe aplicarse sobre (subtotal - descuento)', () => {
      component.descuentoPorcentaje = 0;
      component.igvPorcentaje = 18;
      // 10.00 * 0.18 = 1.80
      expect(component.igvMonto).toBe(1.80);
    });

    it('total = subtotal - descuento + igv', () => {
      component.descuentoPorcentaje = 0;
      component.igvPorcentaje = 18;
      expect(component.total).toBe(11.80);
    });

    it('total con descuento y IGV', () => {
      component.descuentoPorcentaje = 10;
      component.igvPorcentaje = 18;
      // subtotal=10, desc=1, base=9, igv=1.62, total=10.62
      expect(component.total).toBe(10.62);
    });
  });

  // ── lotes próximos a vencer ──────────────────────────────────────

  describe('lotesProximosVencer', () => {
    it('debe detectar items con vencimiento en ≤ 30 días', () => {
      const en15dias = new Date();
      en15dias.setDate(en15dias.getDate() + 15);
      const inv = makeInventario({ fechaVencimiento: en15dias.toISOString().split('T')[0] });
      component.agregarAlCarrito(inv);
      expect(component.lotesProximosVencer.length).toBe(1);
    });

    it('NO debe marcar items con vencimiento lejano', () => {
      component.agregarAlCarrito(makeInventario({ fechaVencimiento: '2030-01-01' }));
      expect(component.lotesProximosVencer.length).toBe(0);
    });
  });

  // ── confirmar venta ──────────────────────────────────────────────

  describe('confirmarVenta', () => {
    beforeEach(() => {
      component.agregarAlCarrito(makeInventario());
    });

    it('NO debe llamar al servicio si el carrito está vacío', () => {
      component.carrito = [];
      component.confirmarVenta();
      expect(ventaSvc.crearVenta).not.toHaveBeenCalled();
    });

    it('debe llamar al servicio con el request correcto', () => {
      ventaSvc.crearVenta.and.returnValue(of(makeVentaResponse()));
      component.confirmarVenta();

      expect(ventaSvc.crearVenta).toHaveBeenCalledWith(jasmine.objectContaining({
        detalles: jasmine.arrayContaining([
          jasmine.objectContaining({
            inventarioId: 'inv-001',
            productoId: 'prod-001',
            tipoPrecio: 'UNIDAD',
            cantidad: 1,
            precioUnitario: 2.50
          })
        ])
      }));
    });

    it('debe limpiar el carrito tras venta exitosa', () => {
      ventaSvc.crearVenta.and.returnValue(of(makeVentaResponse()));
      component.confirmarVenta();
      expect(component.carrito.length).toBe(0);
    });

    it('debe mostrar toast de éxito tras venta exitosa', () => {
      ventaSvc.crearVenta.and.returnValue(of(makeVentaResponse()));
      component.confirmarVenta();
      expect(messageSvc.add).toHaveBeenCalledWith(
        jasmine.objectContaining({ severity: 'success' })
      );
    });

    it('debe mostrar toast de error si el servicio falla', () => {
      ventaSvc.crearVenta.and.returnValue(throwError(() => ({ error: { message: 'Stock insuficiente' } })));
      component.confirmarVenta();
      expect(messageSvc.add).toHaveBeenCalledWith(
        jasmine.objectContaining({ severity: 'error' })
      );
    });

    it('debe desactivar cargando tras error', () => {
      ventaSvc.crearVenta.and.returnValue(throwError(() => new Error('error')));
      component.confirmarVenta();
      expect(component.cargando).toBeFalse();
    });

    it('debe incluir el descuento en el request', () => {
      ventaSvc.crearVenta.and.returnValue(of(makeVentaResponse()));
      component.descuentoPorcentaje = 10;
      const descuentoEsperado = component.descuentoMonto; // capture BEFORE sale clears cart
      component.confirmarVenta();
      expect(ventaSvc.crearVenta).toHaveBeenCalledWith(
        jasmine.objectContaining({ descuento: descuentoEsperado })
      );
    });
  });

  // ── cancelar venta ───────────────────────────────────────────────

  describe('cancelarVenta', () => {
    it('NO debe hacer nada si el carrito está vacío', () => {
      component.carrito = [];
      const confirmSvc = fixture.debugElement.injector.get(ConfirmationService);
      const spy = spyOn(confirmSvc, 'confirm');
      component.cancelarVenta();
      expect(spy).not.toHaveBeenCalled();
    });

    it('debe vaciar el carrito al confirmar cancelación', () => {
      component.agregarAlCarrito(makeInventario());
      const confirmSvc = fixture.debugElement.injector.get(ConfirmationService);
      const spy = spyOn(confirmSvc, 'confirm').and.callFake((conf: any) => {
        conf.accept();
        return confirmSvc;
      });
      component.cancelarVenta();
      expect(spy).toHaveBeenCalled();
      expect(component.carrito.length).toBe(0);
    });

    it('debe resetear descuento al cancelar', () => {
      component.agregarAlCarrito(makeInventario());
      component.descuentoPorcentaje = 25;
      const confirmSvc = fixture.debugElement.injector.get(ConfirmationService);
      spyOn(confirmSvc, 'confirm').and.callFake((conf: any) => {
        conf.accept();
        return confirmSvc;
      });
      component.cancelarVenta();
      expect(component.descuentoPorcentaje).toBe(0);
    });
  });

  // ── destrucción del componente ───────────────────────────────────

  describe('ngOnDestroy', () => {
    it('debe completar destroy$ al destruir el componente', () => {
      const spy = spyOn(component['destroy$'], 'next');
      component.ngOnDestroy();
      expect(spy).toHaveBeenCalled();
    });
  });
});
