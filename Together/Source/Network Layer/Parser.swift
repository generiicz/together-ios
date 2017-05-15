//
//  ParserService.swift
//  Together
//
//  Created by developer on 04.05.17.
//  Copyright © 2017 Together. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper
import PromiseKit

class Parser<Target: Mappable> {

    class func convert(raw: String, paths: [String]) -> Promise<[Target]> {
        return Promise(resolvers: { (fulfill, reject) in
            guard let json = self.startPoint(value: raw, paths: paths) else {
                reject(CatchError.invalideJSON)
                return
            }
            
            var _objects: [Target] = []
            
            if let array = json.array {
                for item in array {
                    guard let raw = item.rawString() else {
                        continue
                    }
                    if let _object = Mapper<Target>().map(JSONString: raw) {
                        _objects.append(_object)
                    }
                }
            } else {
                if let raw = json.rawString() {
                    guard let _object = Mapper<Target>().map(JSONString: raw) else {
                        reject(CatchError.nullObject)
                        return
                    }
                    _objects.append(_object)
                }
            }
            
            if _objects.isEmpty {
                reject(CatchError.emptyArray)
            } else {
                fulfill(_objects)
            }
        })
    }
    
    // MARK: Private
    private class func startPoint(value: String, paths: [String] = ["data"]) -> JSON? {
        guard let data = value.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        var json = JSON(data)
        
        for path in paths {
            json = json[path]
        }
        
        return json
    }
}
