//
//  ChoiceViewController.swift
//  MyBaby
//
//  Created by Kelly Li on 16/8/17.
//  Copyright © 2016年 Kelly Li. All rights reserved.
//

import UIKit
import RealmSwift

func RGBA (_ rgbValue: UInt32, alphaValue: CGFloat) ->UIColor {
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                   green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                   blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                   alpha: alphaValue)
}


class ChoiceViewController: UIViewController {

    @IBOutlet weak var headUITextField: UITextField!
    @IBOutlet weak var letterUITextField: UITextField!
    @IBOutlet weak var numberUITextField: UITextField!
    
    @IBOutlet weak var letterButton: UIButton!
    @IBAction func letterAction(_ sender: AnyObject) {
        
        letterButton.isSelected = !letterButton.isSelected
        letterUITextField.becomeFirstResponder()
        numberUITextField.text = ""
        fifButton.isEnabled = false
        onehundredButton.isEnabled = false
        if numberButton.isSelected == true || fifButton.isSelected == true || onehundredButton.isSelected == true{
            numberButton.isSelected = false
            fifButton.isSelected = false
            onehundredButton.isSelected = false
        }
        if letterButton.isSelected  && letterUITextField.text != ""{
            confirmButton.alpha = 1
            confirmButton.isEnabled = true
        }else{
            confirmButton.isEnabled = false
        }
        
    }
    
    @IBOutlet weak var numberButton: UIButton!
    @IBAction func numberAction(_ sender: AnyObject) {
        
        numberButton.isSelected = !numberButton.isSelected
        numberUITextField.becomeFirstResponder()
        letterUITextField.text = ""
        fifButton.isEnabled = true
        onehundredButton.isEnabled = true
        if letterButton.isSelected == true{
            letterButton.isSelected = false
        }
    }
    
    @IBOutlet weak var fifButton: UIButton!

    @IBAction func count50Action(_ sender: AnyObject) {
        
        view.endEditing(true)
        fifButton.isSelected = !fifButton.isSelected
        if onehundredButton.isSelected == true{
            onehundredButton.isSelected = false
        }
        if numberButton.isSelected && numberUITextField.text != "" && (fifButton.isSelected  || onehundredButton.isSelected){
            confirmButton.alpha = 1
            confirmButton.isEnabled = true
        }else{
            confirmButton.isEnabled = false
        }

    }
    
    @IBOutlet weak var onehundredButton: UIButton!
    @IBAction func count100Action(_ sender: AnyObject) {
        
        view.endEditing(true)
        onehundredButton.isSelected = !onehundredButton.isSelected
        if fifButton.isSelected == true {
            fifButton.isSelected = false
        }
        if numberButton.isSelected && numberUITextField.text != "" && (fifButton.isSelected  || onehundredButton.isSelected){
            confirmButton.alpha = 1
            confirmButton.isEnabled = true
        }else{
            confirmButton.isEnabled = false
        }

    }
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBAction func confirmAction(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "showwordviewcontroller", sender: self)
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        
        letterUITextField.text = ""
        numberUITextField.text = ""
        letterButton.isSelected = false
        numberButton.isSelected = false
        fifButton.isSelected = false
        onehundredButton.isSelected = false
        
    }
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        title = "单词选择"
        
        confirmButton.alpha = 0.4
        
        confirmButton.isEnabled = false

        letterButton.setBackgroundImage(UIImage.imageWithColor(RGBA(0x9DCBF2, alphaValue: 1.0), frame: CGRect(x: 0,y: 0,width: 80,height: 35)), for: .selected)
        
        numberButton.setBackgroundImage(UIImage.imageWithColor(RGBA(0x9DCBF2, alphaValue: 1.0), frame: CGRect(x: 0,y: 0,width: 80,height: 35)), for: .selected)
        
        fifButton.setBackgroundImage(UIImage.imageWithColor(RGBA(0x9DCBF2, alphaValue: 1.0), frame: CGRect(x: 0,y: 0,width: 60,height: 25)), for: .selected)
        
        onehundredButton.setBackgroundImage(UIImage.imageWithColor(RGBA(0x9DCBF2, alphaValue: 1.0), frame: CGRect(x: 0,y: 0,width: 60,height: 25)), for: .selected)
       // 直接使用系统颜色onehundredButton.setBackgroundImage(UIImage.imageWithColor(UIColor.redColor(),frame: CGRect()), forState: .Selected)
        
        if let path : String = Bundle.main.path(forResource: "EnglishWords", ofType: "txt") {
            
            do {
                let fileContent = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                
                let arrayLine: [String] = fileContent.components(separatedBy: CharacterSet.newlines)    //按行切分，每行为一个数组即一个单词全部元素
                
                let realm = try! Realm()
                let item = realm.objects(Words.self)
                if item.count != arrayLine.count{
                    for line in arrayLine{
                        
                        let arrayWord: [String] = line.components(separatedBy: CharacterSet(charactersIn:"\t"))     //以tab切分，将每个单词的各元素存放在数组中
                        
                        //wordArray.append(arrayWord)
                        
                        let word = Words()
                        word.id = (NumberFormatter().number(from: arrayWord[0])?.intValue)!
                        word.word = arrayWord[1]
                        word.property = arrayWord[2]
                        word.cword = arrayWord[3]
                        try! realm.write {
                            realm.add(word, update: true)
                        }
                    }
                }
            }
                
            catch {
                print(error)
            }
        }
        
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resourc    /*
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "showwordviewcontroller"){
            let sendmessage:WordViewController = segue.destination as! WordViewController
            if letterButton.isSelected == true{
                sendmessage.sendletter = letterUITextField.text
            } else{
                sendmessage.type = .number
                sendmessage.sendnumber = Int(numberUITextField.text!)!
                    //print(sendmessage.sendnumber)
                
                if fifButton.isSelected == true{
                    sendmessage.sendcount = 50
                }else{
                    sendmessage.sendcount = 100
                }
            }
           
        }
    }
    
    //点击屏幕空白处，退出手机键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation
   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     */

}

extension UIImage {
    class func imageWithColor(_ color: UIColor, frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(frame.size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!;
    }
}
