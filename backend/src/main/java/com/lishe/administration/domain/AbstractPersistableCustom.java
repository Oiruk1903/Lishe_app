package com.lishe.administration.domain;

import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.MappedSuperclass;
import org.springframework.data.domain.Persistable;


import java.io.Serializable;

@MappedSuperclass
public abstract class AbstractPersistableCustom<PK extends Serializable> implements Persistable<Long>, Serializable {
    private static final long serialVersionUID = 9181640245194392646L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Override
    public Long getId() {
        return id;
    }

    protected void setId(final Long id) {
        this.id = id;
    }

    @Override
    public boolean isNew() {
        return null == this.id;
    }
}
