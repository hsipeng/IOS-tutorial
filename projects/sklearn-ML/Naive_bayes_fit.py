
import sys
from sklearn import naive_bayes

from model_manage import ModelTest
import datetime

if __name__ == '__main__':
    start = datetime.datetime.now()
    ModelTest.test_one(naive_bayes.BernoulliNB(),use_save_data=False, train_cls=True, save_cls_path='./model/Bayes_sklearn.pkl')
    print((datetime.datetime.now() - start))