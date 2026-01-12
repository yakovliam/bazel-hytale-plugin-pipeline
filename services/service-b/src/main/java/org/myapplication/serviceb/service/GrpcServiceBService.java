package org.myapplication.serviceb.service;

import io.grpc.stub.StreamObserver;

import java.util.function.Function;

import org.myapplication.common.api.model.ApiError;
import org.myapplication.common.api.model.Result;
import org.myapplication.serviceb.api.proto.ServiceBServiceGrpc;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.grpc.server.service.GrpcService;

@GrpcService
public class GrpcServiceBService extends ServiceBServiceGrpc.ServiceBServiceImplBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(GrpcServiceBService.class);
    private final ApiErrorProtoMapper apiErrorProtoMapper;

    public GrpcServiceBService(ApiErrorProtoMapper apiErrorProtoMapper) {
        this.apiErrorProtoMapper = apiErrorProtoMapper;
    }

    private <T> void sendResponse(Result<T, ApiError> result, StreamObserver<T> responseObserver, Function<org.myapplication.serviceb.api.proto.ApiError, T> buildError) {
        if (result.isSuccess()) {
            responseObserver.onNext(result.getSuccess());
            responseObserver.onCompleted();
        } else {
            responseObserver.onNext(buildError.apply(apiErrorProtoMapper.toProto(result.getError())));
            responseObserver.onCompleted();
        }
    }
}
