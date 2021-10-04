import Foundation

protocol Shape {
    associatedtype Attributes // Cada forma terá um grupo de atributos diferente
    
    var area: Double { get }
    var description: String { get }
    var attributes: Attributes { get }
    
    func isBigger(than shape: Self) -> Bool // Comparação entre diferentes formas não é permitido
}

extension Shape {
    func isBigger(than shape: Self) -> Bool {
        area > shape.area
    }
    
    func print() {
        Swift.print(description)
    }
}

struct Circle: Shape {
    struct Attributes {
        let ray: Double
    }
    
    let attributes: Attributes
    
    var description: String {
        "Circle of ray \(attributes.ray) and area \(area)"
    }
    
    var area: Double {
        Double.pi * pow(attributes.ray, 2)
    }
}

struct Rectangle: Shape {
    struct Attributes {
        let height: Double
        let width: Double
    }
    
    let attributes: Attributes
    
    var description: String {
        "Rectangle of height \(attributes.height), width \(attributes.width) and area \(area)"
    }
    
    var area: Double {
        attributes.height * attributes.width
    }
}

// Type Erasure

final class AnyShape {
    let value: Any
    let print: () -> Void
    let isBigger: (AnyShape) -> Bool
    
    init<T: Shape>(_ shape: T) {
        value = shape
        print = { shape.print() }
        isBigger = { shape.isBigger(than: $0.value as! T) }
    }
}

var shapes = [AnyShape]()

func didCreate<T: Shape>(shape: T) {
    shapes.append(AnyShape(shape))
}

didCreate(shape: Circle(attributes: Circle.Attributes(ray: 5)))
didCreate(shape: Circle(attributes: Circle.Attributes(ray: 3)))
didCreate(shape: Rectangle(attributes: Rectangle.Attributes(height: 5, width: 5)))

let sortedShapes = shapes.sorted { s1, s2 in
    s1.isBigger(s2)
}

// Esta linha de código causa um crash por causa da comparação entre diferentes tipos.
//sortedShapes.forEach { $0.print() }

/*
 Para que o uso do tipo AnyShape seja feito de forma segura, é necessário garantir que ele
 será utilizado em contextos onde a implementação é conhecida.
 
 Alguém precisa ter a responsabilidade de garantir que formas diferentes não vão ser comparadas
 entre si. Normalmente o compilador exerce essa função pela própria IDE, mas como o compilador
 foi silenciado pelo AnyShape, o novo responsável pela segurança de comparação entre shapes é o
 ShapesManager.
 */

final class ShapesManager {
    private var shapes = [String: [AnyShape]]() // Separa as formas por tipo
    
    /// Aceita inserção de qualquer forma, tirando proveito do comportamento genérico desejado.
    ///
    /// Uso demonstrado nas linhas 132 à 138.
    func add<T: Shape>(shape: T) {
        var shapesList: [AnyShape]
        let typeName = String(describing: T.Type.self)
        
        if let shapes = shapes[typeName] {
            shapesList = shapes
        } else {
            shapesList = [AnyShape]()
        }
        
        shapes[typeName] = shapesList + [AnyShape(shape)]
    }
    
    /// Executa a ordenação das formas por tipo, garantindo que tipos diferentes não serão comparados.
    ///
    /// Uso demonstrado nas linhas 140 à 144.
    func sortedShapes<T: Shape>(ofType: T.Type) -> [T] {
        let typeName = String(describing: T.Type.self)
        
        guard let shapes = shapes[typeName] else {
            return []
        }
        
        return shapes.sorted { !$0.isBigger($1) }.map { $0.value as! T }
    }
}

let shapesManager = ShapesManager()

shapesManager.add(shape: Circle(attributes: Circle.Attributes(ray: 5)))
shapesManager.add(shape: Circle(attributes: Circle.Attributes(ray: 2)))
shapesManager.add(shape: Circle(attributes: Circle.Attributes(ray: 3)))

shapesManager.add(shape: Rectangle(attributes: Rectangle.Attributes(height: 5, width: 3)))
shapesManager.add(shape: Rectangle(attributes: Rectangle.Attributes(height: 2, width: 4)))
shapesManager.add(shape: Rectangle(attributes: Rectangle.Attributes(height: 3, width: 3)))

print("Sorted circles")
shapesManager.sortedShapes(ofType: Circle.self).forEach { $0.print() }

print("Sorted rectangles")
shapesManager.sortedShapes(ofType: Rectangle.self).forEach { $0.print() }
