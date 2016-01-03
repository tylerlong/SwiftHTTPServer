//
//  HttpHandlers.swift
//  SwiftHTTPServer
//  Copyright (c) 2015 Tylingsoft. All rights reserved.
//

import Foundation

public class HttpHandlers {

    public class func directory(dir: String) -> ( HttpRequest -> HttpResponse ) {
        return { request in
            if let localPath = request.capturedUrlGroups.first {
                if localPath == "" || localPath.rangeOfString(".") == nil { // root path or folder path
                    for index in ["index.html", "index.htm"] {
                        let filesPath = dir.stringByExpandingTildeInPath.stringByAppendingPathComponent(localPath).stringByAppendingPathComponent(index)
                        if let fileBody = NSData(contentsOfFile: filesPath) {
                            return HttpResponse.RAW(200, "OK", nil, fileBody)
                        }
                    }
                } else { // file path
                    let filesPath = dir.stringByExpandingTildeInPath.stringByAppendingPathComponent(localPath)
                    if let fileBody = NSData(contentsOfFile: filesPath) {
                        return HttpResponse.RAW(200, "OK", nil, fileBody)
                    }
                }
            }
            return HttpResponse.NotFound
        }
    }

    public class func directoryBrowser(dir: String) -> ( HttpRequest -> HttpResponse ) {
        return { request in
            if let pathFromUrl = request.capturedUrlGroups.first {
                let filePath = dir.stringByExpandingTildeInPath.stringByAppendingPathComponent(pathFromUrl)
                let fileManager = NSFileManager.defaultManager()
                var isDir: ObjCBool = false;
                if ( fileManager.fileExistsAtPath(filePath, isDirectory: &isDir) ) {
                    if ( isDir ) {
                        do {
                            let files = try fileManager.contentsOfDirectoryAtPath(filePath)
                            var response = "<h3>\(filePath)</h3></br><table>"
                            response += files.map({ "<tr><td><a href=\"\(request.url)/\($0)\">\($0)</a></td></tr>"}).joinWithSeparator("")
                            response += "</table>"
                            return HttpResponse.OK(.HTML(response))
                        } catch  {
                            return HttpResponse.NotFound
                        }
                    } else {
                        if let fileBody = NSData(contentsOfFile: filePath) {
                            return HttpResponse.RAW(200, "OK", nil, fileBody)
                        }
                    }
                }
            }
            return HttpResponse.NotFound
        }
    }
}

private extension String {

    var stringByExpandingTildeInPath: String {
        return (self as NSString).stringByExpandingTildeInPath
    }

    func stringByAppendingPathComponent(str: String) -> String {
        return (self as NSString).stringByAppendingPathComponent(str)
    }

}
