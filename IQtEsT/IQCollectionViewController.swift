//
//  IQCollectionViewController.swift
//  IQtEsT
//
//  Created by Mac air on 11/29/16.
//  Copyright © 2016 Mac air. All rights reserved.
//

import UIKit
import CoreData;

class IQCollectionViewController: UICollectionViewController,NSFetchedResultsControllerDelegate,IQCollectionViewCellDelegate{
    
    @IBOutlet var scoreLable:UILabel!;
    @IBOutlet weak var backgroundImageView:UIImageView!
    
    var iqTests:[IQTest] = []
    var fetchResultController:NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //        // Register cell classes
        //        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        // Do any additional setup after loading the view.
        
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: "cloud")
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        // Change the height for 3.5-inch screen
        if UIScreen.mainScreen().bounds.size.height == 480.0 {
            let flowLayout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSizeMake(250.0, 300.0)
        }
        
        // prelaod data
        let a:Int=1;//In first run a=1 then a=2 for other run
        if a==1{
            let question="If 9^a=25 then 3^a=?"
            let score:Float=0;
            var correctAnswer:Int=2;
            let userAnswer:Int=0;
            let option1Value="4"
            let option2Value="5";
            
            var iqTest:IQTest!;
            
            for _ in 1...5{
                if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                    iqTest = NSEntityDescription.insertNewObjectForEntityForName("IQTest", inManagedObjectContext: managedObjectContext) as! IQTest
                    iqTest.question=question
                    iqTest.score=score;
                    iqTest.correctAnswer=correctAnswer;
                    iqTest.option1value=option1Value;
                    iqTest.option2value=option2Value;
                    iqTest.userAnswer=userAnswer;
                    if correctAnswer==1{
                        correctAnswer=2;
                    }else {
                        correctAnswer=1;
                    }
                    
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print(error)
                        return
                    }
                }
            }
        }
        
        // Load the iqTests from database
        let fetchRequest = NSFetchRequest(entityName: "IQTest")
        // fetching data sorted by name
        let sortDescriptor = NSSortDescriptor(key: "question", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            // only one
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iqTests.count;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! IQCollectionViewCell
        
        // Configure the cell
        cell.questionLabel.text = iqTests[indexPath.row].question
        cell.firstOptionLable.text = iqTests[indexPath.row].option1value
        cell.secondOptionLabel.text = iqTests[indexPath.row].option2value
        // set the correct answer to each corresponding cell
        cell.correctAnswerForThisCell=iqTests[indexPath.row].correctAnswer;
        
        if iqTests[indexPath.row].userAnswer==0{
            cell.firstOptionButton.setImage(UIImage(named: "heart"), forState: .Normal);
            cell.secondOptionButton.setImage(UIImage(named: "heart"), forState: .Normal);
        }else if iqTests[indexPath.row].correctAnswer==1&&iqTests[indexPath.row].userAnswer==1{
            cell.firstOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
            cell.firstOptionButton.imageView?.tintColor=UIColor.greenColor();
        }else if iqTests[indexPath.row].correctAnswer==2&&iqTests[indexPath.row].userAnswer==2{
            cell.secondOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
            cell.secondOptionButton.imageView?.tintColor=UIColor.greenColor();
        }else if iqTests[indexPath.row].correctAnswer==2&&iqTests[indexPath.row].userAnswer==1{
            cell.firstOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
            cell.firstOptionButton.imageView?.tintColor=UIColor.redColor();
        }else if iqTests[indexPath.row].correctAnswer==1&&iqTests[indexPath.row].userAnswer==2{
            cell.secondOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
            cell.secondOptionButton.imageView?.tintColor=UIColor.redColor();
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
            iqTests[indexPath.row].userAnswer = userAnswer;
            if addScore{
                // update corresponding managed object
            }
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}
