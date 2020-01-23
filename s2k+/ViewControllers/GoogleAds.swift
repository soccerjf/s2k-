//
//  GoogleAds.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-23.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import Foundation
import GoogleMobileAds

class GoogleAds: NSObject, GADBannerViewDelegate {

    unowned var sourceTableViewController: UITableViewController
    var adBannerView: GADBannerView

    init(sourceTableViewController: UITableViewController) {
        self.sourceTableViewController = sourceTableViewController
        adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        super.init()
        adBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        adBannerView.delegate = self
        adBannerView.rootViewController = sourceTableViewController
    }

    // MARK:- Google Admob

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        // Reposition the banner ad to create a slide up effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform

        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity
            self.sourceTableViewController.tableView.tableHeaderView = bannerView
        }
    }

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        fatalError("\(error)")
    }

    func loadAdMob() {
        let request = GADRequest()
        request.testDevices = [(kGADSimulatorID as! String)]
        adBannerView.load(request)
    }
}
