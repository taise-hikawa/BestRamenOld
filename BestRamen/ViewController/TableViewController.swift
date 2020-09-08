//
//  TableViewController.swift
//  BestRamen
//
//  Created by Sakurako Shimbori on 2020/09/08.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    private let reuseIdentifier = "cell"
    private var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TableViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension TableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}
