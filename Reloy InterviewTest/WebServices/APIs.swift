//
//  APIs.swift
//  Reloy InterviewTest
//
//  Created by Santhosh K on 19/06/22.
//

import Foundation


import Foundation
struct APIURL {
    static var subDomain = ""
    private struct Domains {
        static let live = "https://pixabay.com"
        static let Dev = ""
    }
    private struct Routes {
        static let API = "/api/"
    }
    private static let Domain = Domains.live
    private static let Route = Routes.API
    private static let BaseURL = Domain + Route


    
    //user
    static var imageListing:String {return BaseURL + ""}
    
    
}
