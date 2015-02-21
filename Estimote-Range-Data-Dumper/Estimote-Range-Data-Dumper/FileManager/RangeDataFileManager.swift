//
//  RangeDataFileManager.swift
//  Estimote-Range-Data-Dumper
//
//  Created by Jacob Chen on 2/20/15.
//  Copyright (c) 2015 Looped LLC. All rights reserved.
//

import Foundation


private let _SingletonSharedFileManager = RangeDataFileManager()

class RangeDataFileManager: NSObject {
    
    var fileHandle: NSFileHandle?
    var fileManager: NSFileManager = NSFileManager()
    var range: NSNumber?
    var contentToWrite: String = ""
    var fileurl:NSURL?
    
    class var sharedFileManager : RangeDataFileManager {
        
        return _SingletonSharedFileManager
        
    }
    
    func openFile(range: NSNumber) -> Bool {
        
        // Make path string
        
        let dir: NSURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as NSURL
        
        fileurl = dir.URLByAppendingPathComponent("\(range)-ft.txt")
        
        // Create or overwrite the file
        let content: String = "Range file for \(range)\r\n"
        if fileManager.createFileAtPath(
            fileurl!.path!,
            contents: content.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false),
            attributes: nil) {
            
                // open up the file for writing
                
                self.range = range
                contentToWrite = ""
                return true
        } else {
            println ("File does not exist")
            return false
        }
        
    }
    
    func write (
        rssiReading: String
        ) {
            contentToWrite = contentToWrite + "\(rssiReading)\r\n"
    }
    
    func close () -> Bool{
        var err:NSError?
        fileHandle = NSFileHandle(forUpdatingURL: self.fileurl!, error: &err)
        
        if (fileHandle == nil) {
            println("File open failed, error is: \(err)")
            return false
        } else {
            let data = contentToWrite.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            fileHandle!.seekToEndOfFile()
            fileHandle!.writeData(data)
            fileHandle!.closeFile()
            return true
        }
        
    }
    
    func exists (path: String) -> Bool {
        
        return NSFileManager().fileExistsAtPath(path)
        
    }
    
}