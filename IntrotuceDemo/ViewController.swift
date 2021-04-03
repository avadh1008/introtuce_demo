//
//  ViewController.swift
//  IntrotuceDemo
//
//  Created by Avadh Mevada on 17/03/21.
//

import UIKit
import Firebase


class ViewController: UIViewController, ImagePickerDelegate {
    
    @IBOutlet weak var mainSegmentBar: UISegmentedControl!
    @IBOutlet weak var lineViewUser: UILabel!
    @IBOutlet weak var lineViewEnroll: UILabel!
    @IBOutlet weak var tblUserList: UITableView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtSatate: UITextField!
    @IBOutlet weak var txtHomeTown: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtTelephoneNo: UITextField!
    @IBOutlet weak var viewEnroll: UIView!
    var isNewImageSelected = false
    var imagePicker: ImagePicker!
    let dateFormatter = DateFormatter()
    var datePicker : UIDatePicker!
    var toolBar = UIToolbar()
    var userReff = DatabaseReference.init()
    var arrUserDetails = [UserDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userReff = Database.database().reference()
        fetchUser()
        setupView()
        tapGestures()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

    }
    
    func tapGestures(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapDate(_:)))
        self.txtDOB.addGestureRecognizer(tap)
        let tapGender = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGender(_:)))
        self.txtGender.addGestureRecognizer(tapGender)
//        let tapImage = UITapGestureRecognizer(target: self, action: #selector(self.handleTapImage(_:)))
//        self.ImageView.addGestureRecognizer(tapImage)

    }
    
    func SelectGender(){
        let alert = UIAlertController(title: "Introtuce", message: "Please Select an Gender", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Male", style: .default , handler:{ (UIAlertAction)in
            self.txtGender.text = "Male"
        }))
        
        alert.addAction(UIAlertAction(title: "Female", style: .default , handler:{ (UIAlertAction)in
            self.txtGender.text = "Female"
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
   
    @objc func handleTapDate(_ gestureRecognizer: UITapGestureRecognizer? = nil) {
        doDatePicker()
    }
    @objc func handleTapGender(_ gestureRecognizer: UITapGestureRecognizer? = nil) {
        SelectGender()
    }
    func doDatePicker(){
        // DatePicker
        
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: UIScreen.main.bounds.height - 150, width: self.view.frame.size.width, height: 150))
        self.datePicker?.backgroundColor = UIColor.white
        self.datePicker?.datePickerMode = UIDatePicker.Mode.date
        if #available(iOS 13.4, *) {
            self.datePicker?.preferredDatePickerStyle = .automatic
        } else {
        }
        // ToolBar
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar = UIToolbar(frame:CGRect(x: 0, y: UIScreen.main.bounds.height - 150, width: self.view.frame.size.width, height: 50))
        toolBar.tintColor = UIColor.systemTeal
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
            txtDOB.inputAccessoryView = toolBar
            txtDOB.inputView = datePicker
        self.view.addSubview(datePicker)
        self.view.addSubview(toolBar)
    }
    
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        let dateFormater = dateFormatter
        dateFormater.dateFormat = "dd/MM/yyyy"
        dateFormater.timeZone = .current
        let selectedDate = dateFormater.string(from: datePicker.date)
            txtDOB.text = "\(selectedDate)"
        
        self.view.willRemoveSubview(datePicker)
        self.datePicker.willRemoveSubview(toolBar)
        datePicker.isHidden = true
        self.toolBar.isHidden = true
    }

    @objc func cancelClick() {
        datePicker.isHidden = true
        self.toolBar.isHidden = true

    }

    
    func didSelect(image: UIImage?) {
        
        if (image?.pngData()) != nil{
            self.ImageView.image = image
            isNewImageSelected = true
        }
        
    }
//    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
//        let storageRef = FIRStorage.storage().reference().child("myImage.png")
//        if let uploadData = UIImagePNGRepresentation(self.myImageView.image!) {
//            storageRef.put(uploadData, metadata: nil) { (metadata, error) in
//                if error != nil {
//                    print("error")
//                    completion(nil)
//                } else {
//                    completion((metadata?.downloadURL()?.absoluteString)!))
//                    // your uploaded photo url.
//                }
//           }
//     }
//
    
//fetch  user
    func fetchUser() {

        self.userReff.child(constantStrings.fireProfile).observe(.childAdded, with: {(snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject] {
                print(dictionary["snap"] as Any)
                let user = UserDetails.parse(dict: dictionary)
                user.firstname = dictionary["firstname"] as? String
                self.arrUserDetails.append(user)// .append(user)
                self.tblUserList.reloadData()
            }
        } , withCancel: nil)
    }
//add new user
    func SaveToFire(_ UserDict: [String:String]){
        self.userReff.child(constantStrings.fireProfile).childByAutoId().setValue(UserDict)
    }
//delete user
    func deleteUser(withID: String){
        let ref = self.userReff.child(constantStrings.fireProfile).child(withID)
        ref.removeValue()
    }
    @IBAction func onTapImage(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func onClickSaveUser(_ sender: Any) {
        
        if txtFname.text == "" || txtLname.text == "" || txtDOB.text == "" || txtGender.text == "" || txtCountry.text == "" || txtSatate.text == "" || txtHomeTown.text == "" || txtPhoneNo.text == "" || txtTelephoneNo.text == "" {
            
        }else {

            let firstname = self.txtFname.text! as String
            let lastname = self.txtLname.text! as String
            let birth_date = self.txtDOB.text! as String
            let gender = self.txtGender.text! as String
            let country = self.txtCountry.text! as String
            let state = self.txtSatate.text! as String
            let homeTown = self.txtHomeTown.text! as String
            let phone_no = self.txtPhoneNo.text! as String
            let telephone_no = self.txtTelephoneNo.text! as String
            let profileDict = ["firstname" : firstname,
                               "lastname" : lastname,
                               "birth_date" : birth_date,
                               "gender": gender,
                               "country" : country,
                               "state" : state,
                               "homeTown": homeTown,
                               "phone_no": phone_no,
                               "telephone_no": telephone_no]
            print(profileDict)
            SaveToFire(profileDict)

            self.txtFname.text = nil
            self.txtLname.text = nil
            self.txtDOB.text = nil
            self.txtGender.text = nil
            self.txtCountry.text = nil
            self.txtSatate.text = nil
            self.txtHomeTown.text = nil
            self.txtPhoneNo.text = nil
            self.txtTelephoneNo.text = nil
            
            mainSegmentBar.selectedSegmentIndex = 0
            viewEnroll.isHidden = true

        }
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            viewEnroll.isHidden = true
            lineViewUser.backgroundColor = .cyan
            lineViewEnroll.backgroundColor = .clear
        }else{
            viewEnroll.isHidden = false
            lineViewUser.backgroundColor = .clear
            lineViewEnroll.backgroundColor = .cyan
            
        }
    }
}

extension ViewController {
    func setupView(){
        mainSegmentBar.addUnderlineForSelectedSegment()
        mainSegmentBar.selectedSegmentIndex = 0
        lineViewUser.backgroundColor = .cyan
        lineViewEnroll.backgroundColor = .clear
        viewEnroll.isHidden = true
        mainSegmentBar.apportionsSegmentWidthsByContent = true
        view.backgroundColor = .white
        ImageView.contentMode = .scaleAspectFill
        
        imageContainerView.layer.cornerRadius = 6
        imageContainerView.layer.masksToBounds = true
        imageContainerView.layer.borderWidth = 1
        imageContainerView.layer.borderColor = UIColor.darkGray.cgColor
        
        txtFname.setAppTxtField("First Name")
        txtLname.setAppTxtField("Last Name")
        txtDOB.setAppTxtField("Date Of Birth")
        txtGender.setAppTxtField("Gender")
        txtCountry.setAppTxtField("Country")
        txtSatate.setAppTxtField("State")
        txtHomeTown.setAppTxtField("Home Town")
        txtPhoneNo.setAppTxtField("Phone No.")
        txtTelephoneNo.setAppTxtField("Telephone No.")
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblUserList.dequeueReusableCell(withIdentifier: "userCell") as! userCell
        let objc = arrUserDetails[indexPath.row]
        let fname = objc.firstname ?? ""
        let lname = objc.lastname ?? ""
        cell.lblUserFullName.text = fname + " " + lname
        let gender = objc.gender ?? ""
        let contry = objc.country ?? ""
        let bdate = objc.birth_date ?? ""
        var age = ""
        if bdate != "" {
            age = "\(bdate.calcAge())"
        }
        cell.lblUserInfo.text =  gender + " | " + age + " | " + contry
        cell.imgUserPhoto.setImageRounded()
        cell.imgUserPhoto.contentMode = .scaleToFill
        cell.imgUserPhoto.image = UIImage(named: "desert")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

class userCell: UITableViewCell {
    
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBOutlet weak var lblUserFullName: UILabel!
    @IBOutlet weak var lblUserInfo: UILabel!
    @IBOutlet weak var btnDeleteUser: UIButton!
    
}
/*
 func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
     let storageRef = FIRStorage.storage().reference().child("myImage.png")
     if let uploadData = UIImagePNGRepresentation(self.myImageView.image!) {
         storageRef.put(uploadData, metadata: nil) { (metadata, error) in
             if error != nil {
                 print("error")
                 completion(nil)
             } else {
                 completion((metadata?.downloadURL()?.absoluteString)!))
                 // your uploaded photo url.
             }
        }
  }
 */
