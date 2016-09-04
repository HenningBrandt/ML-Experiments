import Foundation


func average(vector: [Double]) -> Double {
    return vector.reduce(0.0, combine: +) / Double(vector.count)
}

func stddev(vector: [Double]) -> Double {
    guard vector.count > 0 else {
        return 0.0
    }
    
    let avg = average(vector: vector)
    if vector.count == 1 {
        return abs(vector.first! - avg)
    } else {
        let variance = vector[1..<vector.count].reduce(vector.first!) { (l,r) in
           pow(l - avg, 2) + pow(r - avg, 2)
        }
        return sqrt(variance / Double(vector.count))
    }
}

func laplaceProbability<T:Equatable>(sampleSpace: [T], significantEvent: T) -> Double {
    return Double(sampleSpace.filter({ $0 == significantEvent }).count) / Double(sampleSpace.count)
}
