//
//  AchievementService.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 12.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation

protocol AchievementServiceProtocol {
    func calcAchievements(userData: UserData) -> [Achievement]
}

class AchievementService: AchievementServiceProtocol {
    
    func calcAchievements(userData: UserData) -> [Achievement] {
        let daysAchievements = getDaysAchievements(posts: userData.posts)
        let maxValueAchievements = getMaxValueAchievements(current: userData.current)
        let fromRedZoneAchievements = getFromRedZoneAchievements(start: userData.start, current: userData.current)
        let plusOneAchievements = getPlusOneAchievements(posts: userData.posts)
        let roundCountAchievements = getRoundCountAchievements(posts: userData.posts)
        
        let achievements = daysAchievements
            + maxValueAchievements
            + fromRedZoneAchievements
            + plusOneAchievements
            + roundCountAchievements
        let sortedAchievements = achievements.sorted(by: { $0.unlocked && !$1.unlocked })
        return sortedAchievements
    }

    // MARK: — Private methods
    
    private func getDaysAchievements(posts: [Post]) -> [Achievement] {
        let daysInRowTuple = calcMaxCountDaysInRow(from: posts)
        let maxCountDaysInRow = daysInRowTuple.maxDaysInRowAllTime
        let daysInRowLastTime = daysInRowTuple.daysInRowLastTime

        let regularThreeCurrentDays = maxCountDaysInRow >= 3 ? 3 : daysInRowLastTime
        let regularThreeDesc = R.string.localizable.achievementsRegularFewDescription(3, regularThreeCurrentDays, 3)
        let regularThree = Achievement(
            icon: "⚡️",
            title: R.string.localizable.achievementsRegularThreeTitle(),
            description: regularThreeDesc,
            unlocked: maxCountDaysInRow >= 3)
        
        let regularFiveCurrentDays = maxCountDaysInRow >= 5 ? 5 : daysInRowLastTime
        let regularFiveDesc = R.string.localizable.achievementsRegularManyDescription(5, regularFiveCurrentDays, 5)
        let regularFive = Achievement(
            icon: "🖐",
            title: R.string.localizable.achievementsRegularFiveTitle(),
            description: regularFiveDesc,
            unlocked: maxCountDaysInRow >= 5)
        
        let regularSevenCurrentDays = maxCountDaysInRow >= 7 ? 7 : daysInRowLastTime
        let regularSevenDesc = R.string.localizable.achievementsRegularManyDescription(7, regularSevenCurrentDays, 7)
        let regularSeven = Achievement(
            icon: "🤘",
            title: R.string.localizable.achievementsRegularSevenTitle(),
            description: regularSevenDesc,
            unlocked: maxCountDaysInRow >= 7)
        
        let regularTenCurrentDays = maxCountDaysInRow >= 10 ? 10 : daysInRowLastTime
        let regularTenDesc = R.string.localizable.achievementsRegularManyDescription(10, regularTenCurrentDays, 10)
        let regularTen = Achievement(
            icon: "😎",
            title: R.string.localizable.achievementsRegularTenTitle(),
            description: regularTenDesc,
            unlocked: maxCountDaysInRow >= 10)

        return [regularThree, regularFive, regularSeven, regularTen]
    }
    
    private func calcMaxCountDaysInRow(from posts: [Post]) -> (maxDaysInRowAllTime: Int, daysInRowLastTime: Int) {
        let days = posts
            .map { Date(timeIntervalSince1970: Double($0.timestamp ?? 0)) }
            .map { $0.diffInDaysSince1970() }
        
        let daysSet = Set(days).sorted()
        var countDaysInRowArray: [Int] = []
        var daysInRowCounter = 1
        var prevDay = daysSet.first ?? 0
        
        for day in daysSet {
            if day == prevDay {
                continue
            }
            if day - prevDay != 1
                || day == daysSet.last {
                if day - prevDay == 1 {
                    daysInRowCounter += 1
                }
                countDaysInRowArray.append(daysInRowCounter)
                daysInRowCounter = 1
                prevDay = day
                continue
            }
            if day - prevDay == 1 {
                daysInRowCounter += 1
                prevDay = day
            }
        }
        return (countDaysInRowArray.max() ?? 0, countDaysInRowArray.last ?? 0)
    }
    
    private func getMaxValueAchievements(current: SphereMetrics?) -> [Achievement] {
        guard let current = current else { return [] }
        let maxValueSphereRawValues = current.values
            .filter { $0.value == Properties.maxSphereValue }
            .map { $0.key }
        
        guard !maxValueSphereRawValues.isEmpty else {
            return []
        }
        
        let spheres = maxValueSphereRawValues.map { Sphere(rawValue: $0) }
        
        var spheresAchievements: [Achievement] = []
        if spheres.isEmpty {
            spheresAchievements = [
                Achievement(
                    icon: "🏆",
                    title: R.string.localizable.achievementsMaxValueLockTitle(),
                    description: R.string.localizable.achievementsMaxValueLockDescription())
            ]
        } else {
            for sphere in spheres {
                spheresAchievements.append(
                    Achievement(
                        icon: sphere?.icon ?? "🏆",
                        title: R.string.localizable.achievementsMaxValueUnlockTitle(sphere?.name ?? ""),
                        description: R.string.localizable.achievementsMaxValueUnlockDescription(sphere?.name ?? ""),
                        unlocked: true))
            }
        }

        return spheresAchievements
    }
    
    private func getFromRedZoneAchievements(start: SphereMetrics?,
                                            current: SphereMetrics?) -> [Achievement] {
        guard let current = current, let start = start else { return [] }
        let redZoneValue = 3.5
        let redZoneSpheresStart = start.values
            .filter { $0.value < redZoneValue }
            .map { $0.key }
        
        if redZoneSpheresStart.isEmpty {
            return []
        }
        
        var resultSpheres: [String] = []
        
        let notRedZoneSpheresCurrent = current.values
            .filter { $0.value >= redZoneValue }
            .map { $0.key }
        
        for sphere in notRedZoneSpheresCurrent {
            if redZoneSpheresStart.contains(sphere) {
                resultSpheres.append(sphere)
            }
        }
        
        let fromRedZoneSpheres = resultSpheres.map { Sphere(rawValue: $0)?.name ?? "" }
        var byeLooser = Achievement(
            icon: "👻",
            title: R.string.localizable.achievementsLooserTitle(),
            description: R.string.localizable.achievementsLooserLockDescription(),
                                    unlocked: false)
        if !fromRedZoneSpheres.isEmpty {
            let spheresString = fromRedZoneSpheres.joined(separator: ", ")
            byeLooser = Achievement(
                icon: "👻",
                title: R.string.localizable.achievementsLooserTitle(),
                description: R.string.localizable.achievementsLooserUnlockDescription(spheresString),
                unlocked: true)
        }
        
        return [byeLooser]
    }
    
    private func getPlusOneAchievements(posts: [Post]) -> [Achievement] {
        let daysLimit = 5
        let postsCountCondition = 10
        var achievement = Achievement(
            icon: "🚀",
            title: R.string.localizable.achievementsRocketTitle(),
            description: R.string.localizable.achievementsRocketLockDescription(daysLimit))
        
        var fastSphereNames: [String] = []
        for sphere in Sphere.allCases {
            let postDays = posts
                .filter { $0.sphere == sphere }
                .map { Date(timeIntervalSince1970: Double($0.timestamp ?? 0)) }
                .map { $0.diffInDaysSince1970() }
                .sorted()
            
            let daysCount = postDays.count
            if daysCount >= postsCountCondition {
                var firstDayPos = 0
                var lastDayPos = postsCountCondition - 1
                repeat {
                    if postDays[lastDayPos] - postDays[firstDayPos] <= postsCountCondition {
                        fastSphereNames.append(sphere.name)
                        break
                    }
                    lastDayPos += 1
                    firstDayPos += 1
                } while lastDayPos < daysCount
            }
        }
        
        if !fastSphereNames.isEmpty {
            let spheresString = fastSphereNames.joined(separator: ", ")
            let points = postsCountCondition / 10
            let description = R.string.localizable.achievementsRocketUnlockDescription(spheresString, points, daysLimit)
            achievement = Achievement(
                icon: "🚀",
                title: R.string.localizable.achievementsRocketTitle(),
                description: description,
                unlocked: true)
        }
        
        return [achievement]
    }
    
    private func getRoundCountAchievements(posts: [Post]) -> [Achievement] {
        let roundCount = 50
        let multiplier: Int = posts.count / roundCount
        let isUnlocked = multiplier > 0
        let description = isUnlocked
            ? R.string.localizable.achievementsRoundCountUnlockDescription(multiplier * 50)
            : R.string.localizable.achievementsRoundCountLockDescription(roundCount)
        let achievement = Achievement(
            icon: "💯",
            title: R.string.localizable.achievementsRoundCountTitle(),
            description: description,
            unlocked: isUnlocked)
        return [achievement]
    }
}
