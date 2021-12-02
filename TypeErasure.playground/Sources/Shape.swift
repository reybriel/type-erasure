import Foundation

public protocol Shape {
    associatedtype Attributes // Cada forma terá um grupo de atributos diferente

    var area: Double { get }
    var description: String { get }
    var attributes: Attributes { get }

    func isBigger(than shape: Self) -> Bool // Comparação entre diferentes formas não é permitido
}

public extension Shape {
    func isBigger(than shape: Self) -> Bool {
        area > shape.area
    }
}
