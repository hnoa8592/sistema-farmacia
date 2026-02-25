import { Directive, Input, OnInit, TemplateRef, ViewContainerRef } from '@angular/core';
import { PermissionService } from 'src/app/core/services/permission.service';

@Directive({ selector: '[appPermiso]' })
export class PermisoDirective implements OnInit {
  private recurso: string = '';

  @Input() set appPermiso(recurso: string) {
    this.recurso = recurso;
    this.updateView();
  }

  constructor(
    private templateRef: TemplateRef<any>,
    private viewContainer: ViewContainerRef,
    private permissionService: PermissionService
  ) {}

  ngOnInit(): void {
    this.updateView();
  }

  private updateView(): void {
    this.viewContainer.clear();
    if (this.permissionService.tienePermiso(this.recurso)) {
      this.viewContainer.createEmbeddedView(this.templateRef);
    }
  }
}
