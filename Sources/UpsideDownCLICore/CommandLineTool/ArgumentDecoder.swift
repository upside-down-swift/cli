//
//  ArgumentDecoder.swift
//
//  Created by Marcus Smith on 4/28/19.
//

import Foundation
import Utility

public struct ArgumentDecoder: Decoder {
    public struct Error: LocalizedError {
        let message: String
        
        init(_ message: String) {
            self.message = message
        }
        
        public var errorDescription: String? {
            return message
        }
    }
    
    private let result: ArgumentParser.Result
    private let options: CommandOptions
    public let codingPath: [CodingKey] = []
    public let userInfo: [CodingUserInfoKey : Any] = [:]
    
    public init(result: ArgumentParser.Result, options: CommandOptions) {
        self.result = result
        self.options = options
    }
    
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(ArgumentDecodingContainer(result: result, options: options))
    }
    
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw Error("Invalid Container Type")
    }
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw Error("Invalid Container Type")
    }
}

private struct ArgumentValueDecoder: Decoder {
    let container: ArgumentSingleValueDecodingContainer
    let userInfo: [CodingUserInfoKey : Any] = [:]
    
    var codingPath: [CodingKey] {
        return container.codingPath
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        throw ArgumentDecoder.Error("Invalid Container Type")
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        let value = try container.argument.getAsArray(from: container.result)
        return ArgumentUnkeyedDecodingContainer(codingPath: codingPath, value: value)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return container
    }
}

struct ArgumentDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    private let result: ArgumentParser.Result
    private let options: CommandOptions
    let codingPath: [CodingKey] =  []
    var allKeys: [Key] {
        return options.keys.compactMap(Key.init)
    }
    
    init(result: ArgumentParser.Result, options: CommandOptions) {
        self.result = result
        self.options = options
    }
    
    func contains(_ key: Key) -> Bool {
        return options.keys.contains(key.stringValue)
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        let container = try createContainer(for: key)
        return container.decodeNil()
    }
    
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        let container = try createContainer(for: key)
        return try container.decode(type)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw ArgumentDecoder.Error("Invalid Container Type")
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        return try createUnkeyedContainer(for: key)
    }
    
    func superDecoder() throws -> Decoder {
        throw ArgumentDecoder.Error("Invalid Container Type")
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        throw ArgumentDecoder.Error("Invalid Container Type")
    }
    
    private func createContainer(for key: Key) throws -> ArgumentSingleValueDecodingContainer {
        let argument = try getArgument(for: key)
        return ArgumentSingleValueDecodingContainer(codingPath: codingPath + [key], argument: argument, result: result)
    }
    
    private func createUnkeyedContainer(for key: Key) throws -> ArgumentUnkeyedDecodingContainer {
        let argument = try getArgument(for: key)
        let value = try argument.getAsArray(from: result)
        return ArgumentUnkeyedDecodingContainer(codingPath: codingPath + [key], value: value)
    }
    
    private func getArgument(for key: Key) throws -> AnyArgument {
        guard let argument = options.arguments[key.stringValue] else {
            throw ArgumentDecoder.Error("Argument does not exist for \(key.stringValue)")
        }
        
        return argument
    }
}

struct ArgumentUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    private let value: Array<Any>?
    let codingPath: [CodingKey]
    
    var count: Int? {
        return value?.count
    }
    
    var isAtEnd: Bool {
        guard let value = value else {
            return true
        }
        
        return currentIndex >= value.count
    }
    
    private(set) var currentIndex: Int = 0
    
    init(codingPath: [CodingKey], value: Array<Any>?) {
        self.codingPath = codingPath
        self.value = value
    }
    
    mutating func nextValue() throws -> Any {
        guard let value = value else {
            let key = codingPath.last
            let message = key == nil ? "Missing value" : "Missing value for key \(key!.stringValue)"
            throw ArgumentDecoder.Error(message)
        }
        
        let next = value[currentIndex]
        currentIndex += 1
        return next
    }
    
    mutating func nextValue<T>(as t: T.Type) throws -> T {
        let next = try nextValue()
        guard let castNext = next as? T else {
            throw ArgumentDecoder.Error("expected \(String(describing: T.self)) but received \(String(describing: type(of: next)))")
        }
        
        return castNext
    }
    
    mutating func decodeNil() throws -> Bool {
        return value == nil
    }
    
    mutating func decode(_ type: Bool.Type) throws -> Bool {
        return try nextValue(as: type)
    }
    
    mutating func decode(_ type: String.Type) throws -> String {
        return try nextValue(as: type)
    }
    
    mutating func decode(_ type: Double.Type) throws -> Double {
        return try nextValue(as: type)
    }
    
    mutating func decode(_ type: Float.Type) throws -> Float {
        return try nextValue(as: type)
    }
    
    mutating func decode(_ type: Int.Type) throws -> Int {
        return try nextValue(as: type)
    }
    
    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        return try nextValue(as: type)
    }
    
    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        return try nextValue(as: type)
    }
    
    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        return try nextValue(as: type)
    }
    
    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        return try nextValue(as: type)
    }
    
    mutating func decode(_ type: UInt.Type) throws -> UInt {
        return try nextValue(as: type)
    }
    
    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        return try nextValue(as: type)
    }
    
    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        return try nextValue(as: type)
    }
    
    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        return try nextValue(as: type)
    }
    
    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        return try nextValue(as: type)
    }
    
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        return try nextValue(as: type)
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw ArgumentDecoder.Error("Invalid Container Type")
    }
    
    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw ArgumentDecoder.Error("Invalid Container Type")
    }
    
    mutating func superDecoder() throws -> Decoder {
        throw ArgumentDecoder.Error("Invalid Container Type")
    }
}

struct ArgumentSingleValueDecodingContainer: SingleValueDecodingContainer {
    let argument: AnyArgument
    let result: ArgumentParser.Result
    let codingPath: [CodingKey]
    
    init(codingPath: [CodingKey], argument: AnyArgument, result: ArgumentParser.Result) {
        self.codingPath = codingPath
        self.argument = argument
        self.result = result
    }
    
    func decodeNil() -> Bool {
        do {
            let value = try argument.get(Bool.self, from: result)
            return value == nil
        } catch {
            return false // Type mismatch means it wasn't nil
        }
    }
    
    func getValue<T>(_ type: T.Type) throws -> T? {
        return try argument.get(type, from: result)
    }
    
    func getNonOptionalValue<T>(_ type: T.Type) throws -> T {
        guard let value = try argument.get(type, from: result) else {
            let key = codingPath.last
            let message = key == nil ? "Missing value" : "Missing value for key \(key!.stringValue)"
            throw ArgumentDecoder.Error(message)
        }
        
        return value
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        return (try getValue(type) == true)
    }
    
    func decode(_ type: String.Type) throws -> String {
        return try getNonOptionalValue(type)
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        return try getNonOptionalValue(type)
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        return try getNonOptionalValue(type)
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        return try getNonOptionalValue(type)
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        return try getNonOptionalValue(type)
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        return try getNonOptionalValue(type)
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        return try getNonOptionalValue(type)
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        return try getNonOptionalValue(type)
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        return try getNonOptionalValue(type)
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        return try getNonOptionalValue(type)
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        return try getNonOptionalValue(type)
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        return try getNonOptionalValue(type)
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        return try getNonOptionalValue(type)
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        return try T.init(from: ArgumentValueDecoder(container: self))
    }
}
