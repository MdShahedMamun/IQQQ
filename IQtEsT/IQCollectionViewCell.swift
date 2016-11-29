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
    
    // set value when first cells are appear from controller
    var correctAnswerForThisCell:Int!
    // use valu when program control back in controller again and update the score
    var addScore:Bool!;
    var userAnswer:Int!;
    
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
        userAnswer=sender.tag;
        print(userAnswer);
        
        // 4 combination for two option
        if correctAnswerForThisCell==1&&userAnswer==1{
            firstOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
            firstOptionButton.imageView?.tintColor=UIColor.greenColor();
            addScore=true;
        }else if correctAnswerForThisCell==2&&userAnswer==2{
            secondOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
            secondOptionButton.imageView?.tintColor=UIColor.greenColor();
            addScore=true;
        }else if correctAnswerForThisCell==2&&userAnswer==1{
            firstOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
            firstOptionButton.imageView?.tintColor=UIColor.redColor();
            addScore=false;
        }else if correctAnswerForThisCell==1&&userAnswer==2{
            secondOptionButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
            secondOptionButton.imageView?.tintColor=UIColor.redColor();
            addScore=false;
        }
        firstOptionButton.enabled=false;
        secondOptionButton.enabled=false;
        
        // pass control to delegate in this IQ...Controller
        delegate!.controllerPartWork(self,addScore: addScore,userAnswer: userAnswer);
    }
}




