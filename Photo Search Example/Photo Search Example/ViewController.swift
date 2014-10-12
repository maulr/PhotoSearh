//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Ron Mauldin on 10/6/14.
//  Copyright (c) 2014 maulr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {



     

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

          searchBar.delegate = self

        // Do any additional setup after loading the view, typically from a nib.

        println("just before buttonClicked")

        func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
            for subview in self.scrollView.subviews {
                subview.removeFromSuperview()
                println("ButtonClicked")
            }
                println("1st Responder")
                searchBar.resignFirstResponder()


            let instagramURLString = "https://api.instagram.com/v1/tags/" + searchBar.text + "/media/recent?client_id=5a1f00b638364d5b82afb9d14bb200ef"

            let manager = AFHTTPRequestOperationManager()

            manager.GET( instagramURLString,
                parameters: nil,
                success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                    println("JSON: " + responseObject.description)

                    if let dataArray = responseObject.valueForKey("data") as? [AnyObject] {
                        self.scrollView.contentSize = CGSizeMake(320, CGFloat(320*dataArray.count))
                        for var i = 0; i < dataArray.count; i++ {
                            let dataObject: AnyObject = dataArray[i]
                            if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                                println("image " + String(i) + " URL is " + imageURLString)

                                let imageData =  NSData(contentsOfURL: NSURL(string: imageURLString)!)
                                let imageView = UIImageView(image: UIImage(data: imageData!))
                                imageView.frame = CGRectMake(0, CGFloat(320*i), 320, 320)
                                self.scrollView.addSubview(imageView)
                                println("Getting Image")
                            }
                        }
                    }
                },

                failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                    println("Error: " + error.localizedDescription)
              })

           }
        println("end of code")

       }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
   }
}

