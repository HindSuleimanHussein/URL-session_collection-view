//  UserProfileViewController.swift
//  LearningAPI
//
//  Created by Foothill on 10/11/2023.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet private weak var userProfileImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var userBioTextView: UITextView!
    @IBOutlet private weak var userFollowersLabel: UILabel!
    
    public var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Username in UserProfileViewController: \(username ?? "nil")")
        configureUserProfileImageView()
        fetchUserData()
    }
    
    private func configureUserProfileImageView() {
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        userProfileImageView.layer.masksToBounds = true
    }
    
    private func fetchUserData(){
        guard let username = username else { return }
        
        let apiUrl = "https://api.github.com/users/\(username)"
        
        if let url = URL(string: apiUrl){
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let user = try decoder.decode(UserModel.self, from: data)
                        
                        DispatchQueue.main.async {
                            self.configureUIUser(user)
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
    
    private func configureUIUser(_ user: UserModel) {
        usernameLabel.text = user.name ?? Constants.ReplaceableVariables.noName
        userBioTextView.text = user.bio ?? Constants.ReplaceableVariables.noBio
        userFollowersLabel.text = "\(user.name ?? "Unknown User") has \(user.followers ?? 0) followers"
        fetchImage(user)
    }
    
    private func fetchImage(_ user: UserModel){
        if let avatarURLString = user.avatar_url, let avatarURL = URL(string: avatarURLString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: avatarURL) {
                    DispatchQueue.main.async {
                        self.userProfileImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.IdentifiersForSegue.toFollowersViewController {
            if let followersVC = segue.destination as? FollowersViewController,
               let followers = sender as? [FollowerModel] {
                followersVC.followersData = followers
            }
        }
    }

    
    @IBAction func followersButtonTapped(_ sender: Any) {
        guard let username = username else { return }

        let followersApiUrl = "https://api.github.com/users/\(username)/followers"
        
        if let url = URL(string: followersApiUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let followers = try decoder.decode([FollowerModel].self, from: data)
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: Constants.IdentifiersForSegue.toFollowersViewController, sender: followers)
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
}
