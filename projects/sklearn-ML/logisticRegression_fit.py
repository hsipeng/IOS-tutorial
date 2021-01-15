
import sys
# fix 多目录 查找model
sys.path.append('./prjects/sklearn-ML')
sys.path.append('./classifier')
from classifier.LogisticRegression import LogisticRegression

from model_manage import ModelTest
import datetime

if __name__ == '__main__':
    start = datetime.datetime.now()
    ModelTest.test_one(LogisticRegression(alpha=0.1, max_iter=2000),use_save_data=False, train_cls=True, save_cls_path='./model/LogisticRegression.pkl')
    print((datetime.datetime.now() - start))