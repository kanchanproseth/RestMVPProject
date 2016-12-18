//
//  ArticleVC.swift
//  RestMVP
//
//  Created by Cyberk on 12/12/16.
//  Copyright © 2016 Cyberk. All rights reserved.
//

import UIKit

class ArticleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var eventHandler : ArticlePresenter?

    @IBOutlet weak var tableView: UITableView!

    
    var articles:[Article] = []

    
    override func viewDidDisappear(_ animated: Bool) {
        articles.removeAll()
        loadArticleViewWithData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
        
        loadArticleViewWithData()
    }
    func loadArticleViewWithData(){
        eventHandler = ArticlePresenter()
        eventHandler?.LoadArticleView(viewInterface: self)

        eventHandler?.loadArticleData(page: 1, Limite: 10 )
    }
    func refresh(_ refreshControl: UIRefreshControl) {
        // Do your job, when done:
        articles.removeAll()
        loadArticleViewWithData()
        refreshControl.endRefreshing()
        print("4")

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func BackToMain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
extension ArticleVC: ArticleProtocol{
    func LoadArticleView() {}
    
    func UpdateArticle(_ data:[Article]) {
        articles.append(contentsOf: data)
        tableView.reloadData()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if indexPath.row == articles.count - 1 {
            print("I am trying load more record ")
            if PAGE < TOTAL_PAGE {
                PAGE = PAGE + 1
                eventHandler?.loadArticleData(page: PAGE, Limite: LIMIT)
            }
        }
        print("It is cell number : \(indexPath.row)")
        cell.configureCell(model: articles[indexPath.row])
        return cell
    }

}
