import jieba
import time
from multiprocessing import Pool
from model_manage import BowTransform
import joblib
from sklearn.feature_extraction import DictVectorizer
import json
import codecs
import ast


def token(x):
    return jieba.lcut(x)

start = time.time()
jieba.initialize()
messages = ["万科物业管理人员一个一个敲门"]
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
print('end bow in {}\n'.format(time.time() - start))

predict_data = np.array(predict_data)

#  softmax 层，将 logits 转换成更容易理解的概率。
probability_model = tf.keras.Sequential([model, 
                                         tf.keras.layers.Softmax()])

predictions = probability_model.predict(predict_data)

print(predictions)