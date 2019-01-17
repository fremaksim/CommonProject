//
//  ModelJSON.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/12/17.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation

// https://blog.csdn.net/zhaochen_009/article/details/77051054


enum Sex:String, Codable {
    
    case male
    case female
    
}

class People {
    var name: String
    var sex: Sex
    var age: Int
    
    //    init(name: String, sex: Sex, age: Int) {
    //        self.name = name
    //        self.sex = sex
    //        self.age = age
    //    }
    
    
    init(name: String, sex: Sex = .male ,age: Int) {
        //        self.init(name: name, sex: sex, age: age)
        self.name = name
        self.sex = sex
        self.age = age
    }
    
    
    private enum CodingKeys: CodingKey {
        case name, sex, age
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(sex, forKey: .sex)
        try container.encode(age, forKey: .age)
    }
    
    
}

class Teacher: People {
    var salary: Float
    var title: String?
    
    init(name: String, sex: Sex = .male, age: Int, salary: Float, title: String? = nil) {
        self.salary = salary
        self.title = title
        super.init(name: name, sex: sex, age: age)
    }
    
    override init(name: String, sex: Sex = .male, age: Int) {
        self.salary = 0
        self.title = nil
        super.init(name: name, sex: sex, age: age)
    }
    
    private enum CodingKeys: CodingKey {
        case salary, title
    }
    
}

class Student: People {
    let id: String
    init(name: String, sex: Sex = .male, age: Int, id: String) {
        self.id = id
        super.init(name: name, sex: sex, age: age)
    }
    
    required convenience init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    
}

class Class {
    let classId: String
    let name: String
    var teacher: Teacher?
    var students: [Student]?
    init(classId: String, name: String) {
        self.classId = classId
        self.name = name
    }
}


// Codable in Swift4

class Info: Decodable, Encodable {
    
    var identifier: String
    
    init(id: String) {
        self.identifier = id
    }
    
    private enum CodingKeys: String, CodingKey {case identifier}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
    }
}

class DeviceInfo: Info {
    var model: String
    
     init(id: String, model: String) {
        self.model = model
        super.init(id: id)
    }
    
    private enum CodingKeys: String, CodingKey { case model}
    required init(from decoder: Decoder) throws {
        // 1. self
        let container = try decoder.container(keyedBy: CodingKeys.self)
        model = try container.decode(String.self, forKey: .model)
        // 2. super
        let superContainer = try container.superDecoder()
        try super.init(from: superContainer)
    }
    
    override func encode(to encoder: Encoder) throws {
        // 1. self
        var containder = encoder.container(keyedBy: CodingKeys.self)
        try containder.encode(model, forKey: .model)
        // 2. super
        let superEncoder =  containder.superEncoder()
        try super.encode(to: superEncoder)
    }
}

// Nested

class Recording: Item, Codable {
    override init(name: String, uuid: UUID) {
        super.init(name: name, uuid: uuid)
    }
    enum RecordingKeys: CodingKey { case name, uuid }
    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: RecordingKeys.self)
        let uuid = try c.decode(UUID.self, forKey: .uuid)
        let name = try c.decode(String.self, forKey: .name)
        super.init(name: name, uuid: uuid)
    }
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: RecordingKeys.self)
        try c.encode(name, forKey: .name)
        try c.encode(uuid, forKey: .uuid)
    }
}
class Folder: Item, Codable {
    private(set) var contents: [Item]
    override weak var store: Store? {
        didSet {
            contents.forEach { $0.store = store }
        }
    }
    override init(name: String, uuid: UUID) {
        contents = []
        super.init(name: name, uuid: uuid)
    }
    enum FolderKeys: CodingKey { case name, uuid, contents }
    enum FolderOrRecording: CodingKey { case folder, recording }
    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: FolderKeys.self)
        contents = [Item]()
        var nested = try c.nestedUnkeyedContainer(forKey: .contents)
        while true {
            let wrapper = try nested.nestedContainer(keyedBy: FolderOrRecording.self)
            if let f = try wrapper.decodeIfPresent(Folder.self, forKey: .folder) {
                contents.append(f)
            } else if let r = try wrapper.decodeIfPresent(Recording.self, forKey: .recording) {
                contents.append(r)
            } else { break }
        }
        let uuid = try c.decode(UUID.self, forKey: .uuid)
        let name = try c.decode(String.self, forKey: .name)
        super.init(name: name, uuid: uuid)
        for c in contents {
            c.parent = self
        }
    }
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: FolderKeys.self)
        try c.encode(name, forKey: .name)
        try c.encode(uuid, forKey: .uuid)
        var nested = c.nestedUnkeyedContainer(forKey: .contents)
        for c in contents {
            var wrapper = nested.nestedContainer(keyedBy: FolderOrRecording.self)
            switch c {
            case let f as Folder: try wrapper.encode(f, forKey: .folder)
            case let r as Recording: try wrapper.encode(r, forKey: .recording)
            default: break
            }
        }
        _ = nested.nestedContainer(keyedBy: FolderOrRecording.self)
    }
}

final class Store {
    static private let documentDiorectory = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    static let shared = Store(url: documentDiorectory)
    let baseURL: URL?
    var placeholder: URL?
    private(set) var rootFolder: Folder
    
    init(url: URL?) {
        self.baseURL = url
        self.placeholder = nil
        if let u = url,
            let data = try? Data(contentsOf: u.appendingPathComponent(.storeLocation)),
            let folder = try? JSONDecoder().decode(Folder.self, from: data)
        {
            self.rootFolder = folder
        } else {
            self.rootFolder = Folder(name: "", uuid: UUID())
        }
        self.rootFolder.store = self
    }
}

fileprivate extension String {
    static let storeLocation = "store.json"
}

class Item {
    let uuid: UUID
    private(set) var name: String
    weak var store: Store?
    weak var parent: Folder? {
        didSet {
            store = parent?.store
        }
    }
    init(name: String, uuid: UUID) {
        self.name = name
        self.uuid = uuid
        self.store = nil
    }
}


struct  ModelJSON {
    
    typealias replaceSelector = (_ label: String, _ value: Any) -> (String, Any)
    
    /// Output [key,value] of the input obj
    ///
    /// - Parameters:
    ///   - obj: input
    ///   - remainFeild: not in output [key,value]
    ///   - replace: rename key, replace value
    /// - Returns: output the [key,value]
    static func convertToDictNesting(obj: Any,
                                     remainFeild: [String]? = nil,
                                     replace: replaceSelector? = nil) -> [String: Any] {
        
        var dict: [String: Any] = [:]
        var children: [Mirror.Child] = []
        if let superChildren = Mirror(reflecting: obj).superclassMirror?.children {
            children.append(contentsOf: superChildren)
        }
        children.append(contentsOf: Mirror(reflecting: obj).children)
        for child in children {
            if let key = child.label {
                if let remainFeild = remainFeild, !remainFeild.contains(key) {
                    continue
                }
                let subMirror = Mirror(reflecting: child.value)
                if let displayStyle = subMirror.displayStyle, displayStyle == .optional {
                    if subMirror.children.isEmpty {
                        continue
                    }
                }
                //parse type properties
                let subDict = convertToDictNesting(obj: child.value, remainFeild: remainFeild, replace: replace)
                if subDict.isEmpty {
                    if let replaceReturn = replace?(key, child.value) {
                        if !replaceReturn.0.isEmpty {
                            if let aryValue = replaceReturn.1 as? [Any] {
                                var dictAry: [Any] = []
                                for value in aryValue {
                                    let subDict = convertToDictNesting(obj: value, remainFeild: remainFeild, replace: replace)
                                    if subDict.isEmpty {
                                        dictAry.append(value)
                                    } else {
                                        dictAry.append(subDict)
                                    }
                                }
                                dict[replaceReturn.0] = dictAry
                            } else {
                                dict[replaceReturn.0] = replaceReturn.1
                            }
                        }
                    } else {
                        if let aryValue = child.value as? [Any] {
                            var dictAry: [Any] = []
                            for value in aryValue {
                                let subDict = convertToDictNesting(obj: value, remainFeild: remainFeild, replace: replace)
                                if subDict.isEmpty {
                                    dictAry.append(value)
                                } else {
                                    dictAry.append(subDict)
                                }
                            }
                            dict[key] = dictAry
                        } else {
                            dict[key] = child.value
                        }
                    }
                } else {
                    // only support label replace current for non-basic-data- type
                    if let replace = replace?(key, child.value) {
                        if !replace.0.isEmpty {
                            if let someDict = subDict["some"] {
                                dict[replace.0] = someDict
                            } else {
                                dict[replace.0] = subDict
                            }
                        }
                    } else {
                        if let someDict = subDict["some"] {
                            dict[key] = someDict
                        } else {
                            dict[key] = subDict
                        }
                    }
                }
            }
        }
        return dict
    }
    
}
