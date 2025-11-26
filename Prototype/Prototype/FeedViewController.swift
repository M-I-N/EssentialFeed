//
//  FeedViewController.swift
//  Prototype
//
//  Created by Nayem, Mufakkharul | Nil | GSSD on 2025/11/26.
//

import UIKit

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let imageName: String
}

class FeedViewController: UITableViewController {
    private let feed = FeedImageViewModel.prototypeFeed
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath) as! FeedImageCell
        let model = feed[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
}

extension FeedImageCell {
    func configure(with model: FeedImageViewModel) {
        locationLabel.text = model.location
        locationContainer.isHidden = model.location == nil
        
        descriptionlabel.text = model.description
        descriptionlabel.isHidden = model.description == nil
        
        feedImageView.image = UIImage(named: model.imageName)
    }
}
