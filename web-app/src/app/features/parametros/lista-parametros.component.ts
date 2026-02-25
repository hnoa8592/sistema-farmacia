import { Component, OnInit } from '@angular/core';
import { MessageService } from 'primeng/api';
import { ParametroService } from './services/parametro.service';
import { ParametroResponse } from './models/parametro.model';

@Component({
  selector: 'app-lista-parametros',
  templateUrl: './lista-parametros.component.html',
  providers: [MessageService]
})
export class ListaParametrosComponent implements OnInit {
  parametros: ParametroResponse[] = [];
  cargando = true;
  editandoClave: string | null = null;
  nuevoValor: string = '';
  guardando = false;

  modulosOpciones: string[] = [];

  get parametrosPorModulo(): Record<string, ParametroResponse[]> {
    const result: Record<string, ParametroResponse[]> = {};
    for (const p of this.parametros) {
      if (!result[p.modulo]) result[p.modulo] = [];
      result[p.modulo].push(p);
    }
    return result;
  }

  get modulos(): string[] {
    return Object.keys(this.parametrosPorModulo);
  }

  constructor(private parametroService: ParametroService, private messageService: MessageService) {}

  ngOnInit(): void { this.cargar(); }

  cargar(): void {
    this.cargando = true;
    this.parametroService.getAll().subscribe({
      next: p => { this.parametros = p; this.cargando = false; },
      error: () => { this.cargando = false; }
    });
  }

  iniciarEdicion(p: ParametroResponse): void {
    this.editandoClave = p.clave;
    this.nuevoValor = p.valor;
  }

  cancelarEdicion(): void { this.editandoClave = null; this.nuevoValor = ''; }

  guardar(p: ParametroResponse): void {
    this.guardando = true;
    this.parametroService.actualizar(p.clave, { valor: this.nuevoValor }).subscribe({
      next: updated => {
        const idx = this.parametros.findIndex(x => x.clave === p.clave);
        if (idx >= 0) this.parametros[idx] = updated;
        this.editandoClave = null;
        this.guardando = false;
        this.messageService.add({ severity: 'success', summary: 'Actualizado', detail: 'Parámetro actualizado correctamente' });
      },
      error: () => { this.guardando = false; this.messageService.add({ severity: 'error', summary: 'Error', detail: 'No se pudo actualizar' }); }
    });
  }
}
