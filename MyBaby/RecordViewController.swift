//
//  RecordViewController.swift
//  MyBaby
//
//  Created by Kelly Li on 16/10/8.
//  Copyright © 2016年 Kelly Li. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    @IBOutlet weak var recordtable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordtable.dataSource = self
        
        title = "完成情况"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RecordViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10   //有多少行
    }
}
