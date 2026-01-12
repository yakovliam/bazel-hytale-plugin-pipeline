package org.myapplication.common.api.config;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.Strictness;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class GsonProvider {

  @Bean("common-gson")
  public Gson gson() {
    return new GsonBuilder().serializeNulls().setStrictness(Strictness.LENIENT).create();
  }
}
