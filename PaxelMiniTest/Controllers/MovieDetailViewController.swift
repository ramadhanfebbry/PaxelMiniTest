//
//  MoviewDetailViewController.swift
//  PaxelMiniTest
//
//  Created by Febbry Ramadhan on 12/22/18.
//  Copyright © 2018 Febbry Ramadhan. All rights reserved.
//

import UIKit
import ImageSlideshow
import Cosmos
import DisplaySwitcher
import SVProgressHUD

class MovieDetailViewController: UIViewController {
    var movie: Movie!
    @IBOutlet weak var imagesView: ImageSlideshow!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescLabel: UILabel!
    @IBOutlet weak var movieReleaseLabel: UILabel!
    @IBOutlet weak var movieVoteView: CosmosView!
    @IBOutlet weak var collectionView: UICollectionView!
    private let listLayoutStaticCellHeight: CGFloat = 80
    private let gridLayoutStaticCellHeight: CGFloat = 165
    fileprivate lazy var listLayout = DisplaySwitchLayout(staticCellHeight: listLayoutStaticCellHeight, nextLayoutStaticCellHeight: gridLayoutStaticCellHeight, layoutState: .list)
    fileprivate lazy var gridLayout = DisplaySwitchLayout(staticCellHeight: gridLayoutStaticCellHeight, nextLayoutStaticCellHeight: listLayoutStaticCellHeight, layoutState: .grid)
    fileprivate var layoutState: LayoutState = .list
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        let indicator = DefaultActivityIndicator()
        indicator.color = .white
        imagesView.activityIndicator = indicator
        imagesView.contentScaleMode = .scaleAspectFit
        imagesView.pageIndicator = nil
        movieVoteView.rating = Double(movie.vote_average)
        movieReleaseLabel.text = "Release Date: \(movie.release_date)"
        movieTitleLabel.text = movie.title
        movieDescLabel.text = movie.overview
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupCollectionView()
        
        
        requestImages()
    }
    
    // MARK: - Private methods
    fileprivate func setupCollectionView() {
        collectionView.collectionViewLayout = gridLayout
        collectionView.register(MovieCell.cellNib, forCellWithReuseIdentifier:MovieCell.id)
    }
    
    
    func requestImages(){
        SVProgressHUD.show()
        ApiRequest.movieImages(movieId: movie.id, parameters: [:], success: { (result) in
            
            let posters = result["posters"].arrayValue.compactMap({ Poster(json: $0) })
            
            var source = [InputSource]()
            posters.prefix(4).forEach({
                source.append(AlamofireSource(urlString: $0.image_url!)! )
            })
            self.imagesView.setImageInputs(source)
            self.requestRelated()
        }) { (error) in
            self.requestRelated()
        }
    }
    
    
    func requestRelated(){
        ApiRequest.relatedMovies(movieId: movie.id, parameters: [:], success: { (result) in
            self.movies = result["results"].arrayValue.compactMap({ Movie.init(json: $0) })
            self.collectionView.reloadData()
            SVProgressHUD.dismiss()
        }) { (error) in
            print("error response \(error ?? "")")
            SVProgressHUD.dismiss()
            
        }
    }
    
    @IBAction func backPressed(){
        dismiss(animated: true, completion: nil)
    }
    
}


extension MovieDetailViewController:UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        
        return CGSize(width: width/2, height: width/2)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.id, for: indexPath) as! MovieCell
        cell.setupGridLayoutConstraints(1, cellWidth: cell.frame.width)
        cell.bind(movies[(indexPath as NSIndexPath).row])
        
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
}

extension MovieDetailViewController:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "movieDetail") as! MovieDetailViewController
        vc.movie = movie
        
        present(vc, animated: true, completion: nil)
    }

}
