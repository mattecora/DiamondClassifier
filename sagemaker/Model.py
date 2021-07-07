import argparse
import os
from sklearn.externals import joblib
import pandas as pd
from sklearn.model_selection import GridSearchCV
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
import numpy as np
from sklearn.pipeline import make_pipeline
from sklearn.base import BaseEstimator,TransformerMixin
from sklearn.linear_model import SGDClassifier
from CustomTransformer import CustomTransformer

"""
The model_fn function is responsible for loading your model. 
It takes a model_dir argument that specifies where the model is stored.
"""
def model_fn(model_dir):
    clf = joblib.load(os.path.join(model_dir, "model.joblib"))
    return clf

"""
The input_fn function is responsible for deserializing your input data so that 
it can be passed to your model. It takes input data and content type as parameters, 
and returns deserialized data.
"""
def input_fn(request_body, request_content_type): 
    if request_content_type == "text/csv": 
        df = pd.DataFrame( 
            [[float(value) for value in line.split(",")] for line in request_body.split("\n")], 
            columns=["cut", "color", "clarity", "depth", "table", "price", "x", "y", "z"] 
        ) 
        return df 
    else: 
        raise ValueError('Only text/csv format is supported')

"""
The predict_fn function is responsible for getting predictions from the model. 
It takes the model and the data returned from input_fn as parameters, and returns the prediction.
"""
def predict_fn(input_data, model):
    prediction = model.predict(input_data)
    return prediction

"""
The output_fn function is responsible for serializing the data
that the predict_fn function returns as a prediction.
"""
def output_fn(prediction, content_type):
    if content_type == "text/csv":
        return ",".join([str(x) for x in prediction])
    else:
        raise ValueError('Only text/csv format is supported')


if __name__ =='__main__':
    parser = argparse.ArgumentParser()
    
    parser.add_argument('--model-dir', type=str, default=os.environ.get('SM_MODEL_DIR'))
    parser.add_argument('--train', type=str, default=os.environ.get('SM_CHANNEL_TRAIN'))
    
    args, _ = parser.parse_known_args()
    
    train = pd.read_csv(os.path.join(args.train, "prep_train.csv"), engine = 'python')
    X_train = train.drop(labels = ['carat_class'], axis = 1)
    y_train = train['carat_class']
    
    seed = 0

    custom_transf = CustomTransformer()
    std_scale = StandardScaler()
    pca = PCA(n_components=8)
    clf = SGDClassifier(random_state = seed, alpha = 0.0001)
    
    model = make_pipeline(custom_transf, std_scale, pca, clf)
    model.fit(X_train, y_train)  
    
    joblib.dump(model, os.path.join(args.model_dir, "model.joblib"))