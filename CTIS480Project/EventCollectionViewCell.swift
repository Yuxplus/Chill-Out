//
//  EventCollectionViewCell.swift
//  CTIS480Project
//
//  Created by Mert Ekin & Yusuf Özcan on 18.05.2024.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func configure(with event: EventsData) {
        titleLabel.text = event.title
        typeLabel.text = "\(event.type ?? "Unknown")"
        let imageName = event.type! + ".jpg"
        imageView.image = UIImage(named: imageName.lowercased())
        
        if let eventDate = event.time {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            timeLabel.text = "\(dateFormatter.string(from: eventDate))"
        } else {
            timeLabel.text = "Time: Unknown"
        }
        locationLabel.text = "\(event.location ?? "Unknown")"
    }
}
