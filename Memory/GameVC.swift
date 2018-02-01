//
//  GameVC.swift
//  Memory
//
//  Created by Ganna Melnyk on 1/29/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//

import UIKit

class GameVC: UIViewController {
    var cellsAmount = 4
    var userName = ""
    var pictures: [UIImage] = []
    var selectedIndexies: [IndexPath] = []
    var alreadySeenIndexies: [IndexPath] = []
    var timer: Timer?
    let penalty = 2
    let timePenalty = 2.0
    var cellsCounter = 4
    let cellForRowAndCollomn: [Int: [Int]] = [4: [2,2], 8: [2,4], 12: [3,4], 16: [4,4], 20: [4,5], 24: [4,6], 28: [4,7], 32: [4,8], 36: [6,6], 40: [5,8], 44: [4,11], 48: [6,8], 52: [4,13], 56: [7,8]]
    var score:Int = 0 {
        didSet{
            navigationItem.title = "\(score)"
        }
    }
    
    @IBOutlet weak var barView: UIToolbar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
        navigationItem.title = "\(score)"
    }
    
    @objc func updateTimer() {
        score += 1
    }
    
    func newGame() {
        pictures = [#imageLiteral(resourceName: "027-avocado"), #imageLiteral(resourceName: "014-pitaya"), #imageLiteral(resourceName: "028-radishes"), #imageLiteral(resourceName: "032-cherry"), #imageLiteral(resourceName: "015-pomegranate"), #imageLiteral(resourceName: "005-mangosteen"), #imageLiteral(resourceName: "035-olives"), #imageLiteral(resourceName: "017-peas"), #imageLiteral(resourceName: "038-artichoke"), #imageLiteral(resourceName: "008-pumpkin"), #imageLiteral(resourceName: "046-peach"), #imageLiteral(resourceName: "037-mushroom"), #imageLiteral(resourceName: "012-carambola"), #imageLiteral(resourceName: "045-orange"), #imageLiteral(resourceName: "040-papaya"), #imageLiteral(resourceName: "025-grapes"), #imageLiteral(resourceName: "050-garlic"), #imageLiteral(resourceName: "024-strawberry"), #imageLiteral(resourceName: "049-watermelon"), #imageLiteral(resourceName: "034-blueberries"), #imageLiteral(resourceName: "047-chili"), #imageLiteral(resourceName: "003-corn"), #imageLiteral(resourceName: "016-melon"), #imageLiteral(resourceName: "004-pear"), #imageLiteral(resourceName: "022-peanut"), #imageLiteral(resourceName: "042-cabbage"), #imageLiteral(resourceName: "001-tomato"), #imageLiteral(resourceName: "002-lettuce"), #imageLiteral(resourceName: "009-mango"), #imageLiteral(resourceName: "011-coconut"), #imageLiteral(resourceName: "020-cauliflower"), #imageLiteral(resourceName: "044-courgette"), #imageLiteral(resourceName: "039-carrot"), #imageLiteral(resourceName: "043-lemon")]
        initialShuffler()
        pairsShuffler()
        selectedIndexies.removeAll()
        cellsCounter = cellsAmount
        alreadySeenIndexies.removeAll()
        score = 0
        collectionView.reloadData()
        setPause()
    }

    func initialShuffler() {
        var unShuffledArray = pictures
        pictures.removeAll()
        while !unShuffledArray.isEmpty {
            let randomIndex = Int(arc4random_uniform(UInt32(unShuffledArray.count - 1)))
            let picture = unShuffledArray.remove(at: randomIndex)
            pictures.append(picture)
        }
    }
    
    func pairsShuffler() {
        var unShuffledArray = pictures
        pictures.removeAll()
        var pairedPictures:[UIImage] = []
        for index in 0 ..< cellsAmount/2 {
            pairedPictures.append(unShuffledArray[index])
            pairedPictures.append(unShuffledArray[index])
        }
        while !pairedPictures.isEmpty {
            let randomIndex = Int(arc4random_uniform(UInt32(pairedPictures.count - 1)))
            let picture = pairedPictures.remove(at: randomIndex)
            pictures.append(picture)
        }
    }
    
    @IBAction func pause(_ sender: UIBarButtonItem) {
        setPause()
    }
    
    func setPause() {
        if !(timer?.isValid ?? false) {
            timer = Timer.scheduledTimer(timeInterval: timePenalty, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
            self.collectionView.isUserInteractionEnabled = true
        } else {
            timer?.invalidate()
            self.collectionView.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        timer?.invalidate()
        newGame()
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        let screenForSharing = captureScreen()
        let activityVC = UIActivityViewController(activityItems: [screenForSharing!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func captureScreen() -> UIImage? {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }
    
    func endTheGame(){
        timer?.invalidate()
        performSegue(withIdentifier: "segueToResults", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let holder = segue.destination as! WrittingResultsVC
        holder.cellsAmount = cellsAmount
        holder.score = score
        holder.userName = userName
        holder.date = Date()
    }
}

//
//-------------------------- Cards amount and initial view of the cells ---------------------------
//

extension GameVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCellId", for: indexPath) as? GameCellCVCell else {
            fatalError("Wrong cell type dequeued")
        }
        cell.topCellImage.image = nil
        cell.gameCellImage.image = #imageLiteral(resourceName: "otherPaper")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsAmount
    }
}

//
//--------------------------- Logic of card matching and flipping -------------------------------
//

extension GameVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexies.append(indexPath)
        score += 1
        switch selectedIndexies.count {
        case 3:
            let cell1 = collectionView.cellForItem(at: selectedIndexies[0]) as! GameCellCVCell
            let cell2 = collectionView.cellForItem(at: selectedIndexies[1]) as! GameCellCVCell
            let cell3 = collectionView.cellForItem(at: selectedIndexies[2]) as! GameCellCVCell
            cell1.flipDown()
            cell2.flipDown()
            cell3.flipUp(picture: pictures[selectedIndexies[2].row])
            selectedIndexies.remove(at: 0)
            selectedIndexies.remove(at: 0)
        case 2:
            if selectedIndexies[0] == selectedIndexies[1] {
                alreadySeenIndexies.append(selectedIndexies[0])
                score += penalty
                let cell = collectionView.cellForItem(at: selectedIndexies[0]) as! GameCellCVCell
                cell.flipDown()
                selectedIndexies.removeAll()
            } else {
                let cell1 = collectionView.cellForItem(at: selectedIndexies[0]) as! GameCellCVCell
                let cell2 = collectionView.cellForItem(at: selectedIndexies[1]) as! GameCellCVCell
                cell2.flipUp(picture: pictures[selectedIndexies[1].row])
                if pictures[selectedIndexies[0].row] == pictures[selectedIndexies[1].row] {
                    cell1.remove()
                    cell2.remove()
                    cellsCounter -= 2
                    if cellsCounter == 0 {
                        endTheGame()
                    }
                } else {
                    if alreadySeenIndexies.contains(indexPath) {
                        score += penalty
                    } else {
                        alreadySeenIndexies.append(selectedIndexies[0])
                        alreadySeenIndexies.append(selectedIndexies[1])
                    }
                }
            }
        default:
            let cell = collectionView.cellForItem(at: selectedIndexies[0]) as! GameCellCVCell
            cell.flipUp(picture: pictures[selectedIndexies[0].row])
        }
    }
    
}

//
//--------------------------------------- Cells size --------------------------------------------
//

extension GameVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        let screenHeight = collectionView.frame.height
        let cellCounter = cellForRowAndCollomn[cellsAmount]
        return CGSize(width: screenWidth/CGFloat(cellCounter![0]) - 10, height: screenHeight/CGFloat(cellCounter![1]) - 10)
    }
}
