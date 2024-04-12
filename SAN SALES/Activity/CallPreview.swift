//
//  CallPreview.swift
//  SAN SALES
//
//  Created by Naga Prasath on 29/03/24.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation

class CallPreview : UIViewController , UITableViewDataSource,UITableViewDelegate{
    
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobileNum: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblRoute: UILabel!
    
    
    @IBOutlet weak var lblOrderTakenBy: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var lblTotalFreeQty: UILabel!
    @IBOutlet weak var lblTotalValue: UILabel!
    
    @IBOutlet weak var lblTotalSchemeDiscount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    
    @IBOutlet weak var lblAddress: UILabel!
    
    
    @IBOutlet weak var vwWhatsAp: UIView!
    
    
    @IBOutlet weak var orderDetailsTableView: UITableView!
    @IBOutlet weak var freeQtyTableView: UITableView!
    
    
    @IBOutlet weak var OrderDetailsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var freeQtyTableViewHeightConstraint: NSLayoutConstraint!
    
    var orders = [ProductList]()
    
    let LocalStoreage = UserDefaults.standard
    var SFCode: String = "" , StateCode = ""
    var DataSF: String = ""
    var DivCode: String = ""
    var Desig: String = ""
    var eKey : String = ""
    var sfName : String = ""
    
    var sAddress: String = ""
    var Location : String = ""
    
    var mobile : String = ""
    var addrs : String = ""
    var date : String = ""
    var route : String = ""
    var total : String = ""
    
    var totalTaxAmount : String = ""
    var totalDiscAmount : String = ""
    
    var totalFreeQty : String = ""
    
    var orderNo : String = ""
    
    var lstSuppList: [AnyObject] = []
    var lstAllRoutes: [AnyObject] = []
    var lstPlnDetail: [AnyObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserDetails()
        imgBack.addTarget(target: self, action: #selector(GotoHome))
        
        self.getOrderNo()
        
        freeQtyTableViewHeightConstraint.constant = 300
        OrderDetailsTableViewHeightConstraint.constant = 300
        
        let lstDistData: String = LocalStoreage.string(forKey: "Supplier_Master_"+SFCode)!
        if let list = GlobalFunc.convertToDictionary(text: lstDistData) as? [AnyObject] {
            lstSuppList = list;
        }
        
        
        if let RouteData = LocalStoreage.string(forKey: "Route_Master_"+SFCode),
           let list = GlobalFunc.convertToDictionary(text:  RouteData) as? [AnyObject] {
            lstAllRoutes = list
        }
        
        let PlnDets: String=LocalStoreage.string(forKey: "Mydayplan")!
        if let list = GlobalFunc.convertToDictionary(text: PlnDets) as? [AnyObject] {
            lstPlnDetail = list
            self.route = lstPlnDetail[0]["ClstrName"] as? String ?? ""
        }
        
        self.orders = VisitData.shared.selectedOrders
        
        print(lstAllRoutes)
        
        
        self.getlocation()
        
        vwWhatsAp.addTarget(target: self, action: #selector(send))
        
    }
    
    @objc func send(_ sender : UITapGestureRecognizer) {
        
        saveAndSharePDF(generatePDF())
    }
    
    func getUserDetails(){
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        SFCode = prettyJsonData["sfCode"] as? String ?? ""
        sfName = prettyJsonData["sfName"] as? String ?? ""
        StateCode = prettyJsonData["State_Code"] as? String ?? ""
        DivCode = prettyJsonData["divisionCode"] as? String ?? ""
        Desig=prettyJsonData["desigCode"] as? String ?? ""
    }
    
    
    func updateSummary(OrderNo : String){
        lblName.text = VisitData.shared.CustName
        
        let custId = VisitData.shared.CustID
        
        let supplier = self.lstSuppList.filter({(supplier) in
            let id: String = String(format: "%@", supplier["id"] as! CVarArg)
            return Bool(custId == id)
        })
        
        print(supplier)
        
        if supplier.count > 0 {
            let addrs: String = String(format: "%@", supplier[0]["addrs"] as! CVarArg)
            let mobile: String = String(format: "%@", supplier[0]["mobile"] as! CVarArg)
            
            
            lblMobileNum.text = "Mob No : \(mobile)"
            
            lblCode.text = addrs
            
            lblRoute.text = "ROUTE: \(self.route)"
            
            self.mobile = mobile
            self.addrs = addrs
        }
        
        
        lblOrderTakenBy.text = "Order Taken By : \(self.sfName)"
        lblOrderNo.text = "Order No : \(OrderNo)"
        
        lblDate.text = "Date : \(Date().toString(format: "yyyy-MM-dd HH:mm:ss"))"
        
        let totalAmount = orders.map{$0.totalCount}.reduce(0){$0 + $1}
        
        let totalfreeQty = orders.map{$0.freeCount}.reduce(0){$0 + $1}
        
        let disCountAmount = orders.map{$0.disCountAmount}.reduce(0){$0 + $1}
        
        let taxAmount = orders.map{$0.taxAmount}.reduce(0){$0 + $1}
        
        lblTotalFreeQty.text = "\(totalfreeQty)"
        let totalAmt = totalAmount + disCountAmount
        
        lblTotalValue.text = "\(Double(round(100 * totalAmt) / 100))"
        
        lblTotalSchemeDiscount.text  = "\(Double(round(100 * disCountAmount) / 100))"
        
        lblTotal.text = "\(Double(round(100 * totalAmount) / 100))"
        
        total = "\(Double(round(100 * totalAmount) / 100))"
        date = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
        
        
        totalDiscAmount = "\(Double(round(100 * disCountAmount) / 100))"
        totalTaxAmount = "\(Double(round(100 * taxAmount) / 100))"
        
        orderNo = OrderNo
        
        totalFreeQty = "\(totalfreeQty)"
        
        self.freeQtyTableView.reloadData()
        self.orderDetailsTableView.reloadData()
        self.orderDetailsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        
    }
    
    func getlocation() {
        LocationService.sharedInstance.getNewLocation(location: { location in
            let sLocation: String = location.coordinate.latitude.description + ":" + location.coordinate.longitude.description
            lazy var geocoder = CLGeocoder()
            self.Location = sLocation
            
            
            geocoder.reverseGeocodeLocation(location ) { (placemarks, error) in
                
                if(placemarks != nil){
                    if(placemarks!.count>0){
                        let jAddress:[String] = placemarks![0].addressDictionary!["FormattedAddressLines"] as! [String]
                        for i in 0...jAddress.count-1 {
                            print(jAddress[i])
                            if i==0{
                                self.sAddress = String(format: "%@", jAddress[i])
                            }else{
                                self.sAddress = String(format: "%@, %@", self.sAddress,jAddress[i])
                            }
                        }
                    }
                }
                
                self.lblAddress.text = self.sAddress
                
            }
            
        }, error:{ errMsg in
            self.LoadingDismiss()
            Toast.show(message: errMsg, controller: self)
            
        })
    }
    
    func getOrderNo() {
        
        print("Ekey===\(self.eKey)")
        
        let param  = "{\"CallPreviewEkey\":\"\(eKey)\"}"
        
        let params : [String : Any] = ["data":"[\(param)]"]
        
 //   http://fmcg.salesjump.in/server/native_Db_V13.php?axn=dcr%2Fsave&divisionCode=29%2C&sfCode=SEFMR0040&desig=MR
        
        print(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.DivCode + "&sfCode=" + self.SFCode + "&desig=" + self.Desig)
        
        print(params)
        self.ShowLoading(Message: "Loading...")
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL1+"dcr/save&divisionCode=" + self.DivCode + "&sfCode=" + self.SFCode + "&desig=" + self.Desig, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseData {
        AFdata in
        
//        DispatchQueue.main.async {
//            self.LoadingDismiss()
//        }
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.LoadingDismiss()
        }
        
        switch AFdata.result
        {
            
        case .success(let value):
            print(value)
            
            let apiResponse = try? JSONSerialization.jsonObject(with: AFdata.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
            print(apiResponse as Any)
            
            guard let response = apiResponse as? [String : Any] else{
                return
            }
            
            guard let responsearr = response["Output"] as? [[String : Any]] else{
                return
            }
            
            print(responsearr.first?["Trans_Sl_No"] as? String ?? "")
            
            self.updateSummary(OrderNo: responsearr.first?["Trans_Sl_No"] as? String ?? "")
            
            
        case .failure(let error):
            let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                return
            })
            self.present(alert, animated: true)
        }
            
    }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == orderDetailsTableView {
            OrderDetailsTableViewHeightConstraint.constant = orderDetailsTableView.contentSize.height + 20
            return orders.count
            
        }else{
            let freeQtyCount = self.orders.filter{$0.freeCount != 0}
            freeQtyTableViewHeightConstraint.constant = freeQtyTableView.contentSize.height + 20
            return freeQtyCount.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == orderDetailsTableView {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "CallPreviewOrderDetailTableViewCell", for: indexPath) as! CallPreviewOrderDetailTableViewCell
            Cell.lblItemName.text = self.orders[indexPath.row].productName
            Cell.lblUOM.text = self.orders[indexPath.row].unitName
            Cell.lblQty.text = self.orders[indexPath.row].sampleQty
            Cell.lblRate.text = "\(self.orders[indexPath.row].rate)"
            Cell.lblTotal.text = "\(self.orders[indexPath.row].totalCount)"
            Cell.lblCl.text = "0"
            Cell.lblFreeQty.text = "\(self.orders[indexPath.row].freeCount)"
            Cell.lblDisc.text = "\(self.orders[indexPath.row].disCountAmount)"
            Cell.lblTax.text = "\(self.orders[indexPath.row].taxAmount)"
            return Cell
        }else {
            let freeQtyCount = self.orders.filter{$0.freeCount != 0}
            let Cell = tableView.dequeueReusableCell(withIdentifier: "CallPreviewFreeQuantityTableViewCell", for: indexPath) as! CallPreviewFreeQuantityTableViewCell
            
            if UserSetup.shared.SchemeBased == 1 && UserSetup.shared.offerMode == 1{
                Cell.lblFreeProductName.text = freeQtyCount[indexPath.row].offerProductName == "" ? freeQtyCount[indexPath.row].productName : freeQtyCount[indexPath.row].offerProductName
                Cell.lblQty.text = "\(freeQtyCount[indexPath.row].freeCount)"
            }else {
                Cell.lblFreeProductName.text = freeQtyCount[indexPath.row].productName
                Cell.lblQty.text = "\(freeQtyCount[indexPath.row].freeCount)"
            }
            
            return Cell
        }
        
        
    }
    
    
    func generatePDF() -> Data {
            
            let pageSize = CGSize(width: 612, height: 2400)
            let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
            
            let pdfData = renderer.pdfData { (context) in
                // Begin PDF page
                context.beginPage()
                
                // Define font and size for title and text
                let titleFont = UIFont.boldSystemFont(ofSize: 20.0)
                let textFont = UIFont.systemFont(ofSize: 12.0)
                let textFontaSmal = UIFont.boldSystemFont(ofSize: 10.0)
                let textId = UIFont.systemFont(ofSize: 12.0)
                let ComFont = UIFont.systemFont(ofSize: 12.0)
                let Bill = UIFont.systemFont(ofSize: 15.0)
                
                // Define title and text
                let title = "ORDER SUMMARY"
                let text = VisitData.shared.CustName
                let Mob = "Mob No: \(self.mobile)"
                let addrs = self.addrs
                let Route = self.route
                let orderTakenBy = "Order Taken By:  \(self.sfName)"
                let OrderNo = "Order No: \(self.orderNo)"
                
                
                let BillDate = "Date :\(self.date)"
                let Item = "Product Name"
                let rate = "Rate"
                let Uom = "UOM"
                let Qty = "Qty"
                let Free = "Free"
                let disc = "Disc"
                let Tax = "Tax"
                let Total = "Total"
                let offerProductName = "Offer Product Name"
                let TotalValue = "Total Value"
                let TotalAmount = "₹ "+self.total
                let totalFreeQty = "Total Free Qty"
                let totalFreeQtyCount = self.totalFreeQty
                let TotalDisc = "Total Discount"
                let TotalDiscVal = "₹ " + self.totalDiscAmount
                
                var CountOfOrder = ""
                
                var TotaCountOfQty = "0"
                
                let TotalTaxs = "Tax Amount" //
                let TatalTaxAmt = "₹ " + self.totalTaxAmount
                let NetAmt = "NET AMOUNT"
                let TotalNetAmt = "₹\(self.total)"
                
                // Draw title
                let titleAttributes = [NSAttributedString.Key.font: titleFont]
                let titleRect = CGRect(x: 210, y: 50, width: 512, height: 50)
                title.draw(in: titleRect, withAttributes: titleAttributes)
                
                // Draw text
                let textAttributes = [NSAttributedString.Key.font: textFont]
                let textRect = CGRect(x: 50, y: 100, width: 512, height: 50)
                text.draw(in: textRect, withAttributes: textAttributes)
                
                let MobAttributes = [NSAttributedString.Key.font:ComFont]
                let MobRect = CGRect(x: 50, y: 120, width: 512, height: 50)
                Mob.draw(in:MobRect,withAttributes: MobAttributes)
                
                let addrsAttributes = [NSAttributedString.Key.font:ComFont]
                let addrsRec = CGRect(x: 50, y: 140, width: 512, height: 50)
                addrs.draw(in:addrsRec,withAttributes: addrsAttributes)
                
                let routeAt = [NSAttributedString.Key.font:ComFont]
                let routeRec = CGRect(x: 50, y: 160, width: 512, height: 50)
                Route.draw(in:routeRec,withAttributes: routeAt)
                
                let orderTakenByAt = [NSAttributedString.Key.font:ComFont]
                let orderTakenByRec = CGRect(x: 50, y: 180, width: 512, height: 50)
                orderTakenBy.draw(in:orderTakenByRec,withAttributes: orderTakenByAt)
                
                let OrderNoAt = [NSAttributedString.Key.font:ComFont]
                let OrderNoRec = CGRect(x: 50, y: 200, width: 512, height: 50)
                OrderNo.draw(in:OrderNoRec,withAttributes: OrderNoAt)
                
                
                let OrdDateAt = [NSAttributedString.Key.font:ComFont]
                let Date = CGRect(x: 50, y: 220, width: 512, height: 50)
                BillDate.draw(in:Date,withAttributes: OrdDateAt)
                
            
                let UperLine = UIGraphicsGetCurrentContext()
                UperLine?.setLineWidth(1.0)
                UperLine?.move(to: CGPoint(x: 0, y: 250))
                UperLine?.addLine(to: CGPoint(x: 700, y: 250))
                UperLine?.strokePath()
               
                let ItemAt = [NSAttributedString.Key.font:ComFont]
                let ItemRe = CGRect(x: 50, y: 260, width: 512, height: 30)
                Item.draw(in:ItemRe,withAttributes: ItemAt)
                
                let UomRe = CGRect(x: 50, y: 280, width: 512, height: 50)
                Uom.draw(in:UomRe,withAttributes: ItemAt)
                let QtyRe = CGRect(x: 150, y: 280, width: 512, height: 50)
                Qty.draw(in:QtyRe,withAttributes: ItemAt)
                
                let discRe = CGRect(x: 300, y: 280, width: 512, height: 50)
                disc.draw(in:discRe,withAttributes: ItemAt)
                
                let rateRe = CGRect(x: 50, y: 310, width: 512, height: 50)
                rate.draw(in:rateRe,withAttributes: ItemAt)
                let TaxRe = CGRect(x: 150, y: 310, width: 512, height: 50)
                Tax.draw(in:TaxRe,withAttributes: ItemAt)
                let TotalRe = CGRect(x: 300, y: 310, width: 512, height: 50)
                Total.draw(in:TotalRe,withAttributes: ItemAt)
                
                let offerProductRe = CGRect(x: 50, y: 340, width: 250, height: 50)
                offerProductName.draw(in:offerProductRe,withAttributes: ItemAt)
            
                let FreeRe = CGRect(x: 300, y: 340, width: 512, height: 50)
                Free.draw(in:FreeRe,withAttributes: ItemAt)
                
                let LowLine = UIGraphicsGetCurrentContext()
                LowLine?.setLineWidth(1.0)
                LowLine?.move(to: CGPoint(x: 0, y: 355))
                LowLine?.addLine(to: CGPoint(x: 700, y: 355))
                LowLine?.strokePath()
       
                var yOffset = 380
          
                for orderIndex in 0..<self.orders.count {
                    
                    let TotatNoofQty = Int(self.orders[orderIndex].sampleQty)! + Int(TotaCountOfQty)!
                    TotaCountOfQty = String(TotatNoofQty)
                    
                    let Count = orderIndex + 1
                    CountOfOrder = String(Count)
                     let NoOfPro = "\(Count)."
                    let orderNoAttributes = [NSAttributedString.Key.font: textFont]
                    let orderNoAttributes_small = [NSAttributedString.Key.font: textFontaSmal]
                    let NoOfInd = CGRect(x: 20, y: yOffset, width: 512, height: 50)
                    NoOfPro.draw(in:NoOfInd,withAttributes:orderNoAttributes )
                    
                    let ProName = self.orders[orderIndex].productName
                    let orderNoRect = CGRect(x: 50, y: yOffset, width: 512, height: 30)
                    ProName.draw(in: orderNoRect, withAttributes: orderNoAttributes)
                     // Increase y-coordinate for next OrderNo
                
                    
                    
                    let Uom = self.orders[orderIndex].unitName
                    let UomRect = CGRect(x: 50, y: yOffset + 25, width: 512, height: 30)
                    Uom.draw(in: UomRect, withAttributes: orderNoAttributes)
                
                    let Qty = self.orders[orderIndex].sampleQty
                    let QtyRect = CGRect(x: 150, y: yOffset + 25, width: 512, height: 30)
                    Qty.draw(in: QtyRect, withAttributes: orderNoAttributes)
                    
                    let discVal = "₹ " + "\(self.orders[orderIndex].disCountAmount)"
                    let discValRect = CGRect(x: 300, y: yOffset + 25, width: 512, height: 30)
                    discVal.draw(in:discValRect,withAttributes: orderNoAttributes)
                    
                    let rateVal = "₹ " + "\(self.orders[orderIndex].rate)"
                    let rateValRect = CGRect(x: 50, y: yOffset + 50, width: 512, height: 30)
                    rateVal.draw(in: rateValRect, withAttributes: orderNoAttributes)
                    
                    
                    let tax = "₹ " + "\(self.orders[orderIndex].taxAmount)"
                    let taxRect = CGRect(x: 150, y: yOffset + 50, width: 512, height: 30)
                    tax.draw(in:taxRect,withAttributes: orderNoAttributes)
                    
                    let Total = "₹ " + "\(self.orders[orderIndex].totalCount)"
                    let TotalRect = CGRect(x: 300, y: yOffset + 50, width: 512, height: 30)
                    Total.draw(in:TotalRect,withAttributes: orderNoAttributes)
                    
                    
                    var freeQtyName = ""
                    
                    if UserSetup.shared.SchemeBased == 1 && UserSetup.shared.offerMode == 1{
                        if self.orders[orderIndex].freeCount > 0 {
                            freeQtyName = self.orders[orderIndex].offerProductName == "" ? self.orders[orderIndex].productName : self.orders[orderIndex].offerProductName
                        }
                        
                    }else {
                        if self.orders[orderIndex].freeCount > 0 {
                            freeQtyName = self.orders[orderIndex].productName
                        }
                        
                    }
                    
                    let freeQtyNameRect = CGRect(x: 50, y: yOffset + 75, width: 250, height: 30)
                    freeQtyName.draw(in:freeQtyNameRect,withAttributes: orderNoAttributes)
                    
                    let freeQty = "\(self.orders[orderIndex].freeCount)"
                    let freeQtyRect = CGRect(x: 300, y: yOffset + 75, width: 512, height: 30)
                    freeQty.draw(in:freeQtyRect,withAttributes: orderNoAttributes)
                    
                    
                    yOffset += 110
                   
                }
                print(TotaCountOfQty)
     
                let context = UIGraphicsGetCurrentContext()
                       context?.setLineWidth(1.0)
                       context?.move(to: CGPoint(x: 0, y: yOffset+50))
                       context?.addLine(to: CGPoint(x: 700, y: yOffset+50))
                       context?.strokePath()
                
                let SuTotalRe = CGRect(x: 50, y: yOffset+60, width: 512, height: 50)
                TotalValue.draw(in:SuTotalRe,withAttributes: ItemAt)
                let SubTotalAmtRe = CGRect(x: 400, y: yOffset+60, width: 512, height: 50)
                TotalAmount.draw(in:SubTotalAmtRe,withAttributes: ItemAt)
                let TotalItemRe = CGRect(x: 50, y: yOffset+80, width: 512, height: 50)
                totalFreeQty.draw(in:TotalItemRe,withAttributes: ItemAt)
                let CountOfRe = CGRect(x: 400, y: yOffset+80, width: 512, height: 50)
                totalFreeQtyCount.draw(in:CountOfRe,withAttributes: ItemAt)
                
                let TotalQtyRe = CGRect(x: 50, y: yOffset+100, width: 512, height: 50)
                TotalDisc.draw(in:TotalQtyRe,withAttributes: ItemAt)
                let TotalCotQty = CGRect(x: 400, y: yOffset+100, width: 512, height: 50)
                TotalDiscVal.draw(in:TotalCotQty,withAttributes: ItemAt)
                let TotalTaxRe = CGRect(x: 50, y: yOffset+120, width: 512, height: 50)
                TotalTaxs.draw(in:TotalTaxRe,withAttributes: ItemAt)
                let TatalTaxAmtRe = CGRect(x: 400, y: yOffset+120, width: 512, height: 50)
                TatalTaxAmt.draw(in:TatalTaxAmtRe,withAttributes: ItemAt)
       
                
                let SubTotalUpLine = UIGraphicsGetCurrentContext()
                SubTotalUpLine?.setLineWidth(1.0)
                SubTotalUpLine?.move(to: CGPoint(x: 0, y: yOffset+140))
                SubTotalUpLine?.addLine(to: CGPoint(x: 700, y: yOffset+140))
                SubTotalUpLine?.strokePath()
                
                let NetAmtRe = CGRect(x: 50, y: yOffset+160, width: 512, height: 50)
                NetAmt.draw(in:NetAmtRe,withAttributes: ItemAt)
                
                let TotNetAmtRe = CGRect(x: 400, y: yOffset+160, width: 512, height: 50)
                TotalNetAmt.draw(in:TotNetAmtRe,withAttributes: ItemAt)
                
                let SubTotalDwnLine = UIGraphicsGetCurrentContext()
                SubTotalDwnLine?.setLineWidth(1.0)
                SubTotalDwnLine?.move(to: CGPoint(x: 0, y: yOffset+180))
                SubTotalDwnLine?.addLine(to: CGPoint(x: 700, y: yOffset+180))
                SubTotalDwnLine?.strokePath()
                
                
            }
            return pdfData
        }
        func saveAndSharePDF(_ data: Data) {
           // print(OrderNo)
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(self.orderNo).pdf")
            do {
                try data.write(to: tempURL)
                let activityViewController = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
            } catch {
                print("Error saving PDF: \(error)")
            }
        }
    
    @objc func GotoHome() {
        self.dismiss(animated: true, completion: nil)
        GlobalFunc.movetoHomePage()
    }
}



class CallPreviewOrderDetailTableViewCell : UITableViewCell{
    
    
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblUOM: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    
    @IBOutlet weak var lblCl: UILabel!
    @IBOutlet weak var lblFreeQty: UILabel!
    @IBOutlet weak var lblDisc: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


class CallPreviewFreeQuantityTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var lblFreeProductName: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
