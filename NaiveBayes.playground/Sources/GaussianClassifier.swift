import Foundation


struct GaussianClass<Label> {
    let label: Label
    var probability: Double = 0.0
    var featureExpectations: [Double] = []
    var featureStddev: [Double] = []
    
    init(label: Label) {
        self.label = label
    }
    
    func classProbability(of featureVector: [Double]) -> Double {
        var result = probability
        var index = 0
        
        // In naive bayes each feature x(i) is assumed to be independent from all other
        // => the combined probability P(x(1),...,x(n) | y) is the sum of each P(x(i) | y)
        for (expected, stddev) in zip(featureExpectations, featureStddev) { // would be cooler if i could zip 3 arrays...?
            result *= singleFeatureProbability(feature: featureVector[index], expected: expected, stddev: stddev)
            index += 1
        }
        
        return result
    }
    
    func singleFeatureProbability(feature: Double, expected: Double, stddev: Double) -> Double {
        // In gaussian naive bayes each feature is assumed to be normal distributed
        return (1.0 / sqrt(2 * Double.pi * pow(stddev, 2))) * exp(-(pow(feature - expected, 2) / (2 * pow(stddev, 2))))
    }
}

public enum ClassifierError: ErrorProtocol {
    case featuresAndLabelsDontMatch
    case wrongFeatureVector
    case classifierWasNotTrained
}

public class NBClassifier<Label: Hashable> {
    var trainedData: [GaussianClass<Label>] = []
    
    public init() {
        
    }
    
    public func train(features: Matrix<Double>, labels: [Label]) throws {
        guard features.dimension().0 == labels.count else {
            throw ClassifierError.featuresAndLabelsDontMatch
        }
        
        // Group all feature vectors by label
        var groupedFeatures: [Label : [[Double]]] = [:]
        for index in 0..<labels.count {
            let label = labels[index]
            if var samples = groupedFeatures[label] {
                samples.append(features[index])
                groupedFeatures[label] = samples
            } else {
                groupedFeatures[label] = [features[index]]
            }
        }
        
        for (label, matrix) in groupedFeatures {
            // The transposed feature matrix groups all
            let transposedMatrix = try! Matrix(matrix: matrix).transpose()
            var nbClass = GaussianClass(label: label)
            
            // probability for each label is a simple laplace probability
            nbClass.probability = laplaceProbability(sampleSpace: Array(groupedFeatures.keys), significantEvent: label)
            
            for row in transposedMatrix.matrix {
                nbClass.featureExpectations.append(average(vector: row))
                nbClass.featureStddev.append(stddev(vector: row))
            }
            trainedData.append(nbClass)
        }
    }
    
    public func predict(featureVector: [Double]) throws -> Label {
        guard !trainedData.isEmpty else {
            throw ClassifierError.classifierWasNotTrained
        }
        
        guard let nbClass = trainedData.first, nbClass.featureExpectations.count == featureVector.count else {
            throw ClassifierError.wrongFeatureVector
        }
        
        // The label with the largest probability for the 
        // given feature gets the predicted class
        var result: (nbClass: Label?, probability: Double) = (nil, 0.0)
        for nbClass in trainedData {
            let probability = nbClass.classProbability(of: featureVector)
            if probability > result.probability {
                result = (nbClass: nbClass.label, probability: probability)
            }
        }
        
        return result.0!
    }
    
    public func accuracy(testData: Matrix<Double>, testLabels: [Label]) throws -> Double {
        var correct = 0
        for (testLabel, featureVector) in zip(testLabels, testData.matrix) {
            let prediction = try! predict(featureVector: featureVector)
            if prediction == testLabel {
                correct += 1
            }
        }
        
        return Double(correct) / Double(testLabels.count)
    }
}
