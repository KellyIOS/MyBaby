//
//  WordViewController.swift
//  MyBaby
//
//  Created by Kelly Li on 16/8/17.
//  Copyright © 2016年 Kelly Li. All rights reserved.
//

import UIKit
import RealmSwift

public enum ChooseType{
    case letter
    case number
}

class Words: Object {
    dynamic var id = ""
    dynamic var word = ""
    dynamic var property = ""
    dynamic var cword = ""
    dynamic var correctCount = 0
    dynamic var wrongCount = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class WordViewController: UIViewController {
    
    @IBOutlet weak var showwordLable: UILabel!
    @IBOutlet weak var errorwordshow: UILabel!
    @IBOutlet weak var inputword: UITextField!
    @IBOutlet weak var judgeUIImage: UIImageView!
    
    @IBOutlet weak var RecordUIButton: UIButton!
    @IBAction func Record(_ sender: AnyObject) {
        performSegue(withIdentifier: "showrecordviewcontroller", sender: self)
    }
    
    @IBOutlet weak var nextwordUIButton: UIButton!
    @IBAction func nextword(_ sender: AnyObject) {
        inputword.becomeFirstResponder()

        if inputword.text == listArray[listIndex][1]{

            judgeUIImage.image = UIImage(named: "right")
            rightnum += 1
            errorwordshow.text = ""
        }else{
            judgeUIImage.image = UIImage(named: "error")
            errornum += 1
            errorArray.append(listArray[listIndex])

            let errorwordlong = inputword.text?.characters.count        //获得输入字符的长度
            let errorword = NSMutableAttributedString(string: "\(inputword.text!)\t\t\(listArray[listIndex][1])")
            errorword.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSMakeRange(0, errorwordlong!))       //按要求改变指定字符的颜色
            errorwordshow.attributedText = errorword
            //errorwordshow.text = "\(inputword.text!)\t\t\(listArray[listIndex][1])"    //输出用户拼写错误的单词及正确的单词
        }
        
        listIndex += 1
        
        if listIndex < listArray.count {
            showwordLable.text = "\(listArray[listIndex][0])\t\t\(listArray[listIndex][2])\t\t\(listArray[listIndex][3])"
        } else{
            
            showwordLable.text = "本次练习结束！\r 正确：\(rightnum)\r 错误：\(errornum) \r 总数：\(listArray.count)"
            nextwordUIButton.isEnabled = false
            inputword.resignFirstResponder()    //退出手机键盘

        }
        
        inputword.text = ""
       
    }
    

    @IBOutlet weak var errorlist: UIButton!
    @IBAction func errorlistButton(_ sender: AnyObject) {
        inputword.becomeFirstResponder()
        
        if errorArray.count == 0{
            showwordLable.textColor = UIColor.red
            showwordLable.text = "你真棒！"
            nextwordUIButton.isEnabled = false
        }else {

            listArray.removeAll()
            listIndex = 0
            rightnum = 0
            errornum = 0
            listArray = errorArray
            nextwordUIButton.isEnabled = true
            showwordLable.text = "\(listArray[0][0])\t\t\(listArray[0][2])\t\t\(listArray[0][3])"

        errorArray.removeAll()
        }
    }
    
    
    var type: ChooseType = .letter //枚举类型成员变量，用于字母、数字选择
    var sendletter: String?
    var sendnumber: Int = 1
    var sendcount: Int = 50
    var rightnum: Int = 0
    var errornum: Int = 0
    var listIndex: Int = 0
    
    fileprivate var wordArray = [[String]]()    //全部单词表
    fileprivate var listArray = [[String]]()    //所选单词表
    fileprivate var errorArray = [[String]]()   //错误单词表
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputword.delegate = self   //该输入框绑定delegate
        view.bringSubview(toFront: judgeUIImage)
        inputword.becomeFirstResponder()
        //self.inputword.keyboardDistanceFromTextField = 500
        
        //整理文本文件，并将最终结果存放在数组wordArray里
        if let path : String = Bundle.main.path(forResource: "EnglishWords", ofType: "txt") {
            
            do {
                let fileContent = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                
                let arrayLine: [String] = fileContent.components(separatedBy: CharacterSet.newlines)    //按行切分，每行为一个数组即一个单词全部元素

                
                for line in arrayLine{

                    let arrayWord: [String] = line.components(separatedBy: CharacterSet(charactersIn:"\t"))     //以tab切分，将每个单词的各元素存放在数组中
                    
                    wordArray.append(arrayWord)
                    
                    let word = Words()
                    word.id = arrayWord[0]
                    word.word = arrayWord[1]
                    word.property = arrayWord[2]
                    word.cword = arrayWord[3]
                    
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(word, update: true)
                    }

                    }
                }
                
            catch {
                print(error)
            }
        }
        
        //处理上一页面传回的查询数据，使用枚举方式
        
        switch type {
        case .letter:
            for word in wordArray{

                if word[1].hasPrefix(sendletter!.lowercased()) || word[1].hasPrefix(sendletter!.uppercased()) {
                    
                    listArray.append(word)
                    showwordLable.text = "\(listArray[0][0])\t\t\(listArray[0][2])\t\t\(listArray[0][3])"
                }

            }

            let realm = try! Realm()
            let listDBArray = realm.objects(Words.self).filter("word BEGINSWITH \(sendletter!)")
            showwordLable.text = "\(listDBArray[0].id)\t\t\(listDBArray[0].property)\t\t\(listDBArray[0].cword)"
            
        case .number:
            let wordnum = sendnumber + sendcount
            var count = sendnumber
            for word in wordArray{
                
                if Int(word[0]) == count {
                    
                    listArray.append(word)
                    count += 1
                    if count >= wordnum{
                        break
                    }
                }       //将选定的词存放在listArray数组中
            }
            
            showwordLable.text = "\(listArray[0][0])\t\t\(listArray[0][2])\t\t\(listArray[0][3])"
            
            let realm = try! Realm()
            let listDBArray = realm.objects(Words.self).filter("id == \(sendnumber)")
            showwordLable.text = "\(listDBArray[0].id)\t\t\(listDBArray[0].property)\t\t\(listDBArray[0].cword)"
            
            
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.view.endEditing(true)
    }       // 点击空白处退出手机键盘
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextword(textField)         //调用nextword Button的功能函数
        return true
    }

}
