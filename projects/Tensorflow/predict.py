import jieba
import time
from multiprocessing import Pool
from model_manage import BowTransform
import joblib
from sklearn.feature_extraction import DictVectorizer
import json
import codecs
import ast
import tensorflow as tf
from tensorflow import keras
import numpy as np

def token(x):
    return jieba.lcut(x)

start = time.time()
jieba.initialize()
messages = ["妈妈叫你回家吃饭","现在网吧的电脑都升级了环境也更好了","2015年下半年鹤山市教育系统部分事业单位公开招聘中小学、幼儿园教师14名公告"]
# data = [Counter(d) for d in map(jieba.cut, messages)]
data = Pool().map(token, messages)
print('token data: {}\n'.format(data))
print('end token in {}\n'.format(time.time() - start))
print('fit transform - convert to int')

predict_data = []
with codecs.open("./data/tags_token_results_int_dict", 'r') as f:
#     dict = json.loads(f.read()) 字段需要双引号
    dict = ast.literal_eval(f.read())
    for x in data:
        line = []
        for y in x:
            v = dict.get(y)
            line.append(v)
        predict_data.append(line)
print('transform data: {}\n'.format(predict_data))

predict_data = keras.preprocessing.sequence.pad_sequences(predict_data,
                                                        value=0,
                                                        padding='post',
                                                        maxlen=64)
print('padding data: {}\n'.format(predict_data))

print('end bow in {}\n'.format(time.time() - start))

predict_data = np.array(predict_data)

model = keras.models.load_model('my_model.h5')
#  softmax 层，将 logits 转换成更容易理解的概率。
probability_model = tf.keras.Sequential([model, 
                                         tf.keras.layers.Softmax()])

predictions = probability_model.predict(predict_data)

print(predictions)