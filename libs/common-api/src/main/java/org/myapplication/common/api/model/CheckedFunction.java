package org.myapplication.common.api.model;

@FunctionalInterface
public interface CheckedFunction<R> {
  R apply() throws Exception;
}
