//
//  CustomAlertVCViewController.swift
//  SAN SALES
//
//  Created by Naga Prasath on 18/03/24.
//

import UIKit

class CustomAlertVCViewController: UIViewController {
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var viewList: UIView!
    
    @IBOutlet weak var viewListHeightConstraints: NSLayoutConstraint!
    
    var cy:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cy = 5
        lblName.text = AlertData.shared.title
        
        self.updateList()
        self.viewListHeightConstraints.constant = cy
    }
    
    init() {
        super.init(nibName: "CustomAlertVCViewController", bundle: Bundle(for: CustomAlertVCViewController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateList() {
        
        let schemes = AlertData.shared.scheme
        for scheme in schemes {
            let view = ShadowView()
            view.shadowColor = .lightGray
            view.backgroundColor = .white
            
            let labelFree = UILabel()
            labelFree.backgroundColor = .white
            labelFree.textColor = .black
            labelFree.textAlignment = .left
            labelFree.numberOfLines = 0
            labelFree.font = UIFont.systemFont(ofSize: 16)
            
            labelFree.text = "Free : \(scheme.offerAvailableCount) \(scheme.offerProductName)"
            
            let maximamSize = CGSize(width: 200, height: 2000)
            let sizeLabelfit = labelFree.sizeThatFits(maximamSize)
            
            var newFrame : CGRect = labelFree.frame
            newFrame.origin.x = 8
            newFrame.origin.y = 45
            newFrame.size.height = sizeLabelfit.height
            newFrame.size.width = 200
            
            labelFree.frame = newFrame
            
            print(scheme)
            let stackView = UIStackView()
            
            stackView.axis = .horizontal
            stackView.frame = CGRect(x: 0, y: 0, width: self.viewList.frame.width-15 , height: 40)
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            
            let lblScheme = UILabel()
            
            let schemeType = scheme.schemeType == "Q" ? "Qty" : "₹"
            lblScheme.text = "Scheme : \(scheme.scheme) \(schemeType)"
            labelFree.textColor = .black
            labelFree.textAlignment = .left
            labelFree.numberOfLines = 0
            labelFree.font = UIFont.systemFont(ofSize: 16)
            
            let lblDicount = UILabel()
            let discountType = scheme.discountType == "%" ? "\(scheme.disCountPer) %" : " \(scheme.disCountValue) ₹"
            lblDicount.text = "Discount : \(discountType)"
            labelFree.textColor = .black
            labelFree.textAlignment = .left
            labelFree.numberOfLines = 0
            labelFree.font = UIFont.systemFont(ofSize: 16)
            
            stackView.addArrangedSubview(lblScheme)
            stackView.addArrangedSubview(lblDicount)
            
            view.addSubview(stackView)
            view.addSubview(labelFree)
            
            
            view.frame = CGRect(x: 5, y: cy, width: self.viewList.frame.width-15 , height: sizeLabelfit.height+45)
            
            viewList.addSubview(view)
            
            cy+=sizeLabelfit.height+50
        }
    }
    
    
    @IBAction func CloseAction(_ sender: UIButton) {
        AlertData.shared.clear()
        self.dismiss(animated: true)
        
    }
    
    
    func show() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class ShadowView: UIView {
    /// The corner radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow color of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowColor: UIColor = UIColor.lightGray {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow offset of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 2) {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowRadius: CGFloat = 4.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow opacity of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.updateProperties()
        }
    }

    /**
    Masks the layer to it's bounds and updates the layer properties and shadow path.
    */
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.masksToBounds = false

        self.updateProperties()
        self.updateShadowPath()
    }

    /**
    Updates all layer properties according to the public properties of the `ShadowView`.
    */
    fileprivate func updateProperties() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = self.shadowOpacity
    }

    /**
    Updates the bezier path of the shadow to be the same as the layer's bounds, taking the layer's corner radius into account.
    */
    fileprivate func updateShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    /**
    Updates the shadow path everytime the views frame changes.
    */
    override func layoutSubviews() {
        super.layoutSubviews()

        self.updateShadowPath()
    }
}

