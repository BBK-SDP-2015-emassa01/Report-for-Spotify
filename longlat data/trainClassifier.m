function [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% trainClassifier(trainingData)
%  returns a trained classifier and its validation accuracy.
%  This code recreates the classification model trained in
%  Classification Learner app.
%
%   Input:
%       trainingData: the training data of same data type as imported
%        in the app (table or matrix).
%
%   Output:
%       trainedClassifier: a struct containing the trained classifier.
%        The struct contains various fields with information about the
%        trained classifier.
%
%       trainedClassifier.predictFcn: a function to make predictions
%        on new data. It takes an input of the same form as this training
%        code (table or matrix) and returns predictions for the response.
%        If you supply a matrix, include only the predictors columns (or
%        rows).
%
%       validationAccuracy: a double containing the validation accuracy
%        score in percent. In the app, the History list displays this
%        overall accuracy score for each model.
%
%  Use the code to train the model with new data.
%  To retrain your classifier, call the function from the command line
%  with your original data or new data as the input argument trainingData.
%
%  For example, to retrain a classifier trained with the original data set
%  T, enter:
%    [trainedClassifier, validationAccuracy] = trainClassifier(T)
%
%  To make predictions with the returned 'trainedClassifier' on new data T,
%  use
%    yfit = trainedClassifier.predictFcn(T)
%
%  To automate training the same classifier with new data, or to learn how
%  to programmatically train classifiers, examine the generated code.

% Auto-generated by MATLAB on 20-Sep-2015 22:05:04


inputTable = trainingData;
% Extract predictors and response
% This code processes the data into the right shape for training the
% classifier.
predictorNames = {'DAY_OF_MONTH', 'DAY_OF_WEEK', 'CARRIER', 'FL_NUM', 'ORIGIN', 'DEST', 'DEP_TIME', 'DEP_DELAY', 'DISTANCE', 'state', 'country', 'lat', 'long'};
predictors = inputTable(:, predictorNames);
response = inputTable.DepDelay_5min_intervals;

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationTree = fitctree(...
    predictors, ...
    response, ...
    'SplitCriterion', 'gdi', ...
    'MaxNumSplits', 100, ...
    'Surrogate', 'off', ...
    'ClassNames', {'departed_early_10'; 'departed_early_5'; 'departed_early_greaterThan_15'; 'departed_late_10'; 'departed_late_5'; 'departed_late_greaterThan_15'; 'onTime'});

trainedClassifier.ClassificationTree = classificationTree;
extractPredictorsFromTableFcn = @(t) t(:, predictorNames);
predictorExtractionFcn = @(x) extractPredictorsFromTableFcn(x);
treePredictFcn = @(x) predict(classificationTree, x);
trainedClassifier.predictFcn = @(x) treePredictFcn(predictorExtractionFcn(x));
inputTable = trainingData;
% Extract predictors and response
% This code processes the data into the right shape for training the
% classifier.
predictorNames = {'DAY_OF_MONTH', 'DAY_OF_WEEK', 'CARRIER', 'FL_NUM', 'ORIGIN', 'DEST', 'DEP_TIME', 'DEP_DELAY', 'DISTANCE', 'state', 'country', 'lat', 'long'};
predictors = inputTable(:, predictorNames);
response = inputTable.DepDelay_5min_intervals;


% Perform cross-validation
partitionedModel = crossval(trainedClassifier.ClassificationTree, 'KFold', 5);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');

% Compute validation predictions and scores
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);