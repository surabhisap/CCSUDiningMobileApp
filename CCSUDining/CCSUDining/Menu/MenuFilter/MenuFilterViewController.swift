//
//  MenuFilterViewController.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 4/2/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit

class MenuFilterViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let dishesOptionArray = ["Vegan", "Vegitarian", "Mindful"]
    private let allergensOptionArray = ["Milk", "Eggs", "Gluten", "Soybean", "Wheat"]
    private var headerview: MenuFilterCustomHeaderCell?
    private var selectionDictionary = [String: Any]()
    var closure : (([String: Any]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.allowsMultipleSelection = true
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        
        dismiss(animated: true) { [weak self] in
            self?.closure?(self?.selectionDictionary ?? [String: Any]())
        }
    }
    
    private func configureCollectionView() {
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            let width = collectionView.frame.width
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
            layout.itemSize = CGSize(width: width / 3, height: width / 3)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 10
        }
        
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began: break
            // handle drag began
            case .moved:
                // handle drag moved
                let sliderValue = Int64(slider.value * 1000)
                headerview?.titleLabel.text = "Max. calories: \(sliderValue)"
                
            case .ended:
                // handle drag ended
                let sliderValue = Int64(slider.value * 1000)
                selectionDictionary["maxCalories"] = sliderValue
            default:
                break
            }
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension MenuFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize.zero : CGSize(width: collectionView.frame.width, height: collectionView.frame.width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as? MenuFilterCustomHeaderCell else {
                return UICollectionReusableView()
            }
            
            cell.slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
            cell.slider.value = 0.60
            headerview = cell
            return cell
        }
        
        return UICollectionReusableView()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? dishesOptionArray.count : allergensOptionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as? MenuFilterCell else {
            return UICollectionViewCell()
        }
        
        let filterValue = indexPath.section == 0 ? dishesOptionArray[indexPath.row] : allergensOptionArray[indexPath.row]
        filterCell.filterTitle.text = filterValue
        filterCell.filterImage.image = UIImage(named: filterValue)
        return filterCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let filterCell = collectionView.cellForItem(at: indexPath) as? MenuFilterCell else {
            return
        }
        
        filterCell.layer.borderWidth = 2
        filterCell.layer.borderColor = UIColor.white.cgColor
        let filterIdentifier = indexPath.section == 0 ? "dishes" : "allergens"
        
        if var filterArray = selectionDictionary[filterIdentifier] as? [String] {
            guard let filterText = filterCell.filterTitle.text else { return }
            filterArray = filterArray + [filterText]
            selectionDictionary[filterIdentifier] = filterArray
            
        } else {
            guard let filterText = filterCell.filterTitle.text else { return }
            selectionDictionary[filterIdentifier] = [filterText]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let filterCell = collectionView.cellForItem(at: indexPath) as? MenuFilterCell else {
            return
        }
        
        filterCell.layer.borderColor = UIColor.clear.cgColor
        let filterIdentifier = indexPath.section == 0 ? "dishes" : "allergens"
        
        if var filterArray = selectionDictionary[filterIdentifier] as? [String] {
            guard let filterText = filterCell.filterTitle.text else { return }
            
            if let index = filterArray.index(of: filterText) {
                filterArray.remove(at: index)
                selectionDictionary[filterIdentifier] = filterArray
            }
            
        }
    }
    
}

extension MenuFilterViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width - 20
        return CGSize(width: collectionViewWidth/3, height: collectionViewWidth/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
