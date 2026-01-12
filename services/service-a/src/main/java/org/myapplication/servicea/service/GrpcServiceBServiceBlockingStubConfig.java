package org.myapplication.servicea.service;

import org.myapplication.serviceb.api.proto.ServiceBServiceGrpc;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.grpc.client.GrpcChannelFactory;

@Configuration
public class GrpcServiceBServiceBlockingStubConfig {

  @Value("${service.service-a.k8s-dns-name}")
  private String serviceName;

  @Value("${service.service-a.port}")
  private int servicePort;

  /**
   * Build the address for the service-a service
   *
   * @return address
   */
  private String buildAddress() {
    return String.format("dns:///%s:%d", serviceName, servicePort);
  }

  @Bean("service-a-blocking-stub")
  ServiceBServiceGrpc.ServiceBServiceBlockingStub stub(GrpcChannelFactory channels) {
    return ServiceBServiceGrpc.newBlockingStub(channels.createChannel(buildAddress()));
  }
}
