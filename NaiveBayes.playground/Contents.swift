// Experiment to cement the concepts in Udacitys first lesson
// of "Intro to machine learning" https://classroom.udacity.com/courses/ud120 
// about Naive Bayes by implementing it in Swift

import UIKit

let classifier = NBClassifier<Double>()
try! classifier.train(features: features(filename: "training_data"), labels: labels(filename: "training_labels"))

let testFeatures = features(filename: "test_data")
let testLabels = labels(filename: "test_labels")

let accuracy = try! classifier.accuracy(testData: testFeatures, testLabels: testLabels)
print(accuracy)

// TODO: Visualize Result
