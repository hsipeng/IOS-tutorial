# -*- coding: utf-8 -*-
# @Date    : 2020/01/15
# @Author  : lirawx

# import sklearn.external.joblib as extjoblib
import joblib # fix import 
import codecs
from sklearn import metrics, naive_bayes, svm, linear_model
from sklearn.metrics import precision_recall_fscore_support
from collections import Counter
from sklearn.feature_extraction import DictVectorizer

class BowTransform(object):
    default_path = './model/vsm.pkl'

    @staticmethod
    def save_vsm(model, filename=None):
        joblib.dump(model, filename if filename else BowTransform.default_path)

    @staticmethod
    def load_vsm(filename=None):
        return joblib.load(filename if filename else BowTransform.default_path)


class TrainData(object):
    default_path = './model/train_data.pkl'

    @staticmethod
    def save(model, filename=None):
        joblib.dump(model, filename if filename else TrainData.default_path)

    @staticmethod
    def load(filename=None):
        with open('./data/tags_token_results' + '_tag') as f:
            return joblib.load(filename if filename else TrainData.default_path), list(map(int, f.read().split('\n')[:-1]))
    @staticmethod
    def read_train_data():
        file_path = './data/tags_token_results'
        with codecs.open(file_path, 'r', 'utf-8') as f:
            data = [line.strip().split() for line in f.read().split('\n')]

        with open(file_path + '_tag') as f:
            return data[:-1], list(map(int, f.read().split('\n')[:-1]))

class ModelTest(object):

    @staticmethod
    def _test(classifier, test_data, test_target):
        predicted = classifier.predict(test_data)
        print(predicted.shape)  # 160 1

        # print(sum(predicted == test_target), len(test_target), np.mean(predicted == test_target))
        print("Classification report for classifier %s:\n%s\n" % (
            classifier, metrics.classification_report(test_target, predicted, digits=4)))
        print("Confusion matrix:\n%s" % metrics.confusion_matrix(test_target, predicted))
        print(precision_recall_fscore_support(test_target, predicted))

    @staticmethod
    def test_one(cls, use_save_data=True, train_cls=False, save_cls_path=None):
        if use_save_data:
            data, target = TrainData.load()
        else:
            data, target = TrainData.read_train_data()
            # data_len = int(len(data) * 0.001)
            # data, target = data[:data_len], target[:data_len]

            data = [Counter(d) for d in data]  # 每一行为一个短信， 值就是TF
            # print(data[0])
            print('fit transform')
            cv = BowTransform.load_vsm()
            data = cv.transform(data)  # 稀疏矩阵表示sparse matrix,词编好号
            TrainData.save(data)

        # print(data[0])
        data_len = data.shape[0]
        print('data', data.shape[1])
        end = int(0.8 * data_len)
        train_data, train_target = data[:end], target[:end]
        test_data, test_target = data[end:], target[end:]

        if train_cls:
            print('train classifier....')
            cls = cls.fit(train_data, train_target)
            print('train classifier complete')

        ModelTest._test(cls, test_data, test_target)

        if save_cls_path:
            joblib.dump(cls, save_cls_path)

class FileUtils(object):
    # 保存文件
    @staticmethod
    def text_save(filename, data):
        file = open(filename, 'a')

        for item in data:
            print(item)
            file.write(item + '\n')

        file.close()
        print('文件保存成功')