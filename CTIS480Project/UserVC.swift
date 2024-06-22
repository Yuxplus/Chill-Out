//
//  UserVC.swift
//  CTIS480Project
//
//  Created by Mert Ekin & Yusuf Özcan on 18.05.2024.
//



import UIKit
import CoreData

class UserVC: UIViewController {

    @IBOutlet weak var guestButton: UIButton!
    @IBOutlet weak var organizerButton: UIButton!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardView2: UIView!
    
    @IBOutlet weak var organizerImage: UIImageView!
    @IBOutlet weak var guestImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // IBOutlet'ların nil olup olmadığını kontrol et
        if guestImage == nil {
            print("Error: guestImage IBOutlet is not connected.")
        } else {
            print("guestImage IBOutlet is connected.")
        }
        if organizerImage == nil {
            print("Error: organizerImage IBOutlet is not connected.")
        } else {
            print("organizerImage IBOutlet is connected.")
        }
        
        // RGB değerlerini kullanarak UIColor oluştur
        let backgroundColor = UIColor(red: 0/255.0, green: 33/255.0, blue: 77/255.0, alpha: 1.0)
        
        // View'in arka plan rengini ayarla
        self.view.backgroundColor = backgroundColor
        
        // Görüntüleri yüklemeyi kontrol et
        if let guestImg = UIImage(named: "guest") {
            guestImage.image = guestImg
        } else {
            print("Error: guest image not found in assets.")
        }
        
        if let organizerImg = UIImage(named: "organizator") {
            organizerImage.image = organizerImg
        } else {
            print("Error: organizer image not found in assets.")
        }

        // Kartlar için gradient arka plan ayarla
        setupCardView()
        
        // Load JSON data and add to Core Data if necessary
        //loadJsonAndAddToCoreDataIfNeeded()
    }
   
    func setupCardView() {
        // 1. CardView için gradient ayarları
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.frame = cardView.bounds
        gradientLayer1.colors = [
            UIColor(red: 255/255.0, green: 87/255.0, blue: 64/255.0, alpha: 1.0).cgColor,
            UIColor(red: 110/255.0, green: 42/255.0, blue: 245/255.0, alpha: 1.0).cgColor
        ]
        gradientLayer1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer1.cornerRadius = 10 // Gradient layer için köşe yuvarlama
        
        cardView.layer.insertSublayer(gradientLayer1, at: 0)
        
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true // Köşe yuvarlaması gradient için de geçerli olacak
        
        // Gölge ayarları
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.layer.masksToBounds = false // Gölge için maske kaldırıldı
        
        // Sınır (border) ayarları
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.white.cgColor
        
        // 2. CardView2 için gradient ayarları
        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.frame = cardView2.bounds
        gradientLayer2.colors = [
            UIColor(red: 255/255.0, green: 87/255.0, blue: 64/255.0, alpha: 1.0).cgColor,
            UIColor(red: 110/255.0, green: 42/255.0, blue: 245/255.0, alpha: 1.0).cgColor
        ]
        gradientLayer2.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer2.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer2.cornerRadius = 10 // Gradient layer için köşe yuvarlama
        
        cardView2.layer.insertSublayer(gradientLayer2, at: 0)
        
        cardView2.layer.cornerRadius = 10
        cardView2.layer.masksToBounds = true // Köşe yuvarlaması gradient için de geçerli olacak
        
        // Gölge ayarları
        cardView2.layer.shadowColor = UIColor.black.cgColor
        cardView2.layer.shadowOpacity = 0.2
        cardView2.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView2.layer.shadowRadius = 4
        cardView2.layer.masksToBounds = false // Gölge için maske kaldırıldı
        
        // Sınır (border) ayarları
        cardView2.layer.borderWidth = 1
        cardView2.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientFrames()
    }
    
    func updateGradientFrames() {
        if let gradientLayer1 = cardView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer1.frame = cardView.bounds
        }
        if let gradientLayer2 = cardView2.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer2.frame = cardView2.bounds
        }
    }
    
    
}
