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
        adBannerView.adUnitID = "ca-app-pub-1456354134093094/1348416479"
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
//      #warning("remove line below for production")
//       GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["4f88f5a0c11bc5368aa61f3d99100517" ]
        adBannerView.load(request)
    }
}
