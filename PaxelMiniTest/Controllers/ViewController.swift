//
//  ViewController.swift
//  PaxelMiniTest
//
//  Created by Febbry Ramadhan on 12/21/18.
//  Copyright © 2018 Febbry Ramadhan. All rights reserved.
//

import UIKit
import DisplaySwitcher
import SwiftyJSON
import SVProgressHUD


class ViewController: UIViewController {
    private let animationDuration: TimeInterval = 0.3
    
    private let listLayoutStaticCellHeight: CGFloat = 80
    private let gridLayoutStaticCellHeight: CGFloat = 165
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var rotationButton: SwitchLayoutButton!
    var offset = 1
    fileprivate var movies = [Movie]()
    fileprivate var isTransitionAvailable = true
    fileprivate lazy var listLayout = DisplaySwitchLayout(staticCellHeight: listLayoutStaticCellHeight, nextLayoutStaticCellHeight: gridLayoutStaticCellHeight, layoutState: .list)
    fileprivate lazy var gridLayout = DisplaySwitchLayout(staticCellHeight: gridLayoutStaticCellHeight, nextLayoutStaticCellHeight: listLayoutStaticCellHeight, layoutState: .grid)
    fileprivate var layoutState: LayoutState = .list
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        rotationButton.isSelected = true
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
        movies = [Movie]()
        collectionView.reloadData()
        offset = 1
        collectionView.addInfiniteScroll { (collectionView) -> Void in
            collectionView.performBatchUpdates({ () -> Void in
                // update collection view
                self.requestConfiguration()
            }, completion: { (finished) -> Void in
                // finish infinite scroll animations
                collectionView.finishInfiniteScroll()
            });
        }
        collectionView.infiniteScrollIndicatorStyle = .white
        collectionView?.beginInfiniteScroll(true)
    }
    
    
    // MARK: - Private methods
    fileprivate func setupCollectionView() {
        collectionView.collectionViewLayout = listLayout
        collectionView.register(MovieCell.cellNib, forCellWithReuseIdentifier:MovieCell.id)
    }
    
    // MARK: - Actions
    @IBAction func buttonTapped(_ sender: AnyObject) {
        if !isTransitionAvailable {
            return
        }
        let transitionManager: TransitionManager
        if layoutState == .list {
            layoutState = .grid
            transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: gridLayout, layoutState: layoutState)
        } else {
            layoutState = .list
            transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: listLayout, layoutState: layoutState)
        }
        transitionManager.startInteractiveTransition()
        rotationButton.isSelected = layoutState == .list
        rotationButton.animationDuration = animationDuration
    }
    
    @IBAction func tapRecognized() {
        view.endEditing(true)
    }

    func requestApi(){
        ApiRequest.nowPlaying(parameters: [:], success: { (result) in
            let newItems = result["results"].arrayValue.compactMap({ Movie.init(json: $0) })
            // create new index paths
            let movieCount = self.movies.count
            let (start, end) = (movieCount, newItems.count + movieCount)
            let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
            
            // update data source
            self.movies.append(contentsOf: newItems)
            
            
            self.collectionView?.performBatchUpdates({ () -> Void in
                self.offset += 1
                self.collectionView?.insertItems(at: indexPaths)
            }, completion: { (finished) -> Void in
                //                    completionHandler?()
                SVProgressHUD.dismiss()
            });
        }) { (error) in
            print(error!)
            SVProgressHUD.dismiss()
        }
    }
    
    func requestConfiguration(){
        if(CacheDefault.loadConfig() == nil){
            ApiRequest.configuration(parameters: [:], success: { (result) in
                CacheDefault.setConfig(config: Configuration.init(json: result["images"]))
                self.requestApi()
                print(result["images"])
            }) { (error) in
                print(error!)
            }
        }else{
            requestApi()
        }
        
    }

}



extension ViewController:UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.id, for: indexPath) as! MovieCell
        if layoutState == .grid {
            cell.setupGridLayoutConstraints(1, cellWidth: cell.frame.width)
        } else {
            cell.setupListLayoutConstraints(1, cellWidth: cell.frame.width)
        }
        cell.bind(movies[(indexPath as NSIndexPath).row])
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return customTransitionLayout
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isTransitionAvailable = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isTransitionAvailable = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
}

extension ViewController:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "movieDetail") as! MovieDetailViewController
        vc.movie = movie
        
        present(vc, animated: true, completion: nil)
    }
    
}
