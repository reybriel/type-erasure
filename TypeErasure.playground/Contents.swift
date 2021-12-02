import Foundation

// Erros e riscos

var shapes = [AnyShape]()

func didCreate<T: Shape>(shape: T) {
    shapes.append(AnyShape(shape))
}

didCreate(shape: Circle(ray: 5))
didCreate(shape: Circle(ray: 3))
didCreate(shape: Rectangle(height: 5, width: 5))

// Este código causa um crash porque não é permitida a comparação entre diferentes tipos
//let _ = shapes.sorted { s1, s2 in
//    s1.isBigger(s2)
//}

/*
 Para que o uso do tipo AnyShape seja feito de forma segura, é necessário garantir que ele
 será utilizado em contextos onde a implementação é conhecida.

 Alguém precisa ter a responsabilidade de garantir que formas diferentes não vão ser comparadas
 entre si. Normalmente o compilador exerce essa função pela própria IDE, mas como o compilador
 foi silenciado pelo AnyShape, o novo responsável pela segurança de comparação entre shapes é o
 ShapesManager.
 */

let shapesManager = ShapesManager()

shapesManager.add(shape: Circle(ray: 5))
shapesManager.add(shape: Circle(ray: 2))
shapesManager.add(shape: Circle(ray: 3))

shapesManager.add(shape: Rectangle(height: 5, width: 3))
shapesManager.add(shape: Rectangle(height: 2, width: 4))
shapesManager.add(shape: Rectangle(height: 3, width: 3))

print("")
print("Sorted circles")
shapesManager.sortedShapes(ofType: Circle.self).forEach { print($0.description) }

print("")
print("Sorted rectangles")
shapesManager.sortedShapes(ofType: Rectangle.self).forEach { print($0.description) }

print("")
print("All shapes")
shapesManager.printShapes()

print("")
print("Program end")
