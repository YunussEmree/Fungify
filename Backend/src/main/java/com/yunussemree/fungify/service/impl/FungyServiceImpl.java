package com.yunussemree.fungify.service.impl;

import com.yunussemree.fungify.entity.Fungy;
import com.yunussemree.fungify.repository.FungyRepository;
import com.yunussemree.fungify.service.IFungyService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FungyServiceImpl implements IFungyService {

    private FungyRepository fungyRepository;

    public FungyServiceImpl(FungyRepository fungyRepository) {
        this.fungyRepository = fungyRepository;
    }

    @Override
    public List<Fungy> findAll() {
        return fungyRepository.findAll();
    }
}
