//
//  TipStorage.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 01.11.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit

struct TipEntity {
    let id: Int
    let tip: Tip
}

struct Tip {
    let title: String
    let text: String
}

class TipStorage {
    
    var tipEntities: [TipEntity] {
        let ids: [Int] = Array(0...tipsRaw.count - 1)
        return ids.map {
            TipEntity(id: $0, tip: self.tipsRaw[$0])
        }
    }

    var currentTip: TipEntity {
        return self.tipEntities[currentTipId]
    }

    var currentTipId: Int {
        let days = Date().diffInDaysSince1970()
        return days % tipsRaw.count
    }

    let backgroundNames = [
        R.image.tip.darkBg.darkBg1.name,
        R.image.tip.darkBg.darkBg2.name,
        R.image.tip.darkBg.darkBg3.name,
        R.image.tip.darkBg.darkBg4.name,
        R.image.tip.darkBg.darkBg5.name,
        R.image.tip.darkBg.darkBg6.name,
        R.image.tip.darkBg.darkBg7.name,
        R.image.tip.darkBg.darkBg8.name,
        R.image.tip.darkBg.darkBg9.name,
        R.image.tip.darkBg.darkBg10.name,
        R.image.tip.darkBg.darkBg11.name,
        R.image.tip.darkBg.darkBg12.name,
        R.image.tip.darkBg.darkBg13.name,
        R.image.tip.darkBg.darkBg14.name,
        R.image.tip.darkBg.darkBg15.name,
        R.image.tip.darkBg.darkBg16.name,
        R.image.tip.darkBg.darkBg17.name,
        R.image.tip.darkBg.darkBg18.name,
        R.image.tip.darkBg.darkBg19.name,
        R.image.tip.darkBg.darkBg20.name,
        R.image.tip.darkBg.darkBg21.name,
        R.image.tip.darkBg.darkBg22.name
    ]

    func index(for tipId: Int) -> Int {
        return tipId % backgroundNames.count
    }

    func image(for tipId: Int) -> UIImage? {
        let imageIndex = index(for: tipId)
        return UIImage(named: self.backgroundNames[imageIndex])
    }

    private let tipsRaw: [Tip] = [
        Tip(title: R.string.localizable.tipTitle1(),
            text: R.string.localizable.tipText1()),
        Tip(title: R.string.localizable.tipTitle2(),
            text: R.string.localizable.tipText2()),
        Tip(title: R.string.localizable.tipTitle3(),
            text: R.string.localizable.tipText3()),
        Tip(title: R.string.localizable.tipTitle4(),
            text: R.string.localizable.tipText4()),
        Tip(title: R.string.localizable.tipTitle5(),
            text: R.string.localizable.tipText5()),
        Tip(title: R.string.localizable.tipTitle6(),
            text: R.string.localizable.tipText6()),
        Tip(title: R.string.localizable.tipTitle7(),
            text: R.string.localizable.tipText7()),
        Tip(title: R.string.localizable.tipTitle8(),
            text: R.string.localizable.tipText8()),
        Tip(title: R.string.localizable.tipTitle9(),
            text: R.string.localizable.tipText9()),
        Tip(title: R.string.localizable.tipTitle10(),
            text: R.string.localizable.tipText10()),
        Tip(title: R.string.localizable.tipTitle11(),
            text: R.string.localizable.tipText11()),
        Tip(title: R.string.localizable.tipTitle12(),
            text: R.string.localizable.tipText12()),
        Tip(title: R.string.localizable.tipTitle13(),
            text: R.string.localizable.tipText13()),
        Tip(title: R.string.localizable.tipTitle14(),
            text: R.string.localizable.tipText14()),
        Tip(title: R.string.localizable.tipTitle15(),
            text: R.string.localizable.tipText15()),
        Tip(title: R.string.localizable.tipTitle16(),
            text: R.string.localizable.tipText16()),
        Tip(title: R.string.localizable.tipTitle17(),
            text: R.string.localizable.tipText17()),
        Tip(title: R.string.localizable.tipTitle18(),
            text: R.string.localizable.tipText18()),
        Tip(title: R.string.localizable.tipTitle19(),
            text: R.string.localizable.tipText19()),
        Tip(title: R.string.localizable.tipTitle20(),
            text: R.string.localizable.tipText20()),
        Tip(title: R.string.localizable.tipTitle21(),
            text: R.string.localizable.tipText21()),
        Tip(title: R.string.localizable.tipTitle22(),
            text: R.string.localizable.tipText22()),
        Tip(title: R.string.localizable.tipTitle23(),
            text: R.string.localizable.tipText23()),
        Tip(title: R.string.localizable.tipTitle24(),
            text: R.string.localizable.tipText24()),
        Tip(title: R.string.localizable.tipTitle25(),
            text: R.string.localizable.tipText25()),
        Tip(title: R.string.localizable.tipTitle26(),
            text: R.string.localizable.tipText26()),
        Tip(title: R.string.localizable.tipTitle27(),
            text: R.string.localizable.tipText27()),
        Tip(title: R.string.localizable.tipTitle28(),
            text: R.string.localizable.tipText28()),
        Tip(title: R.string.localizable.tipTitle29(),
            text: R.string.localizable.tipText29()),
        Tip(title: R.string.localizable.tipTitle30(),
            text: R.string.localizable.tipText30()),
        Tip(title: R.string.localizable.tipTitle31(),
            text: R.string.localizable.tipText31()),
        Tip(title: R.string.localizable.tipTitle32(),
            text: R.string.localizable.tipText32()),
        Tip(title: R.string.localizable.tipTitle33(),
            text: R.string.localizable.tipText33()),
        Tip(title: R.string.localizable.tipTitle34(),
            text: R.string.localizable.tipText34()),
        Tip(title: R.string.localizable.tipTitle35(),
            text: R.string.localizable.tipText35()),
        Tip(title: R.string.localizable.tipTitle36(),
            text: R.string.localizable.tipText36()),
        Tip(title: R.string.localizable.tipTitle37(),
            text: R.string.localizable.tipText37()),
        Tip(title: R.string.localizable.tipTitle38(),
            text: R.string.localizable.tipText38()),
        Tip(title: R.string.localizable.tipTitle39(),
            text: R.string.localizable.tipText39()),
        Tip(title: R.string.localizable.tipTitle40(),
            text: R.string.localizable.tipText40()),
        Tip(title: R.string.localizable.tipTitle41(),
            text: R.string.localizable.tipText41()),
        Tip(title: R.string.localizable.tipTitle42(),
            text: R.string.localizable.tipText42()),
        Tip(title: R.string.localizable.tipTitle43(),
            text: R.string.localizable.tipText43()),
        Tip(title: R.string.localizable.tipTitle44(),
            text: R.string.localizable.tipText44()),
        Tip(title: R.string.localizable.tipTitle45(),
            text: R.string.localizable.tipText45()),
        Tip(title: R.string.localizable.tipTitle46(),
            text: R.string.localizable.tipText46()),
        Tip(title: R.string.localizable.tipTitle47(),
            text: R.string.localizable.tipText47()),
        Tip(title: R.string.localizable.tipTitle48(),
            text: R.string.localizable.tipText48()),
        Tip(title: R.string.localizable.tipTitle49(),
            text: R.string.localizable.tipText49()),
        Tip(title: R.string.localizable.tipTitle50(),
            text: R.string.localizable.tipText50()),
        Tip(title: R.string.localizable.tipTitle51(),
            text: R.string.localizable.tipText51()),
        Tip(title: R.string.localizable.tipTitle52(),
            text: R.string.localizable.tipText52()),
        Tip(title: R.string.localizable.tipTitle53(),
            text: R.string.localizable.tipText53()),
        Tip(title: R.string.localizable.tipTitle54(),
            text: R.string.localizable.tipText54()),
        Tip(title: R.string.localizable.tipTitle55(),
            text: R.string.localizable.tipText55()),
        Tip(title: R.string.localizable.tipTitle56(),
            text: R.string.localizable.tipText56()),
        Tip(title: R.string.localizable.tipTitle57(),
            text: R.string.localizable.tipText57()),
        Tip(title: R.string.localizable.tipTitle58(),
            text: R.string.localizable.tipText58()),
        Tip(title: R.string.localizable.tipTitle59(),
            text: R.string.localizable.tipText59()),
        Tip(title: R.string.localizable.tipTitle60(),
            text: R.string.localizable.tipText60()),
        Tip(title: R.string.localizable.tipTitle61(),
            text: R.string.localizable.tipText61()),
        Tip(title: R.string.localizable.tipTitle62(),
            text: R.string.localizable.tipText62()),
        Tip(title: R.string.localizable.tipTitle63(),
            text: R.string.localizable.tipText63()),
        Tip(title: R.string.localizable.tipTitle64(),
            text: R.string.localizable.tipText64()),
        Tip(title: R.string.localizable.tipTitle65(),
            text: R.string.localizable.tipText65()),
        Tip(title: R.string.localizable.tipTitle66(),
            text: R.string.localizable.tipText66()),
        Tip(title: R.string.localizable.tipTitle67(),
            text: R.string.localizable.tipText67()),
        Tip(title: R.string.localizable.tipTitle68(),
            text: R.string.localizable.tipText68()),
        Tip(title: R.string.localizable.tipTitle69(),
            text: R.string.localizable.tipText69()),
        Tip(title: R.string.localizable.tipTitle70(),
            text: R.string.localizable.tipText70()),
        Tip(title: R.string.localizable.tipTitle71(),
            text: R.string.localizable.tipText71()),
        Tip(title: R.string.localizable.tipTitle72(),
            text: R.string.localizable.tipText72()),
        Tip(title: R.string.localizable.tipTitle73(),
            text: R.string.localizable.tipText73()),
        Tip(title: R.string.localizable.tipTitle74(),
            text: R.string.localizable.tipText74()),
        Tip(title: R.string.localizable.tipTitle75(),
            text: R.string.localizable.tipText75()),
        Tip(title: R.string.localizable.tipTitle76(),
            text: R.string.localizable.tipText76()),
        Tip(title: R.string.localizable.tipTitle77(),
            text: R.string.localizable.tipText77()),
        Tip(title: R.string.localizable.tipTitle78(),
            text: R.string.localizable.tipText78()),
        Tip(title: R.string.localizable.tipTitle79(),
            text: R.string.localizable.tipText79()),
        Tip(title: R.string.localizable.tipTitle80(),
            text: R.string.localizable.tipText80()),
        Tip(title: R.string.localizable.tipTitle81(),
            text: R.string.localizable.tipText81()),
        Tip(title: R.string.localizable.tipTitle82(),
            text: R.string.localizable.tipText82()),
        Tip(title: R.string.localizable.tipTitle83(),
            text: R.string.localizable.tipText83()),
        Tip(title: R.string.localizable.tipTitle84(),
            text: R.string.localizable.tipText84()),
        Tip(title: R.string.localizable.tipTitle85(),
            text: R.string.localizable.tipText85()),
        Tip(title: R.string.localizable.tipTitle86(),
            text: R.string.localizable.tipText86()),
        Tip(title: R.string.localizable.tipTitle87(),
            text: R.string.localizable.tipText87())
    ]
}
