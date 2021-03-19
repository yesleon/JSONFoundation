
//
//  JSONValue.swift
//  JSONKit
//
//  Created by Li-Heng Hsu on 2021/3/7.
//

// MARK: - Primitive Types

public enum JSONNumber {
    case integer(Int)
    case float(Double)
}

extension JSONNumber: Hashable { }

public typealias JSONString = String

// MARK: - Collection Types

public typealias JSONArray = [JSONValue]

public typealias JSONObject = [JSONString: JSONValue]

// MARK: - Type Erasure

public enum JSONValue {
    case number(JSONNumber)
    case string(JSONString)
    case array(JSONArray)
    case object(JSONObject)
    case `true`
    case `false`
    case null
}

extension JSONValue: Hashable { }

extension JSONValue: ExpressibleByArrayLiteral {
    
    public typealias ArrayLiteralElement = JSONValue
    
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self = .array(elements)
    }
    
}

extension JSONValue: ExpressibleByNilLiteral {
    
    public init(nilLiteral: ()) {
        self = .null
    }
}

extension JSONValue: ExpressibleByFloatLiteral {
    
    public init(floatLiteral value: FloatLiteralType) {
        self = .number(.float(value))
    }
}

extension JSONValue: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: IntegerLiteralType) {
        self = .number(.integer(value))
    }
}

extension JSONValue: ExpressibleByDictionaryLiteral {
    
    public typealias Key = JSONString
    
    public typealias Value = JSONValue
    
    public init(dictionaryLiteral elements: (Key, Value)...) {
        let object = JSONObject(uniqueKeysWithValues: elements)
        self = .object(object)
    }
}

extension JSONValue: ExpressibleByStringInterpolation {
    
    public typealias StringLiteralType = JSONString
    
    public init(stringLiteral value: StringLiteralType) {
        self = .string(value)
    }
}

extension JSONValue: ExpressibleByBooleanLiteral {
    
    public typealias BooleanLiteralType = Bool
    
    public init(booleanLiteral value: BooleanLiteralType) {
        self = value ? .true : .false
    }
}

extension JSONValue: LosslessStringConvertible {
    
    public static var defaultStringifyOptions: JSONStringifyOptions = [.fragmentsAllowed, .prettyPrinted]
    
    public var description: String {
        do {
            return try self.stringified(options: Self.defaultStringifyOptions)
        } catch {
            return String(describing: error)
        }
    }
    
    public init?(_ description: String) {
        do {
            self = try Self.parse(description, options: .fragmentsAllowed)
        } catch {
            return nil
        }
    }
    
}
