//
//  LoginSubViewController.swift
//  SocialHub
//
//  Created by KiKan Ng on 24/1/2017.
//
//

import UIKit
import Firebase
import FirebaseAuth

class LoginSubViewController: UIViewController {
    
    let inputsContainerView = UIView()
    let loginRegisterButton = UIButton(type: .System)
    
    var inputsConstrainrViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor : NSLayoutConstraint?
    var emailTextFieldHeightAnchor : NSLayoutConstraint?
    var passwordTextFieldHeightAnchor : NSLayoutConstraint?
    
    let nameSeperatorView = UIView()
    let nameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginInSegmentedControl = UISegmentedControl(items: ["Login", "Sign Up"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        // UIView
        inputsContainerView.backgroundColor = UIColor.whiteColor()
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputsContainerView.layer.cornerRadius = 5
        inputsContainerView.layer.masksToBounds = true
        
        view.addSubview(inputsContainerView)
        
        // Constraint
        inputsContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputsContainerView.topAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -40).active = true
        inputsContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
        inputsConstrainrViewHeightAnchor = inputsContainerView.heightAnchor.constraintEqualToConstant(100)
        inputsConstrainrViewHeightAnchor?.active = true
        
        // UIButton
        loginRegisterButton.backgroundColor = UIColor.purpleColor()
        loginRegisterButton.setTitle("Login", forState: .Normal)
        loginRegisterButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginRegisterButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        loginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterButton.layer.cornerRadius = 5
        loginRegisterButton.layer.masksToBounds = true
        loginRegisterButton.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
        
        view.addSubview(loginRegisterButton)
        
        // Constraint
        loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterButton.centerYAnchor.constraintEqualToAnchor(inputsContainerView.bottomAnchor, constant: 48).active = true
        loginRegisterButton.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        loginRegisterButton.heightAnchor.constraintEqualToConstant(50).active = true
        
        // profile pic
        let imageVIew = UIImageView()
        imageVIew.image = UIImage(named: "icon")
        imageVIew.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageVIew)
        
        // Constraint
        imageVIew.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: -90).active = true
        imageVIew.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -80).active = true
        imageVIew.widthAnchor.constraintEqualToConstant(75).active = true
        imageVIew.heightAnchor.constraintEqualToConstant(75).active = true
        
        // UILabel
        let name = UILabel()
        name.text = "SocialHub"
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.boldSystemFontOfSize(36)
        name.textColor = UIColor.purpleColor()
        view.addSubview(name)
        
        name.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 40).active = true
        name.centerYAnchor.constraintEqualToAnchor(imageVIew.centerYAnchor).active = true
        name.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -20).active = true
        
        // Segmented Control
        loginInSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        loginInSegmentedControl.tintColor = UIColor.purpleColor()
        loginInSegmentedControl.selectedSegmentIndex = 0
        loginInSegmentedControl.addTarget(self, action: #selector(handleLoginResgisterChange), forControlEvents: .ValueChanged)
        view.addSubview(loginInSegmentedControl)
        
        loginInSegmentedControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginInSegmentedControl.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -12).active = true
        loginInSegmentedControl.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        loginInSegmentedControl.heightAnchor.constraintEqualToConstant(30).active = true
        
        
        // Textfield
        nameTextField.placeholder = "Name"
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameTextField)
        
        nameTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        nameTextField.topAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor).active = true
        nameTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 0)
        nameTextFieldHeightAnchor?.active = true
        
        // Name Seperator
        nameSeperatorView.hidden = true
        nameSeperatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        nameSeperatorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameSeperatorView)
        
        nameSeperatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        nameSeperatorView.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        nameSeperatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        nameSeperatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        // Textfield
        emailTextField.placeholder = "Email"
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emailTextField)
        
        emailTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        emailTextField.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        emailTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/2)
        emailTextFieldHeightAnchor?.active = true
        
        // Name Seperator
        let emailSeperatorView = UIView()
        emailSeperatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        emailSeperatorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emailSeperatorView)
        
        emailSeperatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        emailSeperatorView.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        emailSeperatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        emailSeperatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        // Textfield
        passwordTextField.placeholder = "Password"
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.secureTextEntry = true
        
        view.addSubview(passwordTextField)
        
        passwordTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        passwordTextField.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        passwordTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/2)
        passwordTextFieldHeightAnchor?.active = true
        
        // Name Seperator
        let passwordSeperatorView = UIView()
        passwordSeperatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        passwordSeperatorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(passwordSeperatorView)
        
        passwordSeperatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        passwordSeperatorView.topAnchor.constraintEqualToAnchor(passwordTextField.bottomAnchor).active = true
        passwordSeperatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        passwordSeperatorView.heightAnchor.constraintEqualToConstant(1).active = true
    }
    
    func handleLoginRegister() {
        if loginInSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleResgister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                return
            }
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.login_logout()
        })
        
    }
    
    func handleResgister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error)
                return
            }
        
            guard let uid = user?.uid else { return }
            
            // success
            let ref = FIRDatabase.database().reference().child("users").child(uid)
            let value = ["name": name, "password": password]
            ref.updateChildValues(value, withCompletionBlock: {
                (err, ref) in
                
                if err != nil {
                    print(err)
                    return
                }
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login_logout()
            })
        })
    }
    
    func handleLoginResgisterChange() {
        let title = loginInSegmentedControl.titleForSegmentAtIndex(loginInSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, forState: .Normal)
        
        // change height
        inputsConstrainrViewHeightAnchor?.constant = loginInSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldHeightAnchor?.active = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginInSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.active = true
        
        emailTextFieldHeightAnchor?.active = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginInSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.active = true
        
        passwordTextFieldHeightAnchor?.active = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginInSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.active = true
        
        nameSeperatorView.hidden = loginInSegmentedControl.selectedSegmentIndex == 0 ? true : false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 0.9)
    }
}
