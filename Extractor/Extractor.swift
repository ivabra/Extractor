//
//  Extractor.swift
//  Extractor
//
//  Created by Ivan Brazhnikov on 14.03.16.
//  Copyright © 2016 Ivan Brazhnikov. All rights reserved.
//

import Foundation

public typealias Object = [String : AnyObject]

public enum Errors: ErrorType {
    case InvalidValueForKey(key: Any, object: Any)
    case NotExtractorObject(object: AnyObject)
}

public protocol Parceable {
    init(object: Object) throws
}

extension Parceable {
    public init(object: AnyObject) throws {
        if object is Object {
            try self.init(object: object as! Object)
        } else {
            throw Errors.NotExtractorObject(object: object)
        }
    }
}

extension Dictionary {
    
    public func requiredArray<T>(key: Key, _ type: T.Type) throws -> [T] {
        if let a = self[key] as? [T] {
            return a
        } else {
            throw Errors.InvalidValueForKey(key: key, object: self)
        }
    }
    
    
    
    public func requiredArray<T : Parceable>(key: Key, _ type: T.Type) throws -> [T] {
        if let a = self[key] as? [Object] {
            return try a.map{ try T.init(object: $0)}
        } else {
            throw Errors.InvalidValueForKey(key: key, object: self)
        }
    }
    
    public func requiredArray<T,R>(key: Key, _ type: T.Type, @noescape _ mapBlock:  T throws -> R) throws -> [R] {
        return try requiredArray(key, T.self).map(mapBlock)
    }
    
    public func required<T>(key: Key, _ type: T.Type) throws -> T {
        if let a = self[key] as? T {
            return a
        } else {
            throw Errors.InvalidValueForKey(key: key, object: self)
        }
    }
    
    public func required<T,R>(key: Key, _ type: T.Type, @noescape _ map:  T throws -> R) throws -> R {
        return try map(try required(key, T.self))
    }
    
    
    public func required<T : Parceable>(key: Key, _ type: T.Type) throws -> T {
        if let a = self[key] as? Object {
            return try T.init(object: a)
        } else {
            throw Errors.InvalidValueForKey(key: key, object: self)
        }
    }
    
    
    public func optional<T>(key: Key, _ type: T.Type) -> T? {
        return self[key] as? T
    }
    
    
    public func optional<T : Parceable>(key: Key, _ type: T.Type) -> T? {
        return try? required(key, type)
    }
    
    public func optional<T,R>(key: Key, _ type: T.Type, @noescape _ mapBlock:  T throws -> R) -> R? {
        return try? required(key, type, mapBlock)
    }
    
    
    
    
    public func optionalArray<T>(key: Key, _ type: T.Type) -> [T]? {
        return self[key] as? [T]
    }
    
    
    
    public func optionalArray<T : Parceable>(key: Key, _ type: T.Type) -> [T]? {
        return try? requiredArray(key, type)
    }
    
    public func optionalArray<T,R>(key: Key, _ type: T.Type, @noescape _ mapBlock:  T throws -> R) -> [R]? {
        return try? requiredArray(key, type, mapBlock)
    }
    
    
    
}