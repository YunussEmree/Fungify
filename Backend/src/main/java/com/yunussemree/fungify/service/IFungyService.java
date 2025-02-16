package com.yunussemree.fungify.service;

import com.yunussemree.fungify.entity.Fungy;

import java.util.List;

public interface IFungyService {
    Fungy findByMushroomName(String mushroomName);
}
