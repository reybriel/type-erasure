import Foundation

public struct Circle: Shape {
    public struct Attributes {
        let ray: Double
    }

    public let attributes: Attributes

    public var description: String {
        "Circle of ray \(attributes.ray) and area \(area)"
    }

    public var area: Double {
        Double.pi * pow(attributes.ray, 2)
    }

    public init(ray: Double) {
        attributes = Attributes(ray: ray)
    }
}
