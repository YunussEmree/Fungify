package com.yunussemree.fungify.utils.api;


import com.fasterxml.jackson.annotation.JsonInclude;
import com.yunussemree.fungify.entity.Fungy;
import lombok.Data;

@Data
@JsonInclude()
public class ApiResponse {
    private String message;
    private Fungy data;

    public ApiResponse(String message, Fungy data) {
        this.message = message;
        this.data = data;
    }
}
