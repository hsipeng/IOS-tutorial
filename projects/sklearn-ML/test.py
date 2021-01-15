
from model_manage import BowTransform

if __name__ == "__main__":
    cv = BowTransform.load_vsm()
    print('cv {}\n'.format(cv))