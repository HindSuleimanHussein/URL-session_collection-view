//
//  FollowerCollectionViewCell.swift
//  LearningAPI
//
//  Created by Foothill on 15/11/2023.
//

import UIKit

class FollowerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var followerImageView: UIImageView!
    @IBOutlet private weak var followerUsername: UILabel!
    static var id = Constants.CollectionView.FollowerCell
    
    public func configure(with follower: FollowerModel) {
        followerUsername.text = follower.login
        
        // Fetch and display follower's avatar asynchronously
        if let avatarURL = URL(string: follower.avatar_url) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: avatarURL) {
                    DispatchQueue.main.async {
                        self.followerImageView.image = UIImage(data: data)
                        self.configureImage()
                    }
                }
            }
        }
    }
    
    private func configureImage(){
        self.followerImageView.contentMode = .scaleAspectFill
        self.followerImageView.layer.cornerRadius = self.followerImageView.frame.width / 2
        self.followerImageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset cell UI when being reused
        followerImageView.image = nil
        followerUsername.text = nil
    }
}
