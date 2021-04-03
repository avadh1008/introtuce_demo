//
//  AppExtensions.swift
//  AvadhDemoProject
//
//  Created by Avadh Mevada on 16/03/21.
//
//
import Foundation
import UIKit

struct constantStrings{
    static let fireProfile = "profile"
}

extension UISegmentedControl {
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.cyan], for: .selected)
    }

    func addUnderlineForSelectedSegment(){
        removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}

extension UIImage {

    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
    
    
}
extension UIImageView {
    
    func setImageRounded(){
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
    }
}
extension UITextField {
    func setAppTxtField(_ Placeholder: String){
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemTeal.cgColor
        self.placeholder = Placeholder
    }
}
class UserDetails {
    
    var firstname: String?
    var lastname: String?
    var birth_date: String?
    var gender: String?
    var country: String?
    var state: String?
    var homeTown: String?
    var phone_no: String?
    var telephone_no: String?

    init() {
    }
    
    init(
     firstname: String?,
     lastname: String?,
     birth_date: String?,
     gender: String?,
     country: String?,
     state: String?,
     homeTown: String?,
     phone_no: String?,
     telephone_no: String?
    ) {
        
        self.firstname = firstname
        self.lastname = lastname
        self.birth_date = birth_date
        self.gender = gender
        self.country = country
        self.state = state
        self.homeTown = homeTown
        self.phone_no = phone_no
        self.telephone_no = telephone_no
        
    }
    
    class func parse(arrDict: [[String:AnyObject]]) -> [UserDetails] {
        var arrUserDetails:[UserDetails] = []
        
        for dict in arrDict {
            arrUserDetails.append(UserDetails.parse(dict: dict))
        }
        return arrUserDetails
    }
    
    class func parse(dict: [String:AnyObject]) -> UserDetails {
        let objUserDetails = UserDetails.init()
        objUserDetails.firstname = dict["firstname"] as? String
        objUserDetails.lastname = dict["lastname"] as? String
        objUserDetails.birth_date = dict["birth_date"] as? String
        objUserDetails.gender = dict["gender"] as? String
        objUserDetails.country = dict["country"] as? String
        objUserDetails.state = dict["state"] as? String
        objUserDetails.homeTown = dict["homeTown"] as? String
        objUserDetails.phone_no = dict["phone_no"] as? String
        objUserDetails.telephone_no = dict["telephone_no"] as? String
        
        return objUserDetails
    }
}
extension String {
    func calcAge() -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yyyy"
        let birthdayDate = dateFormater.date(from: self)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
}
