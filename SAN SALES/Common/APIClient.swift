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
  // RAD QA URL
   // var BaseURL: String = "http://qa.salesjump.in"
    var ProdImgURL: String = "http://fmcg.sanfmcg.com/MasterFiles/PImage/"
    //var DBURL="/server/db_v13.php?axn="
    var DBURL="/server/native_Db_V13-Mani.php?axn="
    var DBURL1="/server/native_Db_V13.php?axn="
    var DBURL2="/server/native_Db_V13-Mani2.php?axn="
    var imgurl="http://fmcg.sanfmcg.com/Photos/"
    var CustomFieldDB="/server/native_Db_V13_1.php?axn="
    
}
