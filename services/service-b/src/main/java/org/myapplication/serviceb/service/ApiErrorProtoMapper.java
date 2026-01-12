package org.myapplication.serviceb.service;

import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import org.myapplication.serviceb.api.proto.ApiError;
import org.springframework.stereotype.Service;

@Service
public class ApiErrorProtoMapper {

    /**
     * Convert an ApiError to a ApiError proto
     *
     * @param apiError ApiError
     * @return ApiError proto
     */
    public ApiError toProto(org.myapplication.common.api.model.ApiError apiError) {
        return ApiError.newBuilder().setCode(apiError.getCode()).setMessage(apiError.getMessage()).setStatus(apiError.getStatus().value()).putAllDetails(toStringStringMap(apiError.getDetails())).build();
    }

    /**
     * Convert a map of objects to a map of strings
     *
     * @param input map of objects
     * @return map of strings
     */
    private Map<String, String> toStringStringMap(Map<String, Object> input) {
        return input.entrySet().stream().collect(Collectors.toMap(Map.Entry::getKey, entry -> Objects.toString(entry.getValue())));
    }
}

