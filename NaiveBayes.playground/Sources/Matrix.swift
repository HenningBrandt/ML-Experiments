import Foundation


public enum MathError: ErrorProtocol {
    case malformedMatrix
    case emptyMatrix
}

public struct Matrix<T:Equatable>: Equatable {
    public let matrix: [[T]]
    
    public init(matrix: [[T]]) throws {
        guard !matrix.isEmpty, !matrix.first!.isEmpty else {
            throw MathError.emptyMatrix
        }
        
        let amounts = matrix.map { $0.count }
        let amountsEqual = amounts[1..<amounts.count].reduce((amounts.first!, true)) { (l,r) in
            return (r, l.1 && (l.0 == r))
        }
        
        guard amountsEqual.1 else {
            throw MathError.malformedMatrix
        }
        
        self.matrix = matrix
    }
    
    public func dimension() -> (Int, Int) {
        return (matrix.count, matrix.first!.count)
    }
    
    public func transpose() -> Matrix<T> {
        var transposedMatrix: [[T]] = []
        for index in 0..<matrix.first!.count {
            var transposedRow: [T] = []
            for row in matrix {
                transposedRow.append(row[index])
            }
            transposedMatrix.append(transposedRow)
        }
        
        return try! Matrix(matrix: transposedMatrix)
    }
    
    public subscript(index: Int) -> [T] {
        return matrix[index]
    }
}

public func ==<T: Equatable>(lhs: Matrix<T>, rhs: Matrix<T>) -> Bool {
    // Dimensions must match
    guard lhs.dimension() == rhs.dimension() else {
        return false
    }
    
    // Every element e(ij) must be equal
    for rowIndex in 0..<lhs.matrix.count {
        let lRow = lhs.matrix[rowIndex]
        let rRow = rhs.matrix[rowIndex]
        if lRow != rRow {
            return false
        }
    }
    
    return true
}
