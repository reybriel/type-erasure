import Foundation

public final class ShapesManager {
    private var shapes = [String: [AnyShape]]() // Separa as formas por tipo

    public init() {}

    /**
     Aceita inserção de qualquer forma, tirando proveito do comportamento genérico desejado.
     */
    public func add<T: Shape>(shape: T) {
        var shapesList: [AnyShape]
        let typeName = String(describing: T.self)

        if let shapes = shapes[typeName] {
            shapesList = shapes + [AnyShape(shape)]
        } else {
            shapesList = [AnyShape(shape)]
        }

        shapes[typeName] = shapesList
    }

    /**
     Executa a ordenação das formas por tipo, garantindo que tipos diferentes não serão comparados.
     */
    public func sortedShapes<T: Shape>(ofType: T.Type) -> [T] {
        let typeName = String(describing: T.self)

        guard let shapes = shapes[typeName] else {
            return []
        }

        return shapes.sorted { shapeLeft, shapeRight in
            !shapeLeft.isBigger(shapeRight)
        }.map { shape in
            shape.value as! T
        }
    }

    /**
     Exibe o a descrição de cada uma das formas.
     */
    public func printShapes() {
        shapes
            .values
            .flatMap { $0 }
            .forEach { print($0.description()) }
    }
}
