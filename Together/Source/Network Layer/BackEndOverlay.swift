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

let zeroDelay: Double = 0
let shortDelay: Double = 0.1
let middleDelay: Double = 0.5
let slowDelay: Double = 1
let turtleDelay: Double = 5
let epicDelay: Double = 10

struct BackEndOverlay {
    
    static func makeGoogleStaticMapURL (_ latitude: Double, longitude: Double, width: Int, height: Int,  zoom: Int, scale: Int, label: String? = nil, placeMarker: Bool = true) -> URL {
        let label = label ?? ""
        var params: [String: String] = [
            "center": "\(latitude),\(longitude)",
            "zoom": "\(zoom)",
            "size": "\(width)x\(height)",
            "scale": "\(scale)",
            "format": "png",
            "maptype": "roadmap",
            "style": "visibility:on"
            //"key": "\(AppHelpers.GoogleMapsAPIkey)"
        ]
        if placeMarker {
            params["markers"] = "size:mid|color:red|label:\(label)|\(latitude),\(longitude)"
        }
        var tmpStr = "\(NetworkConfig.GoogleMapsStaticURL)"
        var tmpList: Array<String> = []
        for (parKey, parValue) in params {
            tmpList.append("\(parKey)=\(parValue)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)! )
        }
        tmpStr.append(tmpList.joined(separator: "&"))
        return URL(string: tmpStr)!
    }
    
    static func getGoogleStaticMapImage(_ latitude: Double, longitude: Double, width: Int, height: Int,  zoom: Int, scale: Int, completion: @escaping (Result<UIImage>) -> Void) {
        let mapUrl = URL(string: "\(NetworkConfig.GoogleMapsStaticURL)")!
        let params: [String: Any] = [
            "center": "\(latitude),\(longitude)",
            "zoom": "\(zoom)",
            "size": "\(width)x\(height)",
            "scale": "\(scale)",
            "format": "png",
            "maptype": "roadmap",
            "style": "visibility:on",
            "markers": "size:small|color:red|\(latitude),\(longitude)",
            //"key": "\(AppHelpers.GoogleMapsAPIkey)"
        ]
        Alamofire.request(
            mapUrl,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default
            ).validate().responseImage{ responce in
                var res: UIImage? = nil
                if !responce.result.isSuccess{
                    //print ("Error GET image!\n", responce.result.error?.code , responce.result.error?.localizedDescription)
                    completion(Result<UIImage>.failure(responce.result.error!))
                }
                if let imageData = responce.result.value {
                    //print (imageData)
                    res = imageData
                }
                completion(Result<UIImage>.success(res!))
        }
    }
    
    static func getTokenByLogIn(_ login: String, password: String, completion: @escaping (Result<Bool>) -> Void) {
        delayNetwork(slowDelay){
            MyTogetherAccount.shared.login = login
            MyTogetherAccount.shared.password = password
            MyTogetherAccount.shared.togetherToken = "TestToken"
            MyTogetherAccount.shared.saveCommonData(
                testUsers[0]
            )
            completion(Result.success(true))
        }
    }
    
    static func getUserDataByToken(_ userToken: String, completion: @escaping (Result<UserData>) -> Void) {
        delayNetwork(slowDelay){
            completion(Result<UserData>.success(testUsers[0]))
        }
    }
    
    static func getUserDataByUUID(_ userUUID: String, completion: @escaping (Result<UserData>) -> Void) {
        var res: UserData = testUsers[0]
        for uData in testUsers {
            if uData.uuid == userUUID {
                res = uData
                break
            }
        }
        delayNetwork(middleDelay) {
            completion(Result<UserData>.success(res))
        }
    }
    
    static func getImageWithUUID(_ imageUUID: String, completion: @escaping (Result<UIImage>) -> Void) {
        var res: UIImage = UIImage(named: "StandardAvatar")!
        if let img = UIImage(named: imageUUID) {
            res = img
        }
        delayNetwork(middleDelay) {
            completion(Result<UIImage>.success(res))
        }
    }
    
    static func getUserPhotoByUUID(_ userUUID: String, completion: @escaping (Result<UIImage>) -> Void){
        BackEndOverlay.getUserDataByUUID(userUUID){ result in
            switch result {
            case .success(let uData):
                BackEndOverlay.getImageWithUUID(uData.photoUUID){ result in
                    switch result {
                    case .success(let image):
                        completion(Result<UIImage>.success(image))
                    case .failure(let error):
                        completion(Result<UIImage>.failure(error))
                    }
                }
            case .failure(let error):
                completion(Result<UIImage>.failure(error))
            }
        }
    }
    
    static func getUserCurrentLocationByUUID(_ userUUID: String, completion: @escaping (Result<CLLocationCoordinate2D>) -> Void) {
        delayNetwork(middleDelay){
            completion(Result<CLLocationCoordinate2D>.success(
                CLLocationCoordinate2D(latitude: Double(arc4random_uniform(181)) - 90, longitude: Double(arc4random_uniform(361)) - 180)
            ))
        }
    }
    
    static func getUserConnectionStatusByUUID(_ userUUID: String, completion: @escaping (Result<Bool>) -> Void) {
        let res = generateRandomBool()
        completion(Result<Bool>.success(res))
    }
    
    static func checkForFriendship(firstUserUUID: String, secondUserUUID: String, completion: @escaping (Result<Bool>) -> Void) {
        delayNetwork(middleDelay){
            let res = generateRandomBool()
            completion(Result<Bool>.success(res))
        }
    }
    
    static func removefromFriends(masterUUID: String, friendUUID: String, completion: @escaping (Result<Bool>) -> Void) {
        delayNetwork(middleDelay){
            completion(Result<Bool>.success(false))
        }
    }
    
    static func addToFriends(masterUUID: String, friendUUID: String, completion: @escaping (Result<Bool>) -> Void) {
        delayNetwork(middleDelay){
            completion(Result<Bool>.success(true))
        }
    }
    
    static func getLastMessagesForUser(_ uuidUser: String, completion: @escaping (Result<[MessageData]>) -> Void) {
        delayNetwork(slowDelay) {
            completion(Result<[MessageData]>.success(testMessages))
        }
    }
    
    static func getInterests(_ completion: @escaping (Result<[InterestData]>) -> Void) {
        
        delayNetwork(slowDelay) {
//            completion(Result<[InterestData]>.success(testInterests))
        }
    }
    
    static func getEventsForHome(_ completion: @escaping (Result<[EventGroupData]>) -> Void ) {
        
//        delayNetwork(slowDelay) {
//            completion(Result<[EventGroupData]>.success(testEvents))
//        }
    }
    
    static func getEventsForMap(location: CLLocationCoordinate2D, validRadius: Double, completion: @escaping (Result<[EventData]>) -> Void) {
//        var res: [EventData] = []
//        for eventGroup in testEvents {
//            for event in eventGroup.events {
//                if GMSGeometryDistance(location, event.location).isLess(than: validRadius){
//                    res.append(event)
//                }
//            }
//        }
//        delayNetwork(slowDelay) {
//            completion(Result<[EventData]>.success(res))
//        }
    }
    
    fileprivate static func getMyFriends (userUUID: String, completion: @escaping (Result<[String]>) -> Void) {
        delayNetwork(slowDelay) {
            completion(Result<[String]>.success(["testUser2", "testUser3", "testUser4"]))
        }
    }
    
    static func getUsersUUIDs(For: GetUsersQueryType, completion: @escaping (Result<[String]>) -> Void) {
        switch For {
        case .friends(let userUUID):
            getMyFriends(userUUID: userUUID, completion: completion)
        default:
            completion(Result<[String]>.failure(BackEndErrors.wrongQueryType))
        }
    }
}
