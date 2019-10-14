//
//  LoginViewController.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/29.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin
import KeychainAccess

class LoginViewController: UIViewController {
    
    let userFacebookLogin = UserFacebookLogin()

    @IBOutlet weak var mainView: UIView!

    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func facebookLogin(_ sender: UIButton) {
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: [.email, .publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                self.view.makeToast(NSLocalizedString("LoginFailed", comment: ""), duration: 1.0, position: .center)
            case .cancelled:
                self.view.makeToast(NSLocalizedString("LoginCancelled", comment: ""), duration: 1.0, position: .center)
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print(grantedPermissions)
                print(declinedPermissions)
                print(accessToken.tokenString)
                self.userFacebookLogin.postFacebookToken(accessToken: accessToken.tokenString)
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keychain = Keychain(service: "com.littlema.STYLiSH")
        
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 20
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        userFacebookLogin.dataPassHelper.handler = { result in
            if result.data != nil {
                self.view.makeToast(NSLocalizedString("LoginSuccessed", comment: ""), duration: 1.0, position: .center)
                
                keychain["stylishToken"] = result.data?.accessToken
            } else if result.error != nil {
                self.view.makeToast(NSLocalizedString("LoginFailed", comment: ""), duration: 1.0, position: .center)
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
