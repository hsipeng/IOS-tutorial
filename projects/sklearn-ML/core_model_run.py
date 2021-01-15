import coremltools
from model_manage import BowTransform
from multiprocessing import Pool
from collections import Counter
import jieba
import time

def token(x):
    return Counter(jieba.lcut(x))



if __name__ == '__main__':
    start = time.time()

    messages = ["一次价值xxx元王牌项目；可充值xxx元店内项目卡一张；可以参与V动好生活百分百抽奖机会一次！预约电话：xxxxxxxxxxx"]
    # Load the model
    model = coremltools.models.MLModel('SklearnLogistic.mlmodel')

    data = Pool().map(token, messages)
    print('token data: {}\n'.format(data))
    print('end token in {}\n'.format(time.time() - start))
    print('fit transform')
    cv = BowTransform.load_vsm()
    data = cv.transform(data) # 稀疏矩阵表示sparse matrix,词编好号
    print('transform data: {}\n'.format(data))
    print('end bow in {}\n'.format(time.time() - start))


    # Make predictions
    predictions = model.predict({'message': data})

    print("predictions: {}".format(predictions))