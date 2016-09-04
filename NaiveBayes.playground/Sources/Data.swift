import Foundation

public func labels(filename: String) -> [Double] {
    let path = Bundle.main.pathForResource(filename, ofType: "csv")!
    let data = try! String(contentsOfFile: path)
    
    return data.components(separatedBy: ";").map { Double($0) ?? 0 }
}

public func features(filename: String) -> Matrix<Double> {
    let path = Bundle.main.pathForResource(filename, ofType: "csv")!
    let data = try! String(contentsOfFile: path)
    
    let lines = data.components(separatedBy: "\n").filter { !$0.isEmpty }
    let finalData: [[Double]] = lines.map {
        let sample = $0.components(separatedBy: ";")
        return sample.map({ Double($0)! })
    }
    
    return try! Matrix(matrix: finalData)
}
