package com.tecnoa.pos.shared.exception;

import java.util.UUID;

public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String entity, UUID id) {
        super(entity + " no encontrado con id: " + id);
    }

    public ResourceNotFoundException(String entity, String identifier) {
        super(entity + " no encontrado: " + identifier);
    }
}
