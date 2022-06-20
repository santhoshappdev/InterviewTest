//
//  NetworkManager.swift
//  Reloy InterviewTest
//
//  Created by Santhosh K on 19/06/22.
//

import Foundation
import UIKit

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}

final class RequestMethod {
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }
    
    static func request(method: Method, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}


final class RequestManager {
    
    //Request
    func methodType(requestType: RequestMethod.Method,_ urlString: String,params:[String:Any] ,paramsData: Data?,  completion:((_ response : Any?,_ responseData : Data?, _ statusCode: Int)->Void)?, failure:((_ response : Any?,_ responseData : Data?,_ statusCode: Int)->Void)?) -> Void
    {
        print(urlString)
        if params.isEmpty {print(paramsData as Any)}
        else { print(params)
}
        
        
        if let reachability = Reachability(), !reachability.isReachable {
            
            self.showAlert("Please check your Internet Connection")
            return
        }
        
        guard let url = URL(string: urlString) else {
            failure! ("Wrong url format",Data(), 0)
            return
        }
        var urlRequest = RequestMethod.request(method: requestType, url: url)
        if !params.isEmpty {
            
            let postData = try? JSONSerialization.data(withJSONObject: params as Any, options: .init(rawValue: 0))
            urlRequest.httpBody = postData
        }else if paramsData != nil
        {
            urlRequest.httpBody = paramsData
        }
        urlRequest.httpMethod = requestType.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 60

        self.sessionWithRequest(urlRequest: urlRequest, completion: completion, failure: failure)
    }
    
    //Response
    func sessionWithRequest(urlRequest: URLRequest, completion:((_ response : Any?,_ responseData : Data?, _ statusCode: Int) -> Void)?, failure:((_ response : Any?,_ responseData : Data?, _ statusCode: Int)->Void)?) -> Void
    {
        let sessionConfiguration =  URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfiguration)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            let code = httpResponse?.statusCode
            
            if error == nil && data != nil {
                var json:Any?
                do{
                    json = try JSONSerialization.jsonObject(with: data!, options: .init(rawValue: 0))
                   // print(json as Any)
                }catch let error{
                    print(error)
                }
                
                if  json != nil || data != nil {
                    if completion != nil {
                        switch code {
                        case 200 :
                         completion! (json,data, code!)
                        default :
                            
                          failure! (json,data,code!)
                        }
                    }
                } else { failure! (json,data,code!) }
            }
            else {
                if failure != nil && code != nil {
                    failure! (error,data, code!)
                } else if failure != nil {
                    failure! (error,data, 0)
                    if code == nil{ print("Couldn't reach server at the moment.")  }
                }
            }
            
        }
        dataTask.resume()
    }
    
    
    
    
    
    func methodTypeImageUpload(requestType: RequestMethod.Method,_ urlString: String,params:[String:Any] ,imageview: UIImage?,  completion:((_ response : Any?,_ responseData : Data?, _ statusCode: Int)->Void)?, failure:((_ response : Any?,_ responseData : Data?,_ statusCode: Int)->Void)?) -> Void
    {
        print(urlString)
        print(params)
        
        if let reachability = Reachability(), !reachability.isReachable {
            self.showAlert("Please check your Internet Connection")
            return
        }
        guard let url = URL(string: urlString) else {
            failure! ("Wrong url format",Data(), 0)
            return
        }
        var getRequest = RequestMethod.request(method: requestType, url: url)
        
        let imageData = imageview?.jpegData(compressionQuality: 0.5)
        getRequest = URLRequest(url: url)
        getRequest.httpMethod = requestType.rawValue // GET or POST - Required
        // Multi part image upload
        getRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        getRequest.httpShouldHandleCookies = false
        getRequest.timeoutInterval = 60
        let boundary = "------VohpleBoundary4QuqLuM1cE5lMwCy"
        let contentType = String.init(format: "multipart/form-data; boundary=%@", boundary)
        getRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        getRequest.httpBody =  createBody(params, boundary: boundary, data: imageData!, mimeType: "image/jpg")
        
        
        getRequest.httpMethod = requestType.rawValue
        getRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        getRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        getRequest.timeoutInterval = 60
        
        self.sessionWithRequest(urlRequest: getRequest, completion: completion, failure: failure)
    }
    
    // Creating param and image are converting to data
    func createBody(_ parameters: [String: Any]?, boundary: String, data:Data, mimeType: String)-> Data {
        var setData = Data()
        if parameters != nil {
            for (key, value) in parameters! {
                setData.appendString("--\(boundary)\r\n")
                setData.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                setData.appendString("\(value)\r\n")
            }
        }
        
        setData.appendString("--\(boundary)\r\n")
        setData.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n")
        setData.appendString("Content-Type: image/jpg\r\n\r\n")
        setData.append(data)
        setData.appendString("\r\n")
        
        setData.appendString("--".appending(boundary.appending("--\r\n")))
        return setData
    }
    

    func showAlert(_ text:String){
        DispatchQueue.main.async {
            
            let alertView = UIAlertController(title: APP_NAME, message:text, preferredStyle: .alert)
            
            alertView.addAction(UIAlertAction(title:"OK", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present (alertView, animated: true, completion: nil)
        }
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

