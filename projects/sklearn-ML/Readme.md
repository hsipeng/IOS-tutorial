# 环境

- conda python 3.8

- jieba

pip install jieba
pip install 'scikit-learn==0.19.2' 


## 运行
在 sklearn-ML 下运行,目录查找逻辑问题，如果是新项目不会
首先运行`token_and_save_to_file.py`，分词保存结果 。

`logisticRegression_fit.py` 训练自有的 LogisticRegression 并且保存到 `./model/LogisticRegression.pkl`
`logisticRegression_sklearn_fit.py` 训练sklearn.linear_model.LogisticRegression 并且保存到 `./model/LogisticRegression_sklearn.pkl`
`Naive_bayes_fit.py` 训练 sklearn.Naive_bayes 并且保存到 `./model/Bayes_sklearn.pkl`

`predict.py` 是进行预测短信是否需要过滤
通过 model 路径导入模型进行预测
特征转换需要统一使用 vsm 中的 DictVectorizer
这边只是预先输入了一些参数 实际使用的还是sklearn `from sklearn.feature_extraction import DictVectorizer`