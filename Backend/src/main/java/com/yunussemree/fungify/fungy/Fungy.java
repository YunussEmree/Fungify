package com.yunussemree.fungify.fungy;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Fungy {
    private Long id;
    private String name;
    private boolean venomous;
    private String fungyImageUrl;
    private String fungyDescription;
}
