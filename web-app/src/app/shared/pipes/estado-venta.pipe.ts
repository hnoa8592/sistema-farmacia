import { Pipe, PipeTransform } from '@angular/core';

@Pipe({ name: 'estadoVenta' })
export class EstadoVentaPipe implements PipeTransform {
  transform(value: string): string {
    switch (value) {
      case 'COMPLETADA': return 'Completada';
      case 'ANULADA': return 'Anulada';
      default: return value;
    }
  }
}
