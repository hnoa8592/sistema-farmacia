package com.tecnoa.pos.config;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.concurrent.atomic.AtomicReference;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Test unitario puro del ThreadLocal TenantContext.
 * No necesita Spring ni base de datos.
 */
@DisplayName("TenantContext - ThreadLocal")
class TenantContextTest {

    @AfterEach
    void cleanup() {
        TenantContext.clear();
    }

    @Test
    @DisplayName("setTenant y getTenant en el mismo hilo retorna el valor correcto")
    void setAndGet_sameThread_returnsValue() {
        TenantContext.setTenant("farmacia_noa");
        assertThat(TenantContext.getTenant()).isEqualTo("farmacia_noa");
    }

    @Test
    @DisplayName("getTenant retorna null cuando no se seteó nada")
    void getTenant_notSet_returnsNull() {
        assertThat(TenantContext.getTenant()).isNull();
    }

    @Test
    @DisplayName("clear() deja el valor en null")
    void clear_resetsToNull() {
        TenantContext.setTenant("farmacia_noa");
        TenantContext.clear();
        assertThat(TenantContext.getTenant()).isNull();
    }

    @Test
    @DisplayName("El valor es aislado por hilo — hilo distinto no ve el valor del hilo principal")
    void threadIsolation_differentThreadDoesNotSeeValue() throws InterruptedException {
        TenantContext.setTenant("farmacia_noa");

        AtomicReference<String> valueInOtherThread = new AtomicReference<>("NOT_SET");
        Thread other = new Thread(() -> valueInOtherThread.set(TenantContext.getTenant()));
        other.start();
        other.join();

        // El hilo principal sigue teniendo su valor
        assertThat(TenantContext.getTenant()).isEqualTo("farmacia_noa");
        // El otro hilo NO hereda el valor del hilo principal
        assertThat(valueInOtherThread.get()).isNull();
    }

    @Test
    @DisplayName("setTenant sobreescribe el valor anterior")
    void setTenant_overwritesPreviousValue() {
        TenantContext.setTenant("farmacia_noa");
        TenantContext.setTenant("farmacia_otra");
        assertThat(TenantContext.getTenant()).isEqualTo("farmacia_otra");
    }
}
