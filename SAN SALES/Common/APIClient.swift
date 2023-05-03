//
//  APIClient.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 18/03/22.
//

import Foundation
class APIClient{
    static let shared = APIClient()
    var BaseURL: String = "http://fmcg.sanfmcg.com"
    var ProdImgURL: String = "https://fmcg.sanfmcg.com/MasterFiles/PImage/"
    //var DBURL="/server/db_v13.php?axn="
    var DBURL="/server/native_Db_V13-Mani.php?axn="
    
}
