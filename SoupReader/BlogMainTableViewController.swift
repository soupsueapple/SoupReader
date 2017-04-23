//
//  BlogMainTableViewController.swift
//  SoupReader
//
//  Created by 汤坤 on 2017/4/12.
//  Copyright © 2017年 汤坤. All rights reserved.
//

import UIKit
import Ono
import SafariServices

class BlogMainTableViewController: UITableViewController, XMLParserDelegate{
    
    var tags: Array<TagBean> = []
    
    var eName: String = String()
    var itemName: String = String()
    var link: String = String()
    var tTitle: String = String()
    var date: String = String()
    var subject: String = String()
    var descriptions: String = String()
    
    let cellIdentity = "BlogMainCell"
    
    let toReadingIdentity = "toReading"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(BlogMainTableViewController.refreshTable), for: .valueChanged)
        self.refreshControl = refreshControl
        
        doBlogXMLRequest()
    }
    
    func refreshTable(){
        tags.removeAll()
        self.tableView.reloadData()
        
        doBlogXMLRequest()
    }
    
    func doBlogXMLRequest() -> Void{
        let httpClient = HttpClient(baseURL: URL(string: HttpClient.myBlogURL))
        httpClient.httpClientSetting()
        httpClient.getRequest(url: "", paramters: nil, block: {(any: Any?, error: Error?) -> Void in
            
            if httpClient.httpError(error: error) {
                self.showAlert(text: error?.localizedDescription)
                self.refreshControl?.endRefreshing()
                return
            }
            
            let data = any as! Data
            
            let parse = XMLParser(data: data)
            parse.delegate = self
            parse.parse()
            
        })
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toReadingIdentity{
            let tag = tags[(self.tableView.indexPathForSelectedRow?.row)!]
            
            let readingViewControll = segue.destination as! ReadingViewController
            readingViewControll.tag = tag
        }
    }
    
    // MARK: XMLParserDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        eName = elementName
        
        if elementName == "item" {
            itemName = elementName
            
            self.link = String()
            self.tTitle = String()
            self.date = String()
            self.subject = String()
            self.descriptions = String()
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            
            let tag = TagBean()
            tag.link = self.link
            tag.title = self.tTitle
            tag.date = self.date
            tag.subject = self.subject
            tag.descriptions = self.descriptions
            
            tags.append(tag)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if !data.isEmpty{
            
            if itemName == "item"{
                
                if eName == "link" {
                    self.link += data
                } else if eName == "title" {
                    self.tTitle += data
                } else if eName == "dc:date" {
                    self.date += data
                } else if eName == "dc:subject" {
                    self.subject += data
                } else if eName == "description" {
                    self.descriptions += data
                }
                
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tags.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath) as! BlogMainTableViewCell

        let tag = tags[indexPath.row]
        
        cell.title_lb.text = tag.title
        cell.digest_lb.text = tag.descriptions

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//        
//        let tag = tags[indexPath.row]
//        let link = tag.link
//        
//        let safariViewController = SFSafariViewController(url: URL(string: link)!, entersReaderIfAvailable: true)
//        
//        present(safariViewController, animated: true, completion: {() -> Void in
//            
//            
//            
//        })
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
