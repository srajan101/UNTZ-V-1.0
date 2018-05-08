//
//  EMReqeustManager.swift
//  Enmoji
//
//  Created by Mahesh on 15/12/16.
//  Copyright © 2016 Mahesh Sonaiya. All rights reserved.
//

import Foundation

import Foundation
import Alamofire

typealias requestCompletionHandler = (UNJSONReponse) -> Void

class UNTZReqeustManager: NSObject {
    static let sharedInstance = UNTZReqeustManager()
    
    fileprivate override init() {
        super.init()
        
        
    }
    
    fileprivate func sendRequestWithURL(_ URL: String,
                                        method: HTTPMethod,
                                        queryParameters: [String: String]?,
                                        bodyParameters: [String: AnyObject]?,
                                        headers: [String: String]?,
                                        isLoginHeaderRequired:Bool,
                                        retryCount: Int = 0,
                                        needsLogin: Bool = false,
                                        completionHandler:@escaping requestCompletionHandler) {
        // If there's a querystring, append it to the URL.
        
        if (GLOBAL.sharedInstance.isInternetReachable == false) {
            let userInfo: [NSObject : AnyObject] =
                [
                    NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("No Internet", value: "No Internet Connection is there.", comment: "") as AnyObject,
                    NSLocalizedFailureReasonErrorKey as NSObject : NSLocalizedString("No Internet", value: "No Internet Connection is there.", comment: "") as AnyObject
            ]
            

            let error : NSError = NSError(domain: "EnomjiHttpResponseErrorDomain", code: -1, userInfo: userInfo)
            let wrappedResponse = UNJSONReponse.init(error: error, dataDict: [:])
            completionHandler(wrappedResponse)
            print(error)
            return
        }
        
        let actualURL: String
        if let queryParameters = queryParameters {
            var components = URLComponents(string:URL)!
            components.queryItems = queryParameters.map { (key, value) in URLQueryItem(name: key, value: value) }
            actualURL = components.url!.absoluteString
        } else {
            actualURL = URL
        }
        
        var headerParams = [String: String]()
        
        if isLoginHeaderRequired == true {
            if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) == nil{
                //UserInfo.sharedInstance.setUserInfoInCache(value: "" as AnyObject, key: UNUserInfoKeys.accessToken)
                headerParams = [:]
            } else {
                let headers: HTTPHeaders = [
                    "Authorization": String.init(format: "Bearer %@", UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) as! CVarArg),
                    "Accept": "application/json"
                ]
                
                
                headerParams = headers
            }
        } else {
            headerParams = [:]
        }
        
        print("Actual URL \(actualURL)")
        print("headerParams \(headerParams)")
        
        Alamofire.request(actualURL, method:method, parameters: bodyParameters, headers: headerParams)
            .responseJSON { response in
                print(response.result)   // result of response serialization
                
                switch response.result {
                case .success:
                    
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("JSON: \(JSON)")
                        
                        let wrappedResponse = UNJSONReponse.init(
                            data: response.result.value as! Dictionary<String, AnyObject>?,
                            response: response.response,
                            error: nil)
                        
                        DispatchQueue.main.async(execute: {
                            completionHandler(wrappedResponse)
                        })
                    }
                case .failure(let error):
                    let error = error
                    let wrappedResponse = UNJSONReponse.init(error: error, dataDict: [:])
                    completionHandler(wrappedResponse)
                    print(error)
                }
        }
    }
    
    fileprivate func sendBodyRequestWithURL(_ actualURL: String,
                                        method: HTTPMethod,
                                        bodyParameters: [String: AnyObject]?,
                                        headers: [String: String]?,
                                        isLoginHeaderRequired:Bool,
                                        retryCount: Int = 0,
                                        needsLogin: Bool = false,
                                        completionHandler:@escaping requestCompletionHandler) {
        // If there's a querystring, append it to the URL.
        
        if (GLOBAL.sharedInstance.isInternetReachable == false) {
            let userInfo: [NSObject : AnyObject] =
                [
                    NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("No Internet", value: "No Internet Connection is there.", comment: "") as AnyObject,
                    NSLocalizedFailureReasonErrorKey as NSObject : NSLocalizedString("No Internet", value: "No Internet Connection is there.", comment: "") as AnyObject
            ]
            
            
            let error : NSError = NSError(domain: "EnomjiHttpResponseErrorDomain", code: -1, userInfo: userInfo)
            let wrappedResponse = UNJSONReponse.init(error: error, dataDict: [:])
            completionHandler(wrappedResponse)
            print(error)
            return
        }
        
        var headerParams = [String: String]()
        
        if isLoginHeaderRequired == true {
            if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) == nil{
                //UserInfo.sharedInstance.setUserInfoInCache(value: "" as AnyObject, key: UNUserInfoKeys.accessToken)
                headerParams = [:]
            } else {
                let headers: HTTPHeaders = [
                    "Authorization": String.init(format: "Bearer %@", UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) as! CVarArg),
                    "Accept": "application/json",
                    "Content-Type": "application/json; charset=UTF-8"
                ]
                
                
                headerParams = headers
            }
        } else {
            headerParams = [:]
        }
        
        let data = try! JSONSerialization.data(withJSONObject: bodyParameters!, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        if let json = json {
            print(json)
        }

        let actualURLVal = URL.init(string: actualURL)
        var request = URLRequest(url: actualURLVal!)
        
        request.httpMethod = method.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
        request.allHTTPHeaderFields = headerParams
        
        Alamofire.request(request).responseJSON {
            (response) in
            
            print(response.result)   // result of response serialization
            
            switch response.result {
            case .success:
                
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    print("JSON: \(JSON)")
                    
                    let wrappedResponse = UNJSONReponse.init(
                        data: response.result.value as! Dictionary<String, AnyObject>?,
                        response: response.response,
                        error: nil)
                    
                    DispatchQueue.main.async(execute: {
                        completionHandler(wrappedResponse)
                    })
                }
            case .failure(let error):
                let error = error
                let wrappedResponse = UNJSONReponse.init(error: error, dataDict: [:])
                completionHandler(wrappedResponse)
                print(error)
            }
        }
    }
    
    
    
    fileprivate func sendRequestForFileUploadWithURL(_ URL: String,
                                        method: HTTPMethod,
                                        imageData: [Data],
                                        fileName : String?,
                                        queryParameters: [String: String]?,
                                        bodyParameters: [String: AnyObject]?,
                                        headers: [String: String]?,
                                        isLoginHeaderRequired:Bool,
                                        retryCount: Int = 0,
                                        needsLogin: Bool = false,
                                        completionHandler:@escaping requestCompletionHandler) {
        // If there's a querystring, append it to the URL.
        
        if (GLOBAL.sharedInstance.isInternetReachable == false) {
            let userInfo: [NSObject : AnyObject] =
                [
                    NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("No Internet", value: "No Internet Connection is there.", comment: "") as AnyObject,
                    NSLocalizedFailureReasonErrorKey as NSObject : NSLocalizedString("No Internet", value: "No Internet Connection is there.", comment: "") as AnyObject
            ]
            
            let error : NSError = NSError(domain: "EnomjiHttpResponseErrorDomain", code: -1, userInfo: userInfo)
            let wrappedResponse = UNJSONReponse.init(error: error, dataDict: [:])
            completionHandler(wrappedResponse)
            print(error)
            return
        }
        
        let actualURL: String
        if let queryParameters = queryParameters {
            var components = URLComponents(string:URL)!
            components.queryItems = queryParameters.map { (key, value) in URLQueryItem(name: key, value: value) }
            actualURL = components.url!.absoluteString
        } else {
            actualURL = URL
        }
        
        var headerParams = [String: String]()
        
        if isLoginHeaderRequired == true {
            if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) == nil{
                //UserInfo.sharedInstance.setUserInfoInCache(value: "" as AnyObject, key: UNUserInfoKeys.accessToken)
                headerParams = [:]
            } else {
                let headers: HTTPHeaders = [
                    "Authorization": String.init(format: "Bearer %@", UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) as! CVarArg),
                    "Accept": "application/json"
                ]
                
                
                headerParams = headers
            }
        } else {
            headerParams = [:]
        }
        
        print("Actual URL \(actualURL)")
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            /*
            if let fileName = fileName {
                
                let fileUrl = NSURL(string: fileName)!
                
                if fileUrl.pathExtension!.lowercased() == "jpg" || fileUrl.pathExtension!.lowercased() == "jpeg" {
                    if let imageData = UIImageJPEGRepresentation(image!, 0.5) {
                        multipartFormData.append(imageData, withName: "ProfilePic", fileName: "ProfilePic.jpg", mimeType: "image/jpg")
                    }
                } else {
                    if let imageData = UIImagePNGRepresentation(image!) {
                        multipartFormData.append(imageData, withName: "ProfilePic", fileName: "ProfilePic.png", mimeType: "image/png")
                    }
                }
            } else {
                if let imageData = UIImagePNGRepresentation(image!) {
                    multipartFormData.append(imageData, withName: "ProfilePic", fileName: "ProfilePic.png", mimeType: "image/png")
                }
            }
            */
            
            for index in 0..<imageData.count {
                multipartFormData.append(imageData[index], withName: "StatusPict", fileName: "ProfilePic.jpg", mimeType: "image/jpg")
            }
            
            /*
            if let imageData = UIImageJPEGRepresentation(image!, 0.75) {
                multipartFormData.append(imageData, withName: "ProfilePic", fileName: "ProfilePic.jpg", mimeType: "image/jpg")
            }
            */
            
            for (key, value) in bodyParameters! {
                let paramValue = value as! String
                multipartFormData.append(paramValue.data(using: String.Encoding.utf8)!, withName: key)
            }}, to: actualURL, method: .post, headers: headerParams,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            print(response.request!)  // original URL request
                            print(response.result)   // result of response serialization
                            
                            switch response.result {
                            case .success:
                                if let result = response.result.value {
                                    let JSON = result as! NSDictionary
                                    print("JSON: \(JSON)")
                                    
                                    let wrappedResponse = UNJSONReponse.init(
                                        data: response.result.value as! Dictionary<String, AnyObject>?,
                                        response: response.response,
                                        error: nil)
                                    
                                    DispatchQueue.main.async(execute: {
                                        completionHandler(wrappedResponse)
                                    })
                                }
                            case .failure(let error):
                                let error = error
                                let wrappedResponse = UNJSONReponse.init(error: error, dataDict: [:])
                                completionHandler(wrappedResponse)
                                print(error)
                            }
                        }
                    case .failure(let encodingError):
                        let error = encodingError
                        let wrappedResponse = UNJSONReponse.init(error: error, dataDict: [:])
                        completionHandler(wrappedResponse)
                        print(error)
                    }
        })
    }

    
    
    
    
}

extension UNTZReqeustManager {
    
    func apiGetListOfEventCategories(_ completionHandler:@escaping requestCompletionHandler) {
        
        sendRequestWithURL(APIEndPoints.getListOfEventCategories(), method: .get, queryParameters: nil, bodyParameters: nil as [String : AnyObject]?, headers: nil, isLoginHeaderRequired: false, completionHandler: completionHandler)
    }
    func apiregisterDeviceToken(token: String, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@?handle=%@", APIEndPoints.registerDevice(),token)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
        
    }
    func apiregisterId(token : String, idStr : String, completionHandler:@escaping requestCompletionHandler) {
        
        let bodyParams: [String: String] = [UNTZAPIRequestKeys.platform: "apns" , UNTZAPIRequestKeys.handle: token
        ]
        let detailsURL = String.init(format: "%@%@", APIEndPoints.registerId(),idStr)
        
        
        sendRequestWithURL(detailsURL, method: .post, queryParameters: nil, bodyParameters: bodyParams as [String : AnyObject]?, headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    func apiGetListOfEvents(_ offset: Int,latitude: String,longitude: String,searchText: String,categories: String, completionHandler:@escaping requestCompletionHandler) {
        
        var queryParameters: [String: String] = [:]
        
        if searchText.length > 0 {
            queryParameters =   [UNTZAPIRequestKeys.offset: String(offset),
                                 UNTZAPIRequestKeys.latitude: latitude,
                                 UNTZAPIRequestKeys.longitude: longitude,
                                 UNTZAPIRequestKeys.searchText: searchText
                                ]
        }
        else if categories.length > 0 {
            queryParameters =   [UNTZAPIRequestKeys.offset: String(offset),
                                 UNTZAPIRequestKeys.latitude: latitude,
                                 UNTZAPIRequestKeys.longitude: longitude,
                                 UNTZAPIRequestKeys.categories: categories
            ]
        }
        else if (searchText.length > 0) && (categories.length > 0) {
            queryParameters =   [UNTZAPIRequestKeys.offset: String(offset),
                                 UNTZAPIRequestKeys.latitude: latitude,
                                 UNTZAPIRequestKeys.longitude: longitude,
                                 UNTZAPIRequestKeys.searchText: searchText,
                                 UNTZAPIRequestKeys.categories: categories
            ]
        }
        else {
            queryParameters =   [UNTZAPIRequestKeys.offset: String(offset),
                                 UNTZAPIRequestKeys.latitude: latitude,
                                 UNTZAPIRequestKeys.longitude: longitude,
                                ]
        }
        
        sendRequestWithURL(APIEndPoints.getSuggestedEventsList(), method: .get, queryParameters: queryParameters, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }

    func apiLogin(_ emailId : String, password : String, completionHandler:@escaping requestCompletionHandler) {
        var deviceToken = ""
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.devicePushToken) != nil {
            deviceToken = UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.devicePushToken) as! String
        }
        let bodyParams: [String: String] = [UNTZAPIRequestKeys.emailID: emailId,
                                            UNTZAPIRequestKeys.password: password ,
                                            UNTZAPIRequestKeys.userName : "" ,
                                            UNTZAPIRequestKeys.isSocialUser : UNTZAPIRequestKeys.normalUser ,
                                            UNTZAPIRequestKeys.socialType : String(EMUserTypes.socialTypeNormal),
                                            UNTZAPIRequestKeys.deviceType : UNTZAPIRequestKeys.deviceTypeIOS ,
                                            UNTZAPIRequestKeys.devicePushToken : deviceToken,
                                            UNTZAPIRequestKeys.socialId : ""
                                            ]
        
        sendRequestWithURL(APIEndPoints.getLoginURL(), method: .post, queryParameters: nil, bodyParameters: bodyParams as [String : AnyObject]?, headers: nil, isLoginHeaderRequired: false, completionHandler: completionHandler)
    }
    
    func apiFacebookLogin(_ token : String, provider : String, completionHandler:@escaping requestCompletionHandler) {
        let bodyParams: [String: String] = [UNTZAPIRequestKeys.fbtoken: token , UNTZAPIRequestKeys.fbprovider: provider
        ]
        
        sendRequestWithURL(APIEndPoints.postRegFBtoken(), method: .post, queryParameters: nil, bodyParameters: bodyParams as [String : AnyObject]?, headers: nil, isLoginHeaderRequired: false, completionHandler: completionHandler)
    }
    
    func apiGetEventDetails(_ eventId: Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld", APIEndPoints.getEventDetails(),eventId)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiMarkEventAsInterestedOrNot(_ eventId: Int,isInterested : Bool, completionHandler:@escaping requestCompletionHandler) {
        
        var detailsURL = String.init()
        
        if isInterested {
            detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.markAsInterested())
        } else {
            detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.markAsNonInterested())
        }
        
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }

    func apiJoinOrLeaveEvent(_ eventId: Int,isLeaving : Bool, completionHandler:@escaping requestCompletionHandler) {
        
        var detailsURL = String.init()
        
        if isLeaving {
            detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.leaveEvent())
        } else {
            detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.joinEvent())
        }
        
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiMarkEventAsCanceledOrNot(_ eventId: Int,isCancelled : Bool, completionHandler:@escaping requestCompletionHandler) {
        
        var detailsURL = String.init()
        
        if isCancelled {
            detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.markEventAsCancel())
        } else {
            detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.markEventAsUnCancel())
        }
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }

    func apiGoLiveEvent(_ eventId: Int, completionHandler:@escaping requestCompletionHandler) {
        
        var detailsURL = String.init()
        
        detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.goLive())
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }

    func apiGetCurrentlyPlayingTrack(_ eventId: Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.getCurrentlyPlayingTrack())
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiGetListOfUserEvents(_ offset: Int,accountId:String,searchText: String, completionHandler:@escaping requestCompletionHandler) {
        
        //let defaults = UserDefaults.standard
        //let accountId = defaults.integer(forKey: UNUserInfoKeys.accountID) //UserInfo.sharedInstance.getUserDefault(key: )
        //let accountIdValue = String.init(format: "%@", NSNumber.init(value: accountId))
        
        var queryParameters: [String: String] = [:]
        
        if searchText.length > 0 {
            queryParameters =   [UNTZAPIRequestKeys.offset: String(offset),
                                 UNTZAPIRequestKeys.searchText: searchText,
                                 UNTZAPIRequestKeys.accountId: accountId
            ]
        }
        else {
            queryParameters =   [UNTZAPIRequestKeys.offset: String(offset),
                                 UNTZAPIRequestKeys.accountId: accountId
            ]
        }
        
        sendRequestWithURL(APIEndPoints.getUserEventsList(), method: .get, queryParameters: queryParameters, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    func apiGetListOfPastEvents(_ offset: Int,accountId:Int,searchText: String, completionHandler:@escaping requestCompletionHandler) {
        
        //let accountId = UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.userID)
        var queryParameters: [String: String] = [:]
        
        if searchText.length > 0 {
            queryParameters =   [UNTZAPIRequestKeys.offset: String(offset),
                                 UNTZAPIRequestKeys.searchText: searchText,
                                 UNTZAPIRequestKeys.accountId: String(accountId)
            ]
        }
        else {
            queryParameters =   [UNTZAPIRequestKeys.offset: String(offset),
                                 UNTZAPIRequestKeys.accountId: String(accountId)
            ]
        }
        
        sendRequestWithURL(APIEndPoints.getPastEventsList(), method: .get, queryParameters: queryParameters, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiGetListOfArtists(_ eventId: Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.getArtistList())
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiAddArtist(_ eventId: Int, artistAccountId: String, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@?artistAccountId=%@", APIEndPoints.getEventDetails(),eventId,APIEndPoints.getArtistList(),artistAccountId)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiDeleteArtist(_ eventId: Int, artistAccountId: String, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.getArtistList(),artistAccountId)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }

    func apiImportFacebookEvent(_ eventURL: String, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%@?url=%@", APIEndPoints.getEventDetails(),APIEndPoints.importFacebookEvent(),eventURL)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiAddArtistAsFacebookUser(_ eventId: Int, artistAccountId: String, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@?facebookUserId=%@", APIEndPoints.getEventDetails(),eventId,APIEndPoints.addFacebookUserAsArtist(),artistAccountId)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiImportFacebookUser(_ facebookUserId: String, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%@facebookUserId=%@", APIEndPoints.getEventCategoryURL(),APIEndPoints.importFacebookUser(),facebookUserId)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiAddComment(_ eventId: Int,bodyParameters: [String: AnyObject],
                       completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/Comment", APIEndPoints.getEventCategoryURL(),eventId)
        
        sendRequestWithURL(detailsURL, method: .post, queryParameters: nil, bodyParameters: bodyParameters , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiDeleteComment(_ eventId: Int,eventCommentId :Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/Comment/%ld", APIEndPoints.getEventCategoryURL(),eventId,eventCommentId)
        
        sendRequestWithURL(detailsURL, method: .delete, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiLikeOrDislikeComment(_ eventId: Int,eventCommentId :Int,isLiked : Bool, completionHandler:@escaping requestCompletionHandler) {
        
        var detailsURL = String.init()
        
        if isLiked {
            detailsURL = String.init(format: "%@%ld/Comment/%ld/Unlike", APIEndPoints.getEventCategoryURL(),eventId,eventCommentId)
        } else {
            detailsURL = String.init(format: "%@%ld/Comment/%ld/Like", APIEndPoints.getEventCategoryURL(),eventId,eventCommentId)
        }
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiGetListOfComments(_ offset: Int, eventId: Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@?offset=%ld", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.feedPost(),offset)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }

    func apiGetListOfRequestedTracks(_ eventId: Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.performOnRequestedTrack())
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }

    func apiAcceptOrRejectRequest(_ eventId: Int,eventRequestedTrackId :Int,isAccept : Bool , completionHandler:@escaping requestCompletionHandler) {
        
        var detailsURL = String.init()
        
        if isAccept {
            detailsURL = String.init(format: "%@%ld/%@/%ld/Accept", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.performOnRequestedTrack(),eventRequestedTrackId)
        } else {
            detailsURL = String.init(format: "%@%ld/%@/%ld/Unaccept", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.performOnRequestedTrack(),eventRequestedTrackId)
        }
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }

    func apiDeleteRequest(_ eventId: Int,eventRequestedTrackId :Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@/%ld", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.performOnRequestedTrack(),eventRequestedTrackId)
        
        sendRequestWithURL(detailsURL, method: .delete, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }

    func apiPictureComment(_ eventId: Int,bodyParameters: [String: AnyObject],imageData: [Data],
                           fileName : String?,
                       completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.pictureComment())
        /*
        sendRequestWithURL(detailsURL, method: .post, queryParameters: nil, bodyParameters: bodyParameters , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
 */
        sendRequestForFileUploadWithURL(detailsURL, method: .post, imageData: imageData, fileName: fileName, queryParameters: nil, bodyParameters: bodyParameters, headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiSearchRequestedTracks(_ searchText: String, completionHandler:@escaping requestCompletionHandler) {
        
        let searchTextValue = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let searchSpotifyURL = String.init(format: "%@?text=%@", APIEndPoints.searchSpotifySongs(),searchTextValue!)
        
        sendRequestWithURL(searchSpotifyURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }

    func apiRegisterSpotifyAccessToken(_ bodyParameters: [String: AnyObject],
                       completionHandler:@escaping requestCompletionHandler) {
        
        sendRequestWithURL(APIEndPoints.registerSpotifyAccessToken(), method: .post, queryParameters: nil, bodyParameters: bodyParameters , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiRequestSpotifySong(_ eventId: Int,bodyParameters: [String: AnyObject], completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.performOnRequestedTrack())
        
        sendBodyRequestWithURL(detailsURL, method: .post, bodyParameters: bodyParameters, headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiUpdateAboutMe(aboutMeText: String, completionHandler:@escaping requestCompletionHandler) {
        let aboutme = aboutMeText.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let detailsURL = String.init(format: "%@?aboutMeText=%@", APIEndPoints.getUpdateAboutMeURL(),aboutme!)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
        
    }
    
    func apiGetProfile(_ userID: String, completionHandler:@escaping requestCompletionHandler) {
        
        //let userId = UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.userID) as! String
        
        let detailsURL = String.init(format: "%@%@", APIEndPoints.getProfileURL(),userID)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiGetListOfFans(_ userId: Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getProfileURL(),userId,APIEndPoints.getFansURL())
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    func apiGetPlaylist(_ userId: Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getProfileURL(),userId,APIEndPoints.getPlaylistURL())
        
        //let detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.getPlaylistURL())
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiAddPlaylistToRequestedTrack(_ eventId: Int,eventPlaylistId: Int, reuestedTrackId: Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@/%ld/%@?eventRequestedTrackId=%ld", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.getPlaylistURL(),eventPlaylistId,APIEndPoints.addRequestedTrackURL(),reuestedTrackId)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiGetListOfFansOf(_ userId: Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getProfileURL(),userId,APIEndPoints.getFansOfURL())
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    func apiBecomeFan(_ userId: Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getProfileURL(),userId,APIEndPoints.getBecomeFanURL())
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    func apiUnfan(_ userId: Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getProfileURL(),userId,APIEndPoints.getUnfanURL())
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiGetEventPlaylist(_ eventId: Int,excludeTracks :Bool, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@?excludeTracks=%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.getPlaylistURL(),excludeTracks as NSNumber)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiGetSuggestedEventPlaylist(_ eventId: Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.suggestedPlaylistURL())
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiDeleteEventPlaylist(_ eventId: Int,playListId :Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@/%ld", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.getPlaylistURL(),playListId)
        
        sendRequestWithURL(detailsURL, method: .delete, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    func apiDeleteEventPlaylistTrack(_ eventId: Int,playListId :Int,playListTrackId :Int
, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@/%ld/%@/%ld", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.getPlaylistURL(),playListId,APIEndPoints.getPlaylistTrackURL(),playListTrackId)
        
        sendRequestWithURL(detailsURL, method: .delete, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiRenameEventPlaylist(_ eventId: Int,playListId :Int,playlistName: String, completionHandler:@escaping requestCompletionHandler) {
        
        let playlist = playlistName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let detailsURL = String.init(format: "%@%ld/%@/%ld/Rename?newName=%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.getPlaylistURL(),playListId,playlist!)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiCreateEventPlaylist(_ eventId: Int,playlistName: String, completionHandler:@escaping requestCompletionHandler) {
        
        let playlist = playlistName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let detailsURL = String.init(format: "%@%ld/%@?playlistName=%@", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.getPlaylistURL(),playlist!)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiDeleteSuggestedPlaylist(_ eventId: Int,suggestedPlaylistId :Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@/%ld", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.getSuggestedEventsList(),suggestedPlaylistId)
        
        sendRequestWithURL(detailsURL, method: .delete, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiAddPlaylistInSuggestedPlaylist(_ eventId: Int,playlistId :Int,suggestedPlaylistId :Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@/%ld/%@?suggestedPlaylistTrackId=%ld", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.getPlaylistURL(),playlistId,APIEndPoints.addSuggestedPlaylistTrackURL(),suggestedPlaylistId)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiVoteSuggestedPlaylist(_ eventId: Int,suggestedPlaylistTrackId :Int,suggestedPlaylistId :Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@/%ld/%@/%ld/Vote", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.suggestedPlaylistURL(),suggestedPlaylistId,APIEndPoints.suggestedPlaylistTrackURL(),suggestedPlaylistTrackId)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiUnVoteSuggestedPlaylist(_ eventId: Int,suggestedPlaylistTrackId :Int,suggestedPlaylistId :Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@/%ld/%@/%ld/Unvote", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.suggestedPlaylistURL(),suggestedPlaylistId,APIEndPoints.suggestedPlaylistTrackURL(),suggestedPlaylistTrackId)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiVoteEventPlaylist(_ eventId: Int,eventPlaylistTrackId :Int,eventPlaylistId :Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@/%ld/%@/%ld/Vote", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.getPlaylistURL(),eventPlaylistId,APIEndPoints.eventPlaylistTrackURL(),eventPlaylistTrackId)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiUnVoteEventPlaylist(_ eventId: Int,eventPlaylistTrackId :Int,eventPlaylistId :Int, completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@%ld/%@/%ld/%@/%ld/Unvote", APIEndPoints.getEventCategoryURL(),eventId,APIEndPoints.getPlaylistURL(),eventPlaylistId,APIEndPoints.eventPlaylistTrackURL(),eventPlaylistTrackId)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func apiGetNotificationList(_ offset: Int,completionHandler:@escaping requestCompletionHandler) {
        
        let detailsURL = String.init(format: "%@?offset=%ld", APIEndPoints.getNotificationListURL(),offset)
        
        sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
    }
    
    func checkFacebookUserEvents(_ completionHandler:@escaping requestCompletionHandler) {
        var facebookAccessToken = ""
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.facebookAccessToken) != nil {
            
            facebookAccessToken = UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.facebookAccessToken) as! String
            
            if facebookAccessToken.length > 0 {
                let detailsURL = String.init(format: "%@?fbaccesstoken=%@", APIEndPoints.getFacebookUserEventsURL(),facebookAccessToken)
                
                sendRequestWithURL(detailsURL, method: .get, queryParameters: nil, bodyParameters: nil , headers: nil, isLoginHeaderRequired: true, completionHandler: completionHandler)
            }
            
        }
    }
}
