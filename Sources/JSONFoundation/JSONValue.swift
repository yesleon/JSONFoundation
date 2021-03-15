
//
//  JSONValue.swift
//  JSONKit
//
//  Created by Li-Heng Hsu on 2021/3/7.
//
import Foundation.NSDecimal

public typealias JSONNumber = Decimal
public typealias JSONString = String
public typealias JSONArray = [JSONValue]
public typealias JSONObject = [JSONString: JSONValue]



public enum JSONValue {
    case number(JSONNumber)
    case string(JSONString)
    case array(JSONArray)
    case object(JSONObject)
    case `true`
    case `false`
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
    
    public init(floatLiteral value: Double) {
        self = .number(JSONNumber(value))
    }
}

extension JSONValue: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Int) {
        self = .number(JSONNumber(value))
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
    
    public init(booleanLiteral value: Bool) {
        self = value ? .true : .false
    }
}
