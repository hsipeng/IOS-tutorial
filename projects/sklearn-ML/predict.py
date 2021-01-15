from collections import Counter
import jieba
import time
from multiprocessing import Pool
from model_manage import BowTransform
import joblib
from sklearn.feature_extraction import DictVectorizer

def token(x):
    return Counter(jieba.lcut(x))


if __name__ == "__main__":
    start = time.time()
    jieba.initialize()
    messages = ["一次价值xxx元王牌项目；可充值xxx元店内项目卡一张；可以参与V动好生活百分百抽奖机会一次！预约电话：xxxxxxxxxxx"]
    # data = [Counter(d) for d in map(jieba.cut, messages)]
    data = Pool().map(token, messages)
    print('token data: {}\n'.format(data))
    print('end token in {}\n'.format(time.time() - start))
    print('fit transform')
    cv = BowTransform.load_vsm()
    data = cv.transform(data) # 稀疏矩阵表示sparse matrix,词编好号
    print('transform data: {}\n'.format(data))
    print('end bow in {}\n'.format(time.time() - start))
    # logisticRegression ./model/LogisticRegression.pkl
    # Bayes_sklearn ./model/Bayes_sklearn.pkl
    # logisticRegression_sklearn ./model/LogisticRegression_sklearn.pkl
    cls = joblib.load('./model/LogisticRegression_sklearn.pkl')
    predicted = cls.predict(data)

    print('msg predicted result: {}\n , 处理结果 {}\n'.format(predicted, '过滤' if predicted[0] == 1 else '正常'))
    
    print('task complete. total time: {}\n using {}'.format(time.time() - start, cls))
