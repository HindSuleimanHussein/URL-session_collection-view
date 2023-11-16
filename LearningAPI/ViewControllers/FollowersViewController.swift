//
//  FollowersViewController.swift
//  LearningAPI
//
//  Created by Foothill on 15/11/2023.
//

import UIKit

class FollowersViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var followerCollectionView: UICollectionView!
    
    public var followersData: [FollowerModel] = []
    private var filteredFollowers: [FollowerModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        print(followersData)
    }
    
    private func setupCollectionView() {
        followerCollectionView.delegate = self
        followerCollectionView.dataSource = self
        searchBar.delegate = self
        followerCollectionView.reloadData()
    }
    
    @IBAction func barButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension FollowersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchBar.text?.isEmpty == false ? filteredFollowers.count : followersData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionView.FollowerCell, for: indexPath) as! FollowerCollectionViewCell
        let follower = searchBar.text?.isEmpty == false ? filteredFollowers[indexPath.item] : followersData[indexPath.item]
        cell.configure(with: follower)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.2, height: self.view.frame.width * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Filter followersData based on the search text
        filteredFollowers = followersData.filter { follower in
            return follower.login.lowercased().contains(searchText.lowercased())
        }
        followerCollectionView.reloadData()
    }
}
