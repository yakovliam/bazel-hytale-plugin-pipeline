package org.myapplication.common.api.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Id;
import jakarta.persistence.MappedSuperclass;
import java.io.Serializable;
import java.util.UUID;

/**
 * A base entity class with a NON-auto-generated UUID ID.
 */
@MappedSuperclass
public class BaseEntity implements Serializable {

  @Id
  @Column(name = "id", nullable = false)
  private UUID id;

  public UUID getId() {
    return id;
  }

  public BaseEntity setId(UUID id) {
    this.id = id;
    return this;
  }
}
