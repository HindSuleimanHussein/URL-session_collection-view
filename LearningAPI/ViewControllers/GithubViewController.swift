//
//  GithubViewController.swift
//  LearningAPI
//
//  Created by Foothill on 09/11/2023.
//

import UIKit

class GithubViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var warningUserLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUsernameTextField()
    }
    
    private func configureUsernameTextField(){
        usernameTextField.layer.cornerRadius = 20
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: usernameTextField.frame.height))
        usernameTextField.leftView = paddingView
        usernameTextField.leftViewMode = .always
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else {
            warningUserLabel.text = Constants.Labels.warningUserLabel
                return
            }
        performSegue(withIdentifier: Constants.IdentifiersForSegue.toUserProfileViewController, sender: username)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.IdentifiersForSegue.toUserProfileViewController {
            if let userProfileVC = segue.destination as? UserProfileViewController {
                if let username = sender as? String {
                    userProfileVC.username = username
                }
            }
        }
    }
}
