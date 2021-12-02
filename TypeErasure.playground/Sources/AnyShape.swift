import Foundation

public final class AnyShape {
    public let value: Any
    public let isBigger: (AnyShape) -> Bool
    public let description: () -> String

    public init<T: Shape>(_ shape: T) {
        value = shape
        isBigger = { shape.isBigger(than: $0.value as! T) }
        description = { shape.description }
    }
}
