//
//  NewOutlet.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 28/05/22.
//

import Foundation
import UIKit
class NewOutlet{
    static var shared = NewOutlet()
    struct item: Any {
        var id: String=""
        var name: String=""
        var Stk_Id:String = ""
    }
    
    var HQ: item = item()
    var Dist: item = item()
    var Route: item = item()
    var OutletName: String = ""
    var KeyOutlet: Int = 0
    var OwnerName: String = ""
    var Image: UIImage = UIImage()
    var ImgFileName: String = ""
    var Lat: String = ""
    var Lng: String = ""
    var Address:String = ""
    var Street:String = ""
    var City:String = ""
    var Pincode:String = ""
    var Mobile:String = ""
    var DOB: item = item()
    var Class: item = item()
    var Category: item = item()
    
    func Clear(){
        HQ = item()
        Dist = item()
        Route = item()
        OutletName = ""
        KeyOutlet = 0
        OwnerName = ""
        Image = UIImage()
        ImgFileName = ""
        Lat = ""
        Lng = ""
        Address = ""
        Street = ""
        City = ""
        Pincode = ""
        Mobile = ""
        DOB = item()
        Class = item()
        Category = item()
    }
}
