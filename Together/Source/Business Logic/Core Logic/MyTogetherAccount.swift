//
//  TogetherAccount.swift
//  Together
//
//  Created by Андрей Цай on 07.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import Foundation
import Locksmith
import SwiftyUserDefaults

extension DefaultsKeys {
    static let uuidKey = DefaultsKey<String>("TCAuuid")
    static let firstNameKey = DefaultsKey<String>("TCAfirstName")
    static let lastNameKey = DefaultsKey<String>("TCAlastName")
    static let emailKey = DefaultsKey<String>("TCAemail")
    static let photoUUIDKey = DefaultsKey<String>("TCAphotoUUID")
    static let genderKey = DefaultsKey<Bool>("TCAgender")
}

struct MyTogetherAccount{
    static var shared = MyTogetherAccount()
    fileprivate static let accountName = "TogetherCurrentAccount"
    fileprivate static let loginKey = "TCAlogin"
    fileprivate static let passwordKey = "TCApassword"
    fileprivate static let togetherTokenKey = "TCAtogetherToken"
    fileprivate static let twitterTokenKey = "TCAtwitterToken"
    fileprivate static let facebookTokenKey = "TCAfacebookToken"
    
    var login: String? {
        set{
            guard let saveValue = newValue else {return}
            self.setData(MyTogetherAccount.loginKey, value: saveValue)
        }
        get {
            guard let resDict = Locksmith.loadDataForUserAccount(userAccount: MyTogetherAccount.accountName) else {return nil}
            return resDict[MyTogetherAccount.loginKey] as? String
        }
    }
    var password: String?{
        set{
            guard let saveValue = newValue else {return}
            self.setData(MyTogetherAccount.passwordKey, value: saveValue)
        }
        get {
            guard let resDict = Locksmith.loadDataForUserAccount(userAccount: MyTogetherAccount.accountName) else {return nil}
            return resDict[MyTogetherAccount.passwordKey] as? String
        }
    }
    var togetherToken: String?{
        set{
            guard let saveValue = newValue else {return}
            self.setData(MyTogetherAccount.togetherTokenKey, value: saveValue)
        }
        get {
            guard let resDict = Locksmith.loadDataForUserAccount(userAccount: MyTogetherAccount.accountName) else {return nil}
            return resDict[MyTogetherAccount.togetherTokenKey] as? String
        }
    }
    var twitterToken: String?{
        set{
            guard let saveValue = newValue else {return}
            self.setData(MyTogetherAccount.twitterTokenKey, value: saveValue)
        }
        get {
            guard let resDict = Locksmith.loadDataForUserAccount(userAccount: MyTogetherAccount.accountName) else {return nil}
            return resDict[MyTogetherAccount.twitterTokenKey] as? String
        }
    }
    var facebookToken: String?{
        set{
            guard let saveValue = newValue else {return}
            self.setData(MyTogetherAccount.facebookTokenKey, value: saveValue)
        }
        get {
            guard let resDict = Locksmith.loadDataForUserAccount(userAccount: MyTogetherAccount.accountName) else {return nil}
            return resDict[MyTogetherAccount.facebookTokenKey] as? String
        }
    }
    
    var uuid: String {
        set {
            Defaults[.uuidKey] = newValue
        }
        get {
            return Defaults[.uuidKey]
        }
    }
    
    var firstName: String {
        set {
            Defaults[.firstNameKey] = newValue
        }
        get {
            return Defaults[.firstNameKey]
        }
    }
    
    var lastName: String {
        set {
            Defaults[.lastNameKey] = newValue
        }
        get {
            return Defaults[.lastNameKey]
        }
    }
    
    var email: String {
        set {
            Defaults[.emailKey] = newValue
        }
        get {
            return Defaults[.emailKey]
        }
    }
    
    var photoUUID: String {
        set {
            Defaults[.photoUUIDKey] = newValue
        }
        get {
            return Defaults[.photoUUIDKey]
        }
    }
    
    var gender: Bool {
        set {
            Defaults[.genderKey] = newValue
        }
        get {
            return Defaults[.genderKey]
        }
    }
    
    fileprivate init(){
    }
    
    fileprivate func setData(_ key: String, value: Any){
        do {
            try Locksmith.updateData(
                data: [key: value],
                forUserAccount: MyTogetherAccount.accountName)
        } catch {
            print("error saving keychain data!\n\(error)")
        }
    }
    
    mutating func saveCommonData(_ userCommonData: UserData) {
        self.uuid = userCommonData.uuid
        self.firstName = userCommonData.firstName
        self.lastName = userCommonData.lastName
        self.email = userCommonData.email
        self.photoUUID = userCommonData.photoUUID
        self.gender = userCommonData.gender
    }
    
}
