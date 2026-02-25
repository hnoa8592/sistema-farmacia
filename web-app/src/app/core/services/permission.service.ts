import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class PermissionService {
  private _recursos = new BehaviorSubject<string[]>([]);
  recursos$ = this._recursos.asObservable();

  constructor() {
    const stored = localStorage.getItem('recursos');
    if (stored) {
      try { this._recursos.next(JSON.parse(stored)); } catch {}
    }
  }

  setRecursos(recursos: string[]): void {
    this._recursos.next(recursos);
  }

  tienePermiso(recurso: string): boolean {
    return this._recursos.value.includes(recurso);
  }

  tieneAlgunPermiso(recursos: string[]): boolean {
    return recursos.some(r => this._recursos.value.includes(r));
  }
}
