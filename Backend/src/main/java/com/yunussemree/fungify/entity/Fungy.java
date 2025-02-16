package com.yunussemree.fungify.entity;


import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Fungy {

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
