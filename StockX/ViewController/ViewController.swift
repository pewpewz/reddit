//
//  ViewController.swift
//  StockX
//
//  Created by terrylee on 4/8/21.
//

import UIKit

class ViewController: UIViewController, RedditDelegate {

    // MARK:  Static identifiers
    let cellIdentifier = "PostCell"
    let webIdentifier  = "WebViewController"

    var viewModel: RedditViewModel?
    var activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    /// List is updated on network fetch
    var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
            scrollToFirstRow()
        }
    }
    
    /// scrolls to top of list on posts fetch
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    /// Setup UI initial state
    func configureUI() {
        viewModel = RedditViewModel()
        viewModel?.delegate = self
        loadRedditFeed()
        self.tableView.backgroundColor = #colorLiteral(red: 0.09677872737, green: 0.09794473613, blue: 0.09794473613, alpha: 1)
        textField.returnKeyType = UIReturnKeyType.search
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let text = textField.text, !text.isEmpty else { return }
        textField.resignFirstResponder()
        loadRedditFeed(text)
    }
    /// Fetch Reddit's feed based on search bar text
    /// - Parameter text: subreddit / homepage = ""
    func loadRedditFeed(_ text:String = "") {
        activityIndicator(isOn: true)
        viewModel?.searchSubReddit(text, completion: {[weak self] _ in
            DispatchQueue.main.async {
                self?.activityIndicator(isOn: false)
            }
        })
    }
    
    /// Turns on and off the loader indicator for search bar
    /// - Parameter isOn: true for on
    func activityIndicator(isOn: Bool) {
        if isOn && activityIndicator == nil {
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            self.activityIndicator = activityIndicator
            textField.addSubview(activityIndicator)
            activityIndicator.frame = textField.bounds
            activityIndicator.startAnimating()
        } else {
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
        }
    }
}

// MARK: - TableView Delegates
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let webViewController = storyboard.instantiateViewController(withIdentifier: webIdentifier) as? WebViewController else {
            return
        }
        webViewController.url = posts[indexPath.row].url
        present(webViewController, animated: false, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! PostCell
        let post:Post = posts[indexPath.row]
        cell.configure(PostCellModel(title: post.title, subTitle: post.subreddit))
        
        cell.accessibilityIdentifier = "\(cellIdentifier)_\(indexPath.row)"
        return cell
    }
}

// MARK: - Text Field Delegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return true }
        loadRedditFeed(textField.text ?? "")
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}
