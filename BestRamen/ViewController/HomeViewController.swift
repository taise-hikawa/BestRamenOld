import UIKit

class HomeViewController: UIViewController {
    
    let viewModel: HomeViewModel = HomeViewModel()
    var userCount:Int = 0
    var imageSetFlag:Dictionary<String,Bool> = ["post": false,"user": false]{
        didSet{
            if imageSetFlag.values.contains(false){
            }else{
                homeTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.estimatedRowHeight = 290
        homeTableView.rowHeight = UITableView.automaticDimension
        homeTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        homeTableView.delegate = self
        homeTableView.dataSource = self
        //空の行の線を消す
        homeTableView.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        imageSetFlag = ["post": false,"user": false]
        userCount = 0
    }
    
    //画面遷移時の値の引き渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNextViewController" {
            let nextVC = segue.destination as! PostViewController
            let row = self.homeTableView.indexPathForSelectedRow?.row ?? 0
//            nextVC.initSelf(item: viewModel.postsArry[row])
        }
    }
    
    @IBOutlet weak var homeTableView: UITableView!
    
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルをカスタムセルに
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        let item = viewModel.postsArray[indexPath.row]
        cell.initSelf(item: item)
        return cell
    }
    
    //セルが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // 別の画面に遷移
        if viewModel.postsArray.count-1 >= indexPath.row{
            performSegue(withIdentifier: "toNextViewController", sender: nil)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.postsArray.count
    }
}
