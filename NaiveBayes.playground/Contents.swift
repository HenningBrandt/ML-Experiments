// Experiment to cement the concepts in Udacitys first lesson
// of "Intro to machine learning" https://classroom.udacity.com/courses/ud120 
// about Naive Bayes by implementing it in Swift

import UIKit

let classifier = NBClassifier<Double>()
try! classifier.train(features: features(filename: "training_data.csv"), labels: labels(filename: "training_labels.csv"))

let testFeatures = features(filename: "test_data.csv")
let testLabels = labels(filename: "test_labels.csv")

let accuracy = try! classifier.accuracy(testData: testFeatures, testLabels: testLabels)
print(accuracy)

// TODO: Visualize Result