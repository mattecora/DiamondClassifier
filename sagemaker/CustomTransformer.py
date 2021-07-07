from sklearn.base import BaseEstimator,TransformerMixin
import pandas as pd

def categorize_x(x):
    to_return = None
    if x < 7:
        to_return = "low"
    elif x < 9:
        to_return = "medium"
    else:
        to_return = "high"
    return to_return

def categorize_y(y):
    to_return = None
    if y < 6:
        to_return = "low"
    elif y < 8:
        to_return = "medium"
    else:
        to_return = "high"
    return to_return

class CustomTransformer(BaseEstimator,TransformerMixin):
      
    def fit(self,X,y=None):
        return self
    
    def transform(self,X,y=None):
        X_ = X.copy()
        
        X_['x_cat'] = X_['x'].apply(lambda x : categorize_x(x)).astype(pd.CategoricalDtype(categories=['low','medium','high'], ordered=True)).cat.codes
        X_['y_cat'] = X_['y'].apply(lambda y : categorize_y(y)).astype(pd.CategoricalDtype(categories=['low','medium','high'], ordered=True)).cat.codes
        
        return X_