//
//  GameVC.swift
//  Memory
//
//  Created by Ganna Melnyk on 1/29/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//

import UIKit

class GameVC: UIViewController {
    
    let penalty = 2
    let timeUpdationInterval = 1.0
    let cellMagrings: CGFloat = 5
    let maxInt16Num = Int16.max
    
    var cellsAmount = 4
    var userName = ""
    var pictures: [UIImage] = []
    var selectedIndexies: [IndexPath] = []
    var alreadySeenIndexies: [IndexPath] = []
    var timer: Timer?
    var cellsCounter = 4
    
    var score: Int = 0 {
        didSet{
            let item = navigationItem.rightBarButtonItems?[1] ?? UIBarButtonItem(title: "Score: \(timerInSeconds)", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            item.title = "Score: \(score)"
        }
    }
    var timerInSeconds: Int = 0 {
        didSet{
        let item = navigationItem.rightBarButtonItems?[0] ?? UIBarButtonItem(title: "Time: \(timerInSeconds)", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            item.title = "Time: \(timerInSeconds)"
        }
    }
    
    @IBOutlet weak var barView: UIToolbar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "launchScreen"))
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = #imageLiteral(resourceName: "launchScreen")
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        newGame()
        
        let timerButton = UIBarButtonItem(title: "Time: \(timerInSeconds)", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        timerButton.style = .plain
        let scoreButton = UIBarButtonItem(title: "Score: \(score)", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        scoreButton.style = .plain
        self.navigationItem.rightBarButtonItems = [timerButton, scoreButton]
    }
    
    @IBAction func pause(_ sender: UIBarButtonItem) {
        pauseOrStartTimer()
    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        timer?.invalidate()
        newGame()
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        let screenForSharing = captureScreen()
        let activityVC = UIActivityViewController(activityItems: [screenForSharing ?? #imageLiteral(resourceName: "launchScreen")], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func updateTimer() {
        timerInSeconds += 1
        if timerInSeconds >= maxInt16Num {
            gameOver()
        }
    }
    
    func pauseOrStartTimer() {
        if (timer?.isValid ?? false) {
            timer?.invalidate()
            self.collectionView.isUserInteractionEnabled = false
        } else {
            timer = Timer.scheduledTimer(timeInterval: timeUpdationInterval, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
            self.collectionView.isUserInteractionEnabled = true
        }
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
        guard let holder = segue.destination as? WrittingResultsVC else {
            fatalError("cannot create connection to WrittingResultsVC")
        }
        holder.cellsAmount = cellsAmount
        holder.score = score
        holder.userName = userName
        holder.date = Date()
        holder.timerInSeconds = timerInSeconds
    }
    
    func cellsRowAndColomn() -> (cellInRow: Int, cellInColomn: Int){
        var cellInRow = Int(floor(sqrt(Double(cellsAmount))))
        while (cellsAmount % cellInRow != 0) {
            cellInRow -= 1
            if (cellInRow == 1) {
                break
            }
        }
        let cellInColomn = cellsAmount / cellInRow
        return (cellInRow, cellInColomn)
    }
    
    func newGame() {
        pictures = [#imageLiteral(resourceName: "027-avocado"), #imageLiteral(resourceName: "014-pitaya"), #imageLiteral(resourceName: "028-radishes"), #imageLiteral(resourceName: "032-cherry"), #imageLiteral(resourceName: "015-pomegranate"), #imageLiteral(resourceName: "005-mangosteen"), #imageLiteral(resourceName: "035-olives"), #imageLiteral(resourceName: "017-peas"), #imageLiteral(resourceName: "038-artichoke"), #imageLiteral(resourceName: "008-pumpkin"), #imageLiteral(resourceName: "046-peach"), #imageLiteral(resourceName: "037-mushroom"), #imageLiteral(resourceName: "012-carambola"), #imageLiteral(resourceName: "045-orange"), #imageLiteral(resourceName: "040-papaya"), #imageLiteral(resourceName: "025-grapes"), #imageLiteral(resourceName: "050-garlic"), #imageLiteral(resourceName: "024-strawberry"), #imageLiteral(resourceName: "049-watermelon"), #imageLiteral(resourceName: "034-blueberries"), #imageLiteral(resourceName: "047-chili"), #imageLiteral(resourceName: "003-corn"), #imageLiteral(resourceName: "016-melon"), #imageLiteral(resourceName: "004-pear"), #imageLiteral(resourceName: "022-peanut"), #imageLiteral(resourceName: "042-cabbage"), #imageLiteral(resourceName: "001-tomato"), #imageLiteral(resourceName: "002-lettuce"), #imageLiteral(resourceName: "009-mango"), #imageLiteral(resourceName: "011-coconut"), #imageLiteral(resourceName: "020-cauliflower"), #imageLiteral(resourceName: "044-courgette"), #imageLiteral(resourceName: "039-carrot"), #imageLiteral(resourceName: "043-lemon")]
        initialShuffler()
        pairsShuffler()
        selectedIndexies.removeAll()
        cellsCounter = cellsAmount
        alreadySeenIndexies.removeAll()
        score = 0
        timerInSeconds = 0
        collectionView.reloadData()
        pauseOrStartTimer()
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
    
    func cellCasting(index: Int) -> GameCellCVCell {
        guard let cell = collectionView.cellForItem(at: selectedIndexies[index]) as? GameCellCVCell else {
            fatalError("wrong cell type")
        }
        return cell
    }
    
    func setPicture(index: Int) -> UIImage {
        return pictures[selectedIndexies[index].row]
    }
    
    func gameOver() {
        self.timer?.invalidate()
        let alertController = UIAlertController(title: "Game over!", message: "you reached the max resolved value", preferredStyle: .alert)
        let newGameAction = UIAlertAction(title: "new game", style: .destructive) { action in
            self.newGame()
        }
        alertController.addAction(newGameAction)
        present(alertController, animated: true, completion: nil)
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
        if score > maxInt16Num {
            gameOver()
        }
        
        switch selectedIndexies.count {
        case 3:
            let cell1 = cellCasting(index: 0)
            let cell2 = cellCasting(index: 1)
            let cell3 = cellCasting(index: 2)
            cell1.flipDown()
            cell2.flipDown()
            cell3.flipUp(picture: setPicture(index: 2))
            selectedIndexies.remove(at: 0)
            selectedIndexies.remove(at: 0)
        case 2:
            if selectedIndexies[0] == selectedIndexies[1] {
                alreadySeenIndexies.append(selectedIndexies[0])
                score += penalty
                let cell = cellCasting(index: 0)
                cell.flipDown()
                selectedIndexies.removeAll()
            } else {
                let cell1 = cellCasting(index: 0)
                let cell2 = cellCasting(index: 1)
                cell2.flipUp(picture: setPicture(index: 1))
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
            let cell = cellCasting(index: 0)
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
        let cell = cellsRowAndColomn()
        if (screenWidth < screenHeight) {
            return CGSize(width: screenWidth/CGFloat(cell.cellInRow) - cellMagrings, height: screenHeight/CGFloat(cell.cellInColomn) - cellMagrings)
        } else {
            return CGSize(width: screenWidth/CGFloat(cell.cellInColomn) - cellMagrings, height: screenHeight/CGFloat(cell.cellInRow) - cellMagrings)
        }
    }
}
