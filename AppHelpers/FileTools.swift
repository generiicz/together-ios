//
//  FileTools.swift
//  SQLtest-1
//
//  Created by Андрей Цай on 22.06.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation

struct FileTools {
    
    static let fileManager = FileManager.default
    
    static var pathToDocs: URL {
        return FileTools.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func splitFileName(_ filename: String) -> (String, String?){
        let sepFileName = filename.components(separatedBy: ".")
        let fileName = sepFileName[0]
        var fileExt: String? = nil
        if sepFileName.count > 1 {
            fileExt = sepFileName[1]
        }
        return (fileName, fileExt)
    }
    
    static func getPathForResource (_ name: String, subdir: String?) -> String?{
        let splitName = FileTools.splitFileName(name)
        let res = Bundle.main.path(
            forResource: splitName.0,
            ofType:splitName.1,
            inDirectory: subdir
        )
        return res
    }
    
    static func createDirInDocs (_ subpath: String) throws {
        let docs = FileTools.pathToDocs
        do {
            try FileTools.fileManager.createDirectory(
                at: docs.appendingPathComponent(subpath),
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch let e as NSError {
            throw e
        }
    }
    
    static func getPath(_ fileName: String) -> URL {
        let documentsURL = FileTools.pathToDocs
        let fileURL = documentsURL.appendingPathComponent(fileName)
        return fileURL
    }
    
    static func copyFileToDocs(_ filename:String, subpath: String?) throws {
        let splitName = FileTools.splitFileName(filename)
        let FileName = splitName.0
        let FileExt = splitName.1
        let dirPaths =  NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as String
        let destPath = (docsDir as NSString).appendingPathComponent("/"+filename)
        if let path = Bundle.main.path(forResource: FileName, ofType:FileExt, inDirectory: subpath) {
            //print(path)
            do {
                try FileTools.fileManager.copyItem(atPath: path, toPath: destPath)}
            catch let copyError as NSError {
                throw copyError
            }
        } else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError, userInfo: ["Error!":"Can't find resource: "+filename])
        }
    }
}
