//
//  CollectionViewCell.swift
//  biblioTec
//
//  Created by Ricardo Ramirez on 8/25/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pisoLabel: UILabel!
    
    @IBOutlet weak var viewZona1: UIView!
    @IBOutlet weak var viewZona2: UIView!
    @IBOutlet weak var viewZona3: UIView!
    @IBOutlet weak var viewZona4: UIView!
    
    @IBOutlet weak var labelZona1: UILabel!
    @IBOutlet weak var labelZona2: UILabel!
    @IBOutlet weak var labelZona3: UILabel!
    @IBOutlet weak var labelZona4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        viewZona1.layer.borderWidth = 1
        viewZona2.layer.borderWidth = 1
        viewZona3.layer.borderWidth = 1
        viewZona4.layer.borderWidth = 1
    }
    func bind(color: String) {
        contentView.backgroundColor = color.hexColor
    }
}
extension String {
    var hexColor: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
class ImageCollectionViewController: UICollectionViewController {
    
    @IBOutlet var dismissGesture: UISwipeGestureRecognizer!
    
    var animator2: (LayoutAttributesAnimator, Bool, Int, Int) = (ZoomInOutAttributesAnimator(), true, 1, 1)
    var direction: UICollectionViewScrollDirection = .vertical
    
    let cellIdentifier = "CollectionViewCell"
    let vcs = [("f44336"),
               ("9c27b0"),
               ("3f51b5"),
               ("03a9f4"),
               ("009688")]
	
	var zones: [Int] = [20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.isPagingEnabled = true
		
//		ReservationService.countReservations { (arr) in
//			self.zones = arr
//			//print(self.zones)
//			self.collectionView?.reloadData()
//		}
        if let layout = collectionView?.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.scrollDirection = direction
            layout.animator = animator2.0
        }
        dismissGesture.direction = .right
        
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		ReservationService.countReservations { (arr) in
			self.zones = arr
			self.collectionView?.reloadData()
		}
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSwipeDown(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override var prefersStatusBarHidden: Bool { return true }
    
}

extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let cell = c as? CollectionViewCell {
            let i = indexPath.row % vcs.count
            let v = vcs[i]
            cell.bind(color: v)
			cell.labelZona1.text = String(zones[indexPath.row])
			cell.labelZona2.text = String(zones[indexPath.row+1])
			cell.labelZona3.text = String(zones[indexPath.row+2])
			cell.labelZona4.text = String(zones[indexPath.row+3])
            cell.clipsToBounds = animator2.1
            cell.pisoLabel.text = "Piso \(String(indexPath.row+2))"
        }
        
        return c
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        _ = animator2
        return CGSize(width: view.bounds.width / CGFloat(animator2.2), height: view.bounds.height / CGFloat(animator2.3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
