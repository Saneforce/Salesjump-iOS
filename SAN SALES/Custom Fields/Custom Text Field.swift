//
//  Custom Text Field.swift
//  SAN SALES
//
//  Created by Anbu j on 16/12/24.
//

import Foundation
import UIKit

protocol CustomTextFieldDelegate: AnyObject {
    func customTextField(_ customTextField: CustomTextField, didUpdateText text: String,tags:[Int])
}

//class CustomTextField: UIView, UITextFieldDelegate {
//
//    // MARK: - Properties
//    weak var delegate: CustomTextFieldDelegate? // Delegate property
//    var tags: [Int] = []
//
//    // MARK: - UI Components
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Title"
//        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
//        label.alpha = 1
//        return label
//    }()
//
//    let textField: UITextField = {
//        let tf = UITextField()
//        tf.borderStyle = .roundedRect
//        tf.font = UIFont.systemFont(ofSize: 16)
//        tf.textColor = .black
//        return tf
//    }()
//
//    // MARK: - Initializers
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//        setupConstraints()
//        setupActions()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//        setupConstraints()
//        setupActions()
//    }
//
//    // MARK: - Setup Methods
//    private func setupView() {
//        addSubview(titleLabel)
//        addSubview(textField)
//        textField.delegate = self // Set the delegate
//    }
//
//    private func setupConstraints() {
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        textField.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor),
//
//            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
//            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
//            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
//            textField.heightAnchor.constraint(equalToConstant: 40),
//            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//    }
//
//    private func setupActions() {
//        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
//        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
//    }
//
//    // MARK: - Actions
//    @objc private func textFieldDidBeginEditing() {
//        animateTitle(visible: true)
//    }
//
//    @objc private func textFieldDidEndEditing() {
//        if let text = textField.text, !text.isEmpty {
//            delegate?.customTextField(self, didUpdateText: text, tags: tags) // Notify delegate
//        }
//    }
//
//    private func animateTitle(visible: Bool) {
//        UIView.animate(withDuration: 0.3) {
//            self.titleLabel.alpha = visible ? 1 : 1
//            self.titleLabel.transform = visible ? .identity : CGAffineTransform(translationX: 0, y: 0)
//        }
//    }
//
//    // MARK: - UITextFieldDelegate Methods
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = textField.text ?? ""
//        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
//        delegate?.customTextField(self, didUpdateText: updatedText, tags: tags) // Notify delegate
//        return true
//    }
//
//    // MARK: - Configuration
//    func configure(title: String, placeholder: String) {
//        titleLabel.text = title
//        textField.placeholder = placeholder
//    }
//}


class CustomTextField: UIView, UITextViewDelegate {

    // MARK: - Properties
    weak var delegate: CustomTextFieldDelegate?
    var tags: [Int] = []

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        label.alpha = 1
        return label
    }()

    let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .black
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 5
        tv.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        return tv
    }()

    // Height constraint for dynamic adjustment
    private var textViewHeightConstraint: NSLayoutConstraint?

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }

    // MARK: - Setup Methods
    private func setupView() {
        addSubview(titleLabel)
        addSubview(textView)
        textView.delegate = self
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),

            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Initialize height constraint for the text view
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 40)
        textViewHeightConstraint?.isActive = true
    }

    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

        // Update height constraint if the new height is different
        if textViewHeightConstraint?.constant != newSize.height {
            textViewHeightConstraint?.constant = newSize.height
            layoutIfNeeded() // Trigger layout updates
        }

        delegate?.customTextField(self, didUpdateText: textView.text, tags: tags)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        animateTitle(visible: true)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            delegate?.customTextField(self, didUpdateText: textView.text, tags: tags)
        }
    }

    // MARK: - Animation
    private func animateTitle(visible: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.alpha = visible ? 1 : 0.5
        }
    }

    // MARK: - Configuration
    func configure(title: String, placeholder: String) {
        titleLabel.text = title
        textView.text = placeholder
        textView.textColor = .lightGray
    }
}




/*


https://fmcg.salesjump.in/server/native_Db_V13_1.php?desig=MR&divisionCode=29&rSF=MR4126&axn=get%2FCustomDetails&sfCode=MR4126&stateCode=24&moduleId=3
02:39 PM

[{"unlisted_doctor_master_new":{"town_code":"'47607'","wlkg_sequence":"null","unlisted_doctor_name":"'test customer '","unlisted_doctor_address":"'4 Pasumpon Muthuramalinga Thevar Rd Nandanam Extension Nandanam Chenna'","unlisted_doctor_phone":"''","unlisted_doctor_cityname":"'Chennai'","unlisted_doctor_landmark":"''","unlisted_doctor_keyoutlet":"'0'","unlisted_doctor_address3":"'4 Pasumpon Muthuramalinga Thevar Ro'","unlisted_timestamp":"1734340622000","unlisted_deviceId":"5629104e7cfe52c1","sf_name":"kumar","Retailerphoto":{"imgurl":"1000000334.png"},"lat":"'13.0299703'","long":"'80.2414027'","unlisted_doctor_areaname":"''","unlisted_doctor_contactperson":"'test owner '","unlisted_doctor_designation":"''","unlisted_doctor_statename":"Tamil Nadu","unlisted_doctor_stateid":"24","unlisted_doctor_gst":"''","unlisted_doctor_pincode":"'600035'","unlisted_doctor_email":"''","unlisted_doctor_phone2":"''","unlisted_doctor_phone3":"''","unlisted_doctor_contactperson2":"''","unlisted_doctor_contactperson3":"''","unlisted_doctor_designation2":"''","unlisted_cat_code":"null","unlisted_specialty_code":754,"unlisted_qulifi":"'samp'","unlisted_class":324,"DrKeyId":"'N-MR4126-1734340622000'","geoTaggingAddress":0,"address":"4 Pasumpon Muthuramalinga Thevar Rd Nandanam Extension Nandanam Chennai Tamil Nadu 600035 India"}}]


[{"retailer_dynamic_data":{"sf_code":"'MR4126'","town_code":"'47607'"}},{"dynamic_data_detail":[{"groupId":14,"grpTableName":"CFGT3_20230831163319","itemdetail":[{"column_name":"Fld314admin_638290964339943847","data_value":"MR4126_file_2732883129809387344.pdf"},{"column_name":"Fld314admin_638290964654251039","data_value":"MR4126_Screenshot_20241209-171729.png"},{"column_name":"Fld314admin_638329914930378882","data_value":"16/12/2024"}]},{"groupId":15,"grpTableName":"CFGT3_20230831173449","itemdetail":[{"column_name":"Fld315admin_638291001583643330","data_value":"Tamil,English,Hindi"}]},{"groupId":16,"grpTableName":"CFGT3_20230831175218","itemdetail":[{"column_name":"Fld316admin_638327104400784942","data_value":"Red,Green,Yellow"},{"column_name":"Fld316admin_638291013003328483","data_value":"Male"},{"column_name":"Fld316admin_638291024489548894","data_value":"YES"},{"column_name":"Fld316admin_638292490208260638","data_value":"02:49 PM"},{"column_name":"Fld316admin_638292493742671172","data_value":"testing@123"},{"column_name":"Fld316admin_6382927023548113264","data_value":"5330"},{"column_name":"Fld316admin_638293801038018374","data_value":"13"},{"column_name":"Fld316admin_638293801518075833","data_value":"114727,114729,139289"},{"column_name":"Fld316admin_638292486184698346","data_value":"28"},{"column_name":"Fld316admin_638292486609046180","data_value":"16/12/2024"},{"column_name":"Fld316admin_638292702354813264","data_value":"Wednesday,Tuesday"},{"column_name":"Fld316admin_638293785669418411","data_value":"36"},{"column_name":"Fld316admin_638293785966364774","data_value":"1841,3904"},{"column_name":"Fld316admin_638316011941132512","data_value":"547"},{"column_name":"Fld316admin_638316015289091640","data_value":"2956,1635"}]},{"groupId":44,"grpTableName":"CFGT3_20231220142031","itemdetail":[]},{"groupId":46,"grpTableName":"CFGT3_202402131711","itemdetail":[]}]}]

02:53 PM

{"success":true,"sql_re":"select * from Mas_ListedDr with(nolock) where listeddr_name='test customer ' and Territory_Code='47607'","sqlFGT":"select count(division_code) cnt from Access_Master with(nolock) where division_code='29' and isnull(ForceGeoTag,0)=1","Query":"{call svListedDR_APP_Native_New('MR4126','test customer ','4 Pasumpon Muthuramalinga Thevar Rd Nandanam Extension Nandanam Chenna','','Chennai','','test owner ', ' ','',24,'600035',754,null,'47607',0,'2024-12-16 14:52:01',29,324,0,null,'','','N-MR4126-1734340622000','','','', '','test customer 2024-12-16 14:52:01','','','','MR4126_1000000334.png','13.0299703','80.2414027','','' ,'','','','4 Pasumpon Muthuramalinga Thevar Ro','','','','1','1000000334.png','','Tamil Nadu','24' )}"}
02:53 PM

{"success":true,"msg":"Inserted Successfully","params1":"INSERT INTO CFGT3_202402131711 (Retail_code) VALUES ('2562323')"}
02:54 PM

[{"unlisted_doctor_master_new":{"town_code":"'47607'","wlkg_sequence":"null","unlisted_doctor_name":"'test customer '","unlisted_doctor_address":"'4 Pasumpon Muthuramalinga Thevar Rd Nandanam Extension Nandanam Chenna'","unlisted_doctor_phone":"''","unlisted_doctor_cityname":"'Chennai'","unlisted_doctor_landmark":"''","unlisted_doctor_keyoutlet":"'0'","unlisted_doctor_address3":"'4 Pasumpon Muthuramalinga Thevar Ro'","unlisted_timestamp":"1734340622000","unlisted_deviceId":"5629104e7cfe52c1","sf_name":"kumar","Retailerphoto":{"imgurl":"1000000334.png"},"lat":"'13.0299703'","long":"'80.2414027'","unlisted_doctor_areaname":"''","unlisted_doctor_contactperson":"'test owner '","unlisted_doctor_designation":"''","unlisted_doctor_statename":"Tamil Nadu","unlisted_doctor_stateid":"24","unlisted_doctor_gst":"''","unlisted_doctor_pincode":"'600035'","unlisted_doctor_email":"''","unlisted_doctor_phone2":"''","unlisted_doctor_phone3":"''","unlisted_doctor_contactperson2":"''","unlisted_doctor_contactperson3":"''","unlisted_doctor_designation2":"''","unlisted_cat_code":"null","unlisted_specialty_code":754,"unlisted_qulifi":"'samp'","unlisted_class":324,"DrKeyId":"'N-MR4126-1734340622000'","geoTaggingAddress":0,"address":"4 Pasumpon Muthuramalinga Thevar Rd Nandanam Extension Nandanam Chennai Tamil Nadu 600035 India"}}]



[{\"unlisted_doctor_master\":{\"town_code\":\"'" + NewOutlet.shared.Route.id + "'\",\"wlkg_sequence\":\"null\",\"Retailerphoto\":{\"imgurl\":\"" + NewOutlet.shared.ImgFileName + "\"},\"unlisted_doctor_name\":\"'" + NewOutlet.shared.OutletName + "'\",\"unlisted_doctor_address\":\"'" + NewOutlet.shared.Address + "'\",\"unlisted_doctor_phone\":\"'" + NewOutlet.shared.Mobile + "'\",\"unlisted_doctor_cityname\":\"'" + NewOutlet.shared.City + "'\",\"unlisted_doctor_landmark\":\"''\",\"lat\":\"'" + NewOutlet.shared.Lat + "'\",\"long\":\"'" + NewOutlet.shared.Lng + "'\",\"unlisted_doctor_areaname\":\"'" + NewOutlet.shared.Street + "'\",\"unlisted_doctor_contactperson\":\"'" + NewOutlet.shared.OwnerName + "'\",\"unlisted_doctor_designation\":\"''\",\"unlisted_doctor_gst\":\"''\",\"unlisted_doctor_pincode\":\"'" + NewOutlet.shared.Pincode + "'\",\"unlisted_doctor_email\":\"''\",\"unlisted_doctor_phone2\":\"''\",\"unlisted_doctor_phone3\":\"''\",\"unlisted_doctor_contactperson2\":\"''\",\"unlisted_doctor_contactperson3\":\"''\",\"unlisted_doctor_designation2\":\"''\",\"unlisted_cat_code\":\"null\",\"unlisted_specialty_code\":" + NewOutlet.shared.Category.id + ",\"unlisted_qulifi\":\"'samp'\",\"unlisted_class\":" + NewOutlet.shared.Class.id + ",\"DrKeyId\":\"'" + eKey + "'\",\"ListedDr_DOB\":\"'" + NewOutlet.shared.DOB.id + "'\",\"ListedDr_DOW\":\"''\",\"layer\":\"''\",\"breeder\":\"''\",\"broiler\":\"''\",\"distributor_id\":\"'" +  NewOutlet.shared.Dist.id + "'\"}}] */
