import Foundation

public struct Rectangle: Shape {
    public struct Attributes {
        let height: Double
        let width: Double
    }

    public let attributes: Attributes

    public var description: String {
        "Rectangle of height \(attributes.height), width \(attributes.width) and area \(area)"
    }

    public var area: Double {
        attributes.height * attributes.width
    }

    public init(height: Double, width: Double) {
        attributes = Attributes(height: height, width: width)
    }
}
