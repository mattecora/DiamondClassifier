import argparse
import os
from sklearn.externals import joblib
import pandas as pd
from sklearn.model_selection import GridSearchCV
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.svm import SVC
import numpy as np
from sklearn.pipeline import make_pipeline

def model_fn(model_dir):
    clf = joblib.load(os.path.join(model_dir, "model.joblib"))
    return clf

def input_fn(request_body, request_content_type):
    """An input_fn that loads a pickled numpy array"""
    if request_content_type == "text/csv":
        array = np.fromstring(request_body, sep = ',')
        return array
    else:
        raise ValueError('Only text/csv and application/json are supported')
    """
    elif request_content_type == "application/json":
        array = np.load(StringIO(request_body))
        return array 
    """

def predict_fn(input_data, model):
    prediction = model.predict(input_data)
    return prediction

def output_fn(prediction, content_type):
    if content_type == "text/csv":
        return ",".join([str(x) for x in prediction])
    else:
        raise ValueError('Only text/csv and application/json are supported')



if __name__ =='__main__':

    parser = argparse.ArgumentParser()
    
    # Data, model, and output directories
    #parser.add_argument('--output-data-dir', type=str, default=os.environ.get('SM_OUTPUT_DATA_DIR'))
    parser.add_argument('--model-dir', type=str, default=os.environ.get('SM_MODEL_DIR'))
    parser.add_argument('--train', type=str, default=os.environ.get('SM_CHANNEL_TRAIN'))
    
    args, _ = parser.parse_known_args()
    
    train = pd.read_csv(os.path.join(args.train, "prep_train.csv"), engine='python')
    X_train = train.drop(labels = ['carat_class'],axis = 1)
    y_train = train['carat_class']
    
    seed = 42

    std_scale = StandardScaler()
    pca = PCA(n_components=5)
    clf = SVC(gamma='auto',kernel='rbf', C = 1.0, random_state = seed)
    
    parameters = {'kernel':('linear', 'rbf'), 'C':[0.01, 0.1, 1, 10, 100]}
    grid = GridSearchCV(clf, parameters)
    
    model = make_pipeline(std_scale,pca,grid)

    #sample_train, sample_val, label_train, label_val
    model.fit(X_train, y_train)  
    
    joblib.dump(model, os.path.join(args.model_dir, "model.joblib"))