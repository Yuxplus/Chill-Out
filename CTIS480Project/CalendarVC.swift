//
//  CalendarVC.swift
//  CTIS480Project
//
//  Created by Mert Ekin & Yusuf Özcan on 18.05.2024.
//

import UIKit

class CalendarVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!
    var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var currentMonthDays = [String]()
    var currentMonth: Int = 0
    var currentYear: Int = 0
    var monthLabel: UILabel!
    
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Arka plan rengini ayarla
        let backgroundColor = UIColor(red: 0/255.0, green: 33/255.0, blue: 77/255.0, alpha: 1.0)
        self.view.backgroundColor = backgroundColor
        
        // Ay adı için label ekle
        monthLabel = UILabel()
        monthLabel.textAlignment = .center
        monthLabel.font = UIFont.systemFont(ofSize: 24)
        monthLabel.textColor = .white
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(monthLabel)
        
        // İleri ve geri butonları ekle
        let previousButton = UIButton(type: .system)
        previousButton.setTitle("←", for: .normal)
        previousButton.setTitleColor(.white, for: .normal)
        previousButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        previousButton.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(previousButton)
        
        let nextButton = UIButton(type: .system)
        nextButton.setTitle("→", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        nextButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(nextButton)
        
        // Koleksiyon görünümü düzeni oluştur
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.clear
        
        self.view.addSubview(collectionView)
        
        // Yerleşim kısıtlamaları
        monthLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        monthLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        previousButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor).isActive = true
        previousButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        
        nextButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 20).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        // Mevcut ay ve yıl bilgilerini al
        let date = Date()
        let components = calendar.dateComponents([.year, .month], from: date)
        currentYear = components.year!
        currentMonth = components.month!
        
        // Günleri ayarla ve koleksiyon görünümünü yeniden yükle
        setupDays()
    }
    
    @objc func previousMonth() {
        currentMonth -= 1
        if currentMonth < 1 {
            currentMonth = 12
            currentYear -= 1
        }
        setupDays()
    }
    
    @objc func nextMonth() {
        currentMonth += 1
        if currentMonth > 12 {
            currentMonth = 1
            currentYear += 1
        }
        setupDays()
    }
    
    func setupDays() {
        currentMonthDays.removeAll()
        
        // Ay adı ve yıl bilgisini güncelle
        let date = calendar.date(from: DateComponents(year: currentYear, month: currentMonth))!
        dateFormatter.dateFormat = "MMMM yyyy"
        monthLabel.text = dateFormatter.string(from: date)
        
        // Ayın ilk günü
        let firstDayOfMonth = calendar.date(from: DateComponents(year: currentYear, month: currentMonth))!
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        let numDays = range.count
        
        // İlk gün haftanın hangi günü olduğunu bul
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // Boş hücreler ekle
        for _ in 1..<firstWeekday {
            currentMonthDays.append("")
        }
        
        // Günleri ekle
        for day in 1...numDays {
            currentMonthDays.append("\(day)")
        }
        
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return days.count
        } else {
            return currentMonthDays.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCell
        if indexPath.section == 0 {
            cell.label.text = days[indexPath.row]
        } else {
            cell.label.text = currentMonthDays[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        return CGSize(width: width, height: width)
    }
}
