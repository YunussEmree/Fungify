package com.yunussemree.fungify.fungy;

import java.util.List;

public interface IFungyService {
    Fungy findByMushroomName(String mushroomName);
    List<Fungy> findAll();
}
