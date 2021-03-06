import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    var api42 = API42AccessRequest()
    var student = Student()
    @IBOutlet weak var studentLogin: UITextField!
    
    @IBAction func searchStudent(_ sender: UIButton) {
        if studentLogin.text != "" {
            api42.checkStudent(studentName: studentLogin.text!) {
                returnJSON in
                if let json = returnJSON as? NSDictionary {
                    self.student = GetUserInformation.getStudent(userJson: json)
                    if self.student.projects.count > 1 {
                        self.api42.getCoalition(studentId: self.student.getId()) {
                            returnJSON in
                            if let coalitionData = returnJSON as? [[String:Any]]  {
                                self.student.setCoalitionName(coalitionName: GetUserInformation.getCoalitionName(coalitionData: coalitionData))
                                self.student.setCoalitionUrl(coalitionUrl: GetUserInformation.getCoalitionUrl(coalitionData: coalitionData))
                                let displayVC : StudentProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StudentProfileView") as! StudentProfileViewController
                                displayVC.student = self.student
                                self.navigationController?.pushViewController(displayVC, animated: true)
                            }
                        }
                    }
                    else {
                        self.studentError()
                    }
                }
                else {
                    self.studentError()
                }
            }
        }
    }
    
    func studentError() {
        let alert = UIAlertController(title: "Error", message: "No such student", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundImage.png")!)
        self.studentLogin.placeholder = "Enter student login"
        
        api42.getToken()
    }
}
