//
//  BackEndOverlay.swift
//  Academia
//
//  Created by Андрей Цай on 29.06.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation
import Alamofire
import GoogleMaps

struct BackEndOverlay {
    static let site = "http://127.0.0.1" //
    static let port = "5555"
    static let checkURL = "/validate"
    static let imagesURL = "/images/dishes"
    static let sendSearchURL = "/pokemons/search"
    static let pingSearchURL = "/pokemons"
    static let authURL = "/auth/token"
    static let pokSecret = "KoukoNiWaJibunNoPokemonWoTsukamaetemasNoBashoDesu@0959072916"
    static let GoogleMapsStaticURL = "https://maps.googleapis.com/maps/api/staticmap?"
    static let errorDictionary = [
        -2 : "General Error",
        -3 : "Wrong username/password",
        -4 : "Servers offline",
        -5 : "Can't load profile from server",
        -6 : "Profile loading timeout"
    ]
    
    static func decodeServerError(code: Int) -> String {
        var res = "General Error"
        if let message = BackEndOverlay.errorDictionary[code] {
            res = message
        }
        return res
    }
    
    static func formatURL(server: String, port: String, path: String) -> NSURL {
        if let res = NSURL(string: server + ":" + port + path) {
            return res
        } else {
            return (NSURL(string: self.site + ":" + self.port + self.checkURL))!
        }
    }
    
    static func checkConnection(site: String, port: String, completion: (NSError?, Bool) -> Void){
        Alamofire.request(
            .POST,
            self.formatURL(site, port: port, path: self.checkURL),
            parameters: [
                "himitsu": BackEndOverlay.pokSecret
            ],
            encoding: .JSON,
            headers: nil).validate().responseJSON{ (responce) -> Void in
                var res = false
                guard responce.result.isSuccess else {
                    //print ("Error GET menu!\n", responce.result.error?.code , responce.result.error?.localizedDescription)
                    completion(responce.result.error, res)
                    return
                }
                if let validateData = responce.result.value as? NSDictionary {
                    print (validateData)
                    res = validateData["validate"] as! Bool
                }
                completion(responce.result.error, res)
        }
    }
    
    static func makeGoogleStaticMapURL (latitude: Double, longtitude: Double, width: Int, height: Int,  zoom: Int, scale: Int) -> NSURL {
        
        let params: [String: String] = [
            "center": "\(latitude),\(longtitude)",
            "zoom": "\(zoom)",
            "size": "\(width)x\(height)",
            "scale": "\(scale)",
            "format": "png",
            "maptype": "roadmap",
            "style": "visibility:on",
            "markers": "size:mid|color:red|\(latitude),\(longtitude)",
            //"key": "\(AppHelpers.GoogleMapsAPIkey)"
        ]
        var tmpStr = "\(BackEndOverlay.GoogleMapsStaticURL)"
        var tmpList: Array<String> = []
        for (parKey, parValue) in params {
            tmpList.append("\(parKey)=\(parValue)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())! )
        }
        tmpStr.appendContentsOf(tmpList.joinWithSeparator("&"))
        return NSURL(string: tmpStr)!
    }
    
    static func getGoogleStaticMapImage(latitude: Double, longtitude: Double, width: Int, height: Int,  zoom: Int, scale: Int, completion: (NSError?, UIImage?) -> Void) {
        let url = NSURL(string: "\(BackEndOverlay.GoogleMapsStaticURL)")!
        let params: [String: AnyObject] = [
            "center": "\(latitude),\(longtitude)",
            "zoom": "\(zoom)",
            "size": "\(width)x\(height)",
            "scale": "\(scale)",
            "format": "png",
            "maptype": "roadmap",
            "style": "visibility:on",
            "markers": "size:small|color:red|\(latitude),\(longtitude)",
            //"key": "\(AppHelpers.GoogleMapsAPIkey)"
        ]
        Alamofire.request(.GET,
            url,
            parameters: params,
            encoding: .URL ,
            headers: nil
            ).validate().responseData{ (responce) -> Void in
                var res: UIImage? = nil
                if !responce.result.isSuccess{
                    //print ("Error GET image!\n", responce.result.error?.code , responce.result.error?.localizedDescription)
                    completion(responce.result.error, res)
                }
                if let imageData = responce.result.value {
                    //print (imageData)
                    res = UIImage(data: imageData)
                }
                completion(responce.result.error, res)
        }
    }
    
    static func getImageWithCache(menuID: Int, namePhoto: String, defaultImageName: String, completion: (UIImage?) -> Void) {
        var res: UIImage? = nil
        let imagesDirString = "\(AppHelpers.imagesCachePath)/\(String(menuID))"
        let pathToImageDirInCache =  Tools.getPath(imagesDirString)
        let pathToImageInCache = Tools.getPath("\(imagesDirString)/\(namePhoto)")
        if Tools.fileMan.fileExistsAtPath(pathToImageInCache.path!) {
            res = UIImage(contentsOfFile: pathToImageInCache.path!)
            completion(res)
        } else {
            if !Tools.fileMan.fileExistsAtPath(pathToImageDirInCache.path!) {
                Tools.dirCreateInDocs(imagesDirString)
            }
            let pathToImage = "\(imagesURL)/\(menuID)/\(namePhoto)"
            let url = NSURL(string: "\(self.site):\(self.port)\(pathToImage)")!
            Alamofire.download(
                .GET,
                url,
                parameters: nil,
                encoding:  .URL,
                headers:  nil,
                destination: { (tempURL, responce) in
                    return pathToImageInCache
            }).validate().response { (responce) in
                if responce.3 == nil {
                    res = UIImage(contentsOfFile: pathToImageInCache.path!)
                } else if let defaultImage = UIImage(named: defaultImageName) {
                    res = defaultImage
                }
                completion(res)
            }
            
        }
    }
    
    static func getTokenByLogIn(login: String, password: String, completion: (String?, userData?) -> Void){
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            completion("TestToken-1", testUsers[0])
        }
    }
    
    static func getUserDataByToken(userToken: String, completion: (userData) -> Void){
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            completion(testUsers[0])
        }
    }
    
    static func getUserDataByUUID (userUUID: String, completion: (userData) -> Void){
        var res: userData = testUsers[0]
        for uData in testUsers {
            if uData.uuid == userUUID {
                res = uData
                break
            }
        }
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            completion(res)
        }
    }
    
    static func getImageWithUUID (imageUUID: String, completion: (UIImage) -> Void){
        var res: UIImage = UIImage(named: "StandardAvatar")!
        if let img = UIImage(named: imageUUID) {
            res = img
        }
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            completion(res)
        }
    }
    
    static func getLastMessagesForUser(uuidUser: String, completion: ([messageData]) -> Void){
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            completion(testMessages)
        }
    }
    
    static func getInterests(completion: (interestsArray: [InterestData]) -> Void) {
        //test version so far
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            completion(interestsArray: testInterests)
        }
    }
    
    static func getEventsForHome(completion: ([eventGroupData]) -> Void ){
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            completion(testEvents)
        }
    }
}