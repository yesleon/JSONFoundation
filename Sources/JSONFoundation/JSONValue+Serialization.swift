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
    case wrongType(Any)
    case stringifyFailure(Data)
    case stringDecodeFailure(String)
    case castFailure(Any)
}

public protocol JSONCompatible {
    func eraseToJSONValue() throws -> JSONValue
}

extension Dictionary: JSONCompatible where Key == String, Value == Any {
    
    public func eraseToJSONValue() throws -> JSONValue {
        let object = try self.mapValues { value -> JSONValue in
            guard let jsonCompatible = value as? JSONCompatible else {
                throw JSONError.castFailure(value)
            }
            return try jsonCompatible.eraseToJSONValue()
        }
        return .object(object)
    }
    
}

extension Array: JSONCompatible where Element == Any {
    
    public func eraseToJSONValue() throws -> JSONValue {
        let array = try self.map { element -> JSONValue in
            guard let jsonCompatible = element as? JSONCompatible else {
                throw JSONError.castFailure(element)
            }
            return try jsonCompatible.eraseToJSONValue()
        }
        return .array(array)
    }
}

extension String: JSONCompatible {
    
    public func eraseToJSONValue() throws -> JSONValue {
        return .string(self)
    }
}

extension Int: JSONCompatible {
    
    public func eraseToJSONValue() throws -> JSONValue {
        return .number(.integer(self))
    }
}

extension Double: JSONCompatible {
    
    public func eraseToJSONValue() throws -> JSONValue {
        return .number(.float(self))
    }
}

extension Bool: JSONCompatible {
    
    public func eraseToJSONValue() throws -> JSONValue {
        return self ? .true : .false
    }
}

extension Optional: JSONCompatible where Wrapped == Any {
    
    public func eraseToJSONValue() throws -> JSONValue {
        if let wrapped = self {
            if let wrapped = wrapped as? JSONCompatible {
                return try wrapped.eraseToJSONValue()
            } else {
                throw JSONError.castFailure(wrapped)
            }
        } else {
            return .null
        }
    }
}

extension NSNull: JSONCompatible {
    
    public func eraseToJSONValue() throws -> JSONValue {
        return .null
    }
}

extension NSDictionary: JSONCompatible {
    public func eraseToJSONValue() throws -> JSONValue {
        guard let dict = self as? [String: Any] else {
            throw JSONError.castFailure(self)
        }
        return try dict.eraseToJSONValue()
    }
}

extension NSArray: JSONCompatible {
    public func eraseToJSONValue() throws -> JSONValue {
        guard let array = self as? [Any] else {
            throw JSONError.castFailure(self)
        }
        return try array.eraseToJSONValue()
    }
}

extension NSNumber: JSONCompatible {
    public func eraseToJSONValue() throws -> JSONValue {
        if CFNumberIsFloatType(self as CFNumber) {
            return try doubleValue.eraseToJSONValue()
        } else {
            return try intValue.eraseToJSONValue()
        }
    }
}

extension NSString: JSONCompatible {
    public func eraseToJSONValue() throws -> JSONValue {
        return try (self as String).eraseToJSONValue()
    }
}


extension JSONValue: JSONCompatible {
    
    public func eraseToJSONValue() throws -> JSONValue {
        return self
    }
}

extension JSONValue {
    
    private func extracted() -> Any {
        switch self {
        case .array(let array):
            return array.map { $0.extracted() }
            
        case .true:
            return true
            
        case .false:
            return false
            
        case .null:
            return Optional<Any>.none as Any
            
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
        guard let jsonCompatible = value as? JSONCompatible else {
            throw JSONError.wrongType(value)
        }
        return try jsonCompatible.eraseToJSONValue()
    }
    
    public func serialized(options: JSONStringifyOptions) throws -> Data {
        return try JSONSerialization.data(withJSONObject: extracted(), options: options)
    }
    
    public func stringified(options: JSONStringifyOptions) throws -> JSONString {
        
        let data = try serialized(options: options)
        guard let string = JSONString(data: data, encoding: .utf8) else {
            throw JSONError.stringifyFailure(data)
        }
        return string
    }
}
