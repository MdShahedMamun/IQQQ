//
//  IQTestViewController.swift
//  IQtEsT
//
//  Created by Mac air on 11/30/16.
//  Copyright © 2016 Mac air. All rights reserved.
//

import UIKit
import CoreData;

class IQTestViewController: UIViewController,UICollectionViewDelegate,
UICollectionViewDataSource,NSFetchedResultsControllerDelegate,IQCollectionViewCellDelegate {
    
    @IBOutlet var collectionView:UICollectionView!
    @IBOutlet var scoreLable:UILabel!;
    @IBOutlet var resetButton:UIButton!;
    @IBOutlet weak var backgroundImageView:UIImageView!
    
    var iqTests:[IQTest] = []
    var fetchResultController:NSFetchedResultsController!
    var score:Float = 0.0;
    
    var defaults=NSUserDefaults.standardUserDefaults();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        score=defaults.floatForKey("score");
        print("score= \(score)");
        scoreLable.text=String(score);
        
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: "cloud")
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        collectionView.backgroundColor = UIColor.clearColor()
        
        // Change the height for 3.5-inch screen
        if UIScreen.mainScreen().bounds.size.height == 480.0 {
            let flowLayout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSizeMake(250.0, 300.0)
        }
        
        // Load the iqTests from database
        let fetchRequest = NSFetchRequest(entityName: "IQTest")
        // fetching data sorted by name
        let sortDescriptor = NSSortDescriptor(key: "question", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            // only one
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            // notice
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                iqTests = fetchResultController.fetchedObjects as! [IQTest]
            } catch {
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iqTests.count;
    }
    
    @IBAction func resetButtonTapped(sender:AnyObject){
        
        // Reset in Data
        // iqTests.count porjonto loop chaliye shobgulote userAnswer=0 ebong score=0 kora
        for iqTest in iqTests{
            iqTest.userAnswer=0;
            defaults.setFloat(0, forKey: "score")
        }
        
        // save the change in database (managedObjectContext)
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
        
        //        // inefficient (First Way)
        //        dismissViewControllerAnimated(true, completion: nil)
        //        viewDidLoad()
        
        // (Second Way)
        // Reset View to show the change of data.
        // restart collection view
        collectionView.reloadData();
        // reset scoreLabel
        score=defaults.floatForKey("score");
        print("score= \(score)");
        scoreLable.text=String(score);
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! IQCollectionViewCell
        
        // Configure the cell
        cell.questionLabel.text = iqTests[indexPath.row].question
        cell.cellImageView.image=UIImage(named: "sky");
        cell.firstOptionLable.text = iqTests[indexPath.row].option1value
        cell.secondOptionLabel.text = iqTests[indexPath.row].option2value
        // set the correct answer to each corresponding cell
        cell.correctAnswerForThisCell=iqTests[indexPath.row].correctAnswer;
        
        if iqTests[indexPath.row].userAnswer==0{
            //  initialize when first appear
            cell.currentCellFirstTap=true;
            cell.firstOptionButton.tintColor=UIColor.whiteColor();
            cell.secondOptionButton.tintColor=UIColor.whiteColor();
            cell.firstOptionButton.setImage(UIImage(named: "heart"), forState: .Normal);
            cell.secondOptionButton.setImage(UIImage(named: "heart"), forState: .Normal);
            
        }else if iqTests[indexPath.row].correctAnswer==1&&iqTests[indexPath.row].userAnswer==1{
            cell.currentCellFirstTap=false;
            cell.firstOptionButton.tintColor=UIColor.greenColor();
            cell.firstOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
            
        }else if iqTests[indexPath.row].correctAnswer==2&&iqTests[indexPath.row].userAnswer==2{
            cell.currentCellFirstTap=false;
            cell.secondOptionButton.tintColor=UIColor.greenColor();
            cell.secondOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
            
        }else if iqTests[indexPath.row].correctAnswer==2&&iqTests[indexPath.row].userAnswer==1{
            cell.currentCellFirstTap=false;
            cell.firstOptionButton.tintColor=UIColor.redColor();
            cell.firstOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
            
        }else if iqTests[indexPath.row].correctAnswer==1&&iqTests[indexPath.row].userAnswer==2{
            cell.currentCellFirstTap=false;
            cell.secondOptionButton.tintColor=UIColor.redColor();
            cell.secondOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
        }
        
        // assign
        cell.delegate = self
        
        // Apply round corner
        cell.layer.cornerRadius = 4.0
        
        return cell
    }
    
    // MARK: - IQCollectionViewCellDelegate Methods
    func controllerPartWork(cell: IQCollectionViewCell,addScore:Bool,userAnswer:Int) {
        if let indexPath = collectionView!.indexPathForCell(cell) {
            // set change to (main place) database
            iqTests[indexPath.row].userAnswer = userAnswer;
            
            if addScore{
                // update score in UserDefaults
                score=NSUserDefaults.standardUserDefaults().floatForKey("score");
                score+=6;
                scoreLable.text=String(score);
                NSUserDefaults.standardUserDefaults().setFloat(score, forKey: "score");
                print("inside controllerPartWork() score: \(score)");
            }
            
            // save the change in database (managedObjectContext)
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
            
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
