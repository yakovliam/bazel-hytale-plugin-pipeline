package org.myapplication.servicea.service;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import org.springframework.grpc.client.ChannelBuilderOptions;
import org.springframework.grpc.client.GrpcChannelFactory;
import org.springframework.stereotype.Component;

@Component
public class DefaultGrpcChannelFactory implements GrpcChannelFactory {

  @Override
  public boolean supports(String target) {
    return target != null && !target.isEmpty();
  }

  @Override
  public ManagedChannel createChannel(String target, ChannelBuilderOptions options) {
    // configure the channel (e.g., SSL, timeout settings, etc.)
    return ManagedChannelBuilder.forTarget(target)
        .usePlaintext()  // For testing or non-secure connections
        .build();
  }
}
