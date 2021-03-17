
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

extension JSONNumber: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: IntegerLiteralType) {
        self = .integer(value)
    }
}

extension JSONNumber: ExpressibleByFloatLiteral {
    
    public init(floatLiteral value: FloatLiteralType) {
        self = .float(value)
    }
}

extension JSONNumber: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .float(let float):
            return float.description
            
        case .integer(let integer):
            return integer.description
        }
    }
}

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
        self = .number(.init(floatLiteral: value))
    }
}

extension JSONValue: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: IntegerLiteralType) {
        self = .number(.init(integerLiteral: value))
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

extension JSONValue: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .array(let array):
            let count = array.count
            if count == 0 {
                return "Array (empty)"
            } else if count == 1 {
                return "Array (1 element)"
            } else {
                return "Array (\(count) elements)"
            }
            
        case .false:
            return "false"
            
        case .null:
            return "null"
            
        case .number(let number):
            return number.description
            
        case .object(let object):
            let count = object.count
            if count == 0 {
                return "Object (empty)"
            } else if count == 1 {
                return "Object (1 member)"
            } else {
                return "Object (\(count) members)"
            }
            
            
        case .string(let string):
            return "\"\(string)\""
            
        case .true:
            return "true"
        }
    }
    
}
