//
//  File.swift
//  
//
//  Created by 許立衡 on 2021/3/16.
//

import Foundation

public typealias JSONStringifyOptions = JSONSerialization.WritingOptions
public typealias JSONParseOptions = JSONSerialization.ReadingOptions

public enum JSONError: Error {
    case wrongType(Any?)
    case stringifyFailure(Data)
    case stringDecodeFailure(String)
}

extension JSONValue {
    
    private init(value: Any) throws {
        switch value {
        case let object as [JSONString: Any]:
            self = .object(try object.mapValues(Self.init(value:)))
            
        case let array as [Any]:
            self = .array(try array.map(Self.init(value:)))
            
        case let string as JSONString:
            self = .string(string)
            
        case let number as JSONNumber:
            self = .number(number)
            
        case let bool as Bool:
            self = bool ? .true : .false
            
        case nil, is NSNull:
            self = .null
            
        default:
            throw JSONError.wrongType(type(of: value))
        }
    }
    
    private func extracted() -> Any? {
        switch self {
        case .array(let array):
            return array.map { $0.extracted() }
            
        case .true:
            return true
            
        case .false:
            return false
            
        case .null:
            return nil
            
        case .number(let number):
            return number
            
        case .object(let object):
            return object.mapValues { $0.extracted() }
            
        case .string(let string):
            return string
        }
    }
    
    public static func parse(_ string: String, options: JSONParseOptions) throws -> JSONValue {
        guard let data = string.data(using: .utf8) else {
            throw JSONError.stringDecodeFailure(string)
        }
        return try parse(data, options: options)
    }
    
    public static func parse(_ data: Data, options: JSONParseOptions) throws -> JSONValue {
        let value = try JSONSerialization.jsonObject(with: data, options: options)
        return try self.init(value: value)
    }
    
    public func serialized(options: JSONStringifyOptions) throws -> Data {
        return try JSONSerialization.data(withJSONObject: extracted() as Any, options: options)
    }
    
    public func stringified(options: JSONStringifyOptions) throws -> JSONString {
        
        let data = try serialized(options: options)
        guard let string = JSONString(data: data, encoding: .utf8) else {
            throw JSONError.stringifyFailure(data)
        }
        return string
    }
}
