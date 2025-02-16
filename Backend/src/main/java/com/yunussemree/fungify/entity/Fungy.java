package com.yunussemree.fungify.entity;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

@Data
@JsonInclude()
public class Fungy {
    public String getFungyDescription() {
        return fungyDescription;
    }

    public void setFungyDescription(String fungyDescription) {
        this.fungyDescription = fungyDescription;
    }

    public String getFungyImageUrl() {
        return fungyImageUrl;
    }

    public void setFungyImageUrl(String fungyImageUrl) {
        this.fungyImageUrl = fungyImageUrl;
    }

    public boolean isVenomous() {
        return venomous;
    }

    public void setVenomous(boolean venomous) {
        this.venomous = venomous;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    private Long id;
    private String name;
    private boolean venomous;
    private String fungyImageUrl;
    private String fungyDescription;

    public Fungy() {}

    public Fungy(Long id, String name, boolean venomous, String fungyImageUrl, String fungyDescription) {
        this.id = id;
        this.name = name;
        this.venomous = venomous;
        this.fungyImageUrl = fungyImageUrl;
        this.fungyDescription = fungyDescription;
    }
}
