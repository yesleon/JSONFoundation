
//
//  JSONValue.swift
//  JSONKit
//
//  Created by Li-Heng Hsu on 2021/3/7.
//


public typealias JSONNumber = Double
public typealias JSONBool = Bool
public typealias JSONString = String
public typealias JSONArray = [JSONValue]
public typealias JSONObject = [JSONString: JSONValue]



public enum JSONValue {
    case bool(JSONBool)
    case number(JSONNumber)
    case string(JSONString)
    case array(JSONArray)
    case object(JSONObject)
    case null
}

extension JSONValue: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: JSONValue...) {
        self = .array(elements)
    }
}

extension JSONValue: ExpressibleByNilLiteral {
    
    public init(nilLiteral: ()) {
        self = .null
    }
}

extension JSONValue: ExpressibleByFloatLiteral {
    
    public init(floatLiteral value: JSONNumber) {
        self = .number(value)
    }
}

extension JSONValue: ExpressibleByDictionaryLiteral {
    
    public init(dictionaryLiteral elements: (JSONString, JSONValue)...) {
        let object = JSONObject(uniqueKeysWithValues: elements)
        self = .object(object)
    }
}

extension JSONValue: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: JSONString) {
        self = .string(value)
    }
}

extension JSONValue: ExpressibleByStringInterpolation { }

extension JSONValue: ExpressibleByBooleanLiteral {
    
    public init(booleanLiteral value: JSONBool) {
        self = .bool(value)
    }
}

extension JSONValue: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Int) {
        self = .number(JSONNumber(value))
    }
}
