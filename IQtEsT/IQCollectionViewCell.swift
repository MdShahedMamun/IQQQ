//
//  IQCollectionViewCell.swift
//  IQtEsT
//
//  Created by Mac air on 11/29/16.
//  Copyright © 2016 Mac air. All rights reserved.
//

import UIKit

protocol IQCollectionViewCellDelegate {
    func controllerPartWork(cell: IQCollectionViewCell,addScore:Bool,userAnswer:Int)
}

class IQCollectionViewCell: UICollectionViewCell {
    @IBOutlet var questionLabel:UILabel!;
    @IBOutlet var firstOptionLable:UILabel!;
    @IBOutlet var secondOptionLabel:UILabel!;
    @IBOutlet var firstOptionButton:UIButton!;
    @IBOutlet var secondOptionButton:UIButton!;
    @IBOutlet var cellImageView:UIImageView!
    
    // set value when first cells are appear from controller
    var correctAnswerForThisCell:Int!
    // use value when program control back in controller again and update the score
    var addScore:Bool!;
    var userAnswer:Int!;
    var currentCellFirstTap=true;
    
    var delegate:IQCollectionViewCellDelegate?
    
    //    var correctAnswer:Int = 2  {
    //        didSet {
    //            if correctAnswer==1{
    //                firstOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
    //                firstOptionButton.imageView?.tintColor=UIColor.greenColor();
    //                secondOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
    //            } else{
    //                secondOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
    //            }
    //        }
    //    }
    
    @IBAction func optionButtonTapped(sender:AnyObject){
        print("currentCellFirstTap: \(currentCellFirstTap)");

        if currentCellFirstTap{
            currentCellFirstTap=false;
            userAnswer=sender.tag;
            print("sender.tag or userAnswer: \(userAnswer)");
            print("correctAnswerForThisCell: \(correctAnswerForThisCell)");
            // 4 combination for two option
            if correctAnswerForThisCell==1&&userAnswer==1{
                print("case1");
                firstOptionButton.tintColor=UIColor.greenColor()
                firstOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
                addScore=true;
            }else if correctAnswerForThisCell==2&&userAnswer==2{
                print("case2");
                secondOptionButton.tintColor=UIColor.greenColor()
                secondOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
                addScore=true;
            }else if correctAnswerForThisCell==2&&userAnswer==1{
                print("case3")
                firstOptionButton.tintColor=UIColor.redColor()
                firstOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
                addScore=false;
            }else if correctAnswerForThisCell==1&&userAnswer==2{
                print("case4")
                secondOptionButton.tintColor=UIColor.redColor();
                secondOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
                addScore=false;
            }else{
                print("case5 see");
            }
            //        firstOptionButton.enabled=false;
            //        secondOptionButton.enabled=false;
            
            // pass control to delegate in this IQ...Controller
            delegate!.controllerPartWork(self,addScore: addScore,userAnswer: userAnswer);
        }else{
            print("inside return");
            return;
        }
    }
    
}




