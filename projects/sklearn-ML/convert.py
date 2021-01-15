# -*- coding: utf-8 -*-
# @Date    : 2020/01/15
# @Author  : lirawx

import joblib
from coremltools.converters.sklearn import convert

if __name__ == '__main__':
    # 只支持 sklearn 官方库的一些模型
    # 自定义的算法无法直接转换
    # logisticRegression_sklearn ./model/LogisticRegression_sklearn.pkl
    cls = joblib.load('./model/LogisticRegression_sklearn.pkl')
    coreml_model = convert(cls)
    coreml_model.author = "lirawx"  
    print(coreml_model.author)
    coreml_model.license = 'CC0'
    coreml_model.short_description = "spam msg with a linear model!"  
    coreml_model.input_description["input"] = "a msg"  
    # coreml_model.output_description["prediction"] = "a real number"
    print(coreml_model.short_description)
    coreml_model.save('SklearnLogistic.mlmodel')
