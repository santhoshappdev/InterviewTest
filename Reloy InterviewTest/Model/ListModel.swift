//
//  ListModel.swift
//  Reloy InterviewTest
//
//  Created by Santhosh K on 19/06/22.
//

import Foundation


struct PixabayApiResponse : Codable  {
    
    var total:Int
    var totalHits:Int
    var hits:[PixabayApiImageList]
    
    init(with Dic: [String: Any]?) {
        self.total = Dic?["total"] as? Int ?? 0
        self.totalHits = Dic?["totalHits"] as? Int ?? 0
        
        let passesAry = Dic?["passes"]as? [[String:Any]] ?? []
        self.hits =  passesAry.compactMap { (v: [String:Any]) -> PixabayApiImageList? in
            if v.count != 0 {return PixabayApiImageList(with: v) } else {return nil }
        }
    }
}


struct PixabayApiImageList:Codable  {
    
    var user:String
    var userImageURL:String
    var previewURL:String
    var largeImageURL:String
    var tags:String
    var imageWidth:Int
    var imageHeight:Int
    
    init(with dictionary: [String: Any]?) {
        self.user = dictionary?["user"] as? String ?? ""
        self.userImageURL = dictionary?["userImageURL"] as? String ?? ""
        self.previewURL = dictionary?["previewURL"] as? String ?? ""
        self.largeImageURL = dictionary?["largeImageURL"] as? String ?? ""
        self.tags = dictionary?["tags"] as? String ?? ""
        self.imageWidth = dictionary?["imageWidth"] as? Int ?? 0
        self.imageHeight = dictionary?["imageHeight"] as? Int ?? 0
    }
}
