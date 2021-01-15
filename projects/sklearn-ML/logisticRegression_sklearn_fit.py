
import sys
from sklearn.linear_model import LogisticRegression

from model_manage import ModelTest
import datetime

if __name__ == '__main__':
    start = datetime.datetime.now()
    ModelTest.test_one(LogisticRegression(max_iter=2000),use_save_data=False, train_cls=True, save_cls_path='./model/LogisticRegression_sklearn.pkl')
    print((datetime.datetime.now() - start))