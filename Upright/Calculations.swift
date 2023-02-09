//
//  calculations.swift
//  Upright
//
//  Created by USS - Software Dev on 10/25/22.
//

import Foundation


class Calculations {
    
    private var patient_id: Int?
    private var prop_c: Double?
    private var prop_t: Double?
    private var prop_l: Double?
    private var norm_c: Double?
    private var norm_t: Double?
    private var norm_l: Double?
    private var lean: Double?
    
    private var surveyScore: Int! = 0
    private var avgSurveyScore: Int!
    
    private var deltaArray: [PatientScan]!
    private var avgDeltaArray: [PatientScan]!
   
    
    init(patient_id: Int, prop_c: Double, prop_t: Double, prop_l: Double, norm_c: Double, norm_t: Double, norm_l: Double, lean: Double){
        self.patient_id = patient_id
        self.prop_c = prop_c
        self.prop_t = prop_t
        self.prop_l = prop_l
        self.norm_c = norm_c
        self.norm_t = norm_t
        self.norm_l = norm_l
        self.lean = lean
        self.deltaArray = []
        //self.avgDeltaArray = []
       
        sqlQuerySurveyScore()
        sqlQueryDeltaScore()
          
    }
    
    init(){
//        self.avgDeltaArray = []
//        sqlQueryAvgDelta()
    }
    
    func getVsiScore()->Int{
        var pt = 0.0
        var pl = 0.0
        var absPC = abs(0.25 - prop_c!) * 100
        
        print(absPC)
        
        if((self.prop_t! * 100) >= 45){
            pt = (self.prop_t! * 100)
        }else{
            pt = 45
        }
        
        let scorePT = pt - 45
        
        print(scorePT)
        
        if((self.prop_l! * 100) <= 30){
            pl = (self.prop_l! * 100)
        }else{
            pl = 30
        }
        
        let scorePL = 30 - pl
        
        print(scorePL)
        
        let sumD = absoluteNormality(n_c: norm_c!, n_t: norm_t!, n_l: norm_l!)
        
        print(sumD)
        
        return Int(absPC + scorePT + scorePL + sumD + self.lean!)
    }
    
    private func siScore(lean: Double, sumProportion: Double, sumNormality: Double ) -> Double {
        return (abs(lean * lean)) + sumProportion + sumNormality
    }
    
    private func absoluteProportion(p_c: Double, p_t: Double, p_l: Double) -> Double{
        let absPC = abs(0.20 - p_c) * 100
        let absPT = abs(0.50 - p_t) * 100
        let absPL = abs(0.30 - p_l) * 100
        return absPC + absPT + absPL
    }
    
    private func absoluteNormality(n_c: Double, n_t: Double, n_l: Double) -> Double {
        let absNC = abs(0.12 - n_c) * 100
        let absNT = abs(0.12 - n_t) * 100
        let absNL = abs(0.12 - n_l) * 100
        return absNC + absNT + absNL
    }
    
    private func uprightlyScore(s_i_Score: Int, surveyScore: Int) -> Int {
        let siScore = (s_i_Score > 100) ? 100 : s_i_Score
        return (100 - siScore + surveyScore) / 2
    }
    
    // Delta Score is first and last uprightlyscore
    
    private func deltaScore(firstScore: Double, currentScore: Double) -> Double {
        let score = abs(currentScore - firstScore)
        return score
    }
    
    private func sqlQueryDeltaScore(){
        
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text =  "SELECT * FROM scans WHERE id = (SELECT MAX(id) FROM scans WHERE patient_id = \(self.patient_id!) AND lean IS NOT NULL) UNION ALL SELECT * FROM scans WHERE id = (SELECT MIN(id) FROM scans WHERE patient_id = \(self.patient_id!) AND lean IS NOT NULL)"
            defer {db.statment?.close()}
            
            let cursor = db.execute(text: text)
            
            defer {cursor.close()}
            
            for (row) in cursor {
                
                let columns = try row.get().columns
                var prop_C = try columns[2].double()
                var prop_T = try columns[3].double()
                var prop_L = try columns[4].double()
                var dl_C = try columns[5].double()
                var dl_T  = try columns[6].double()
                var dl_L = try columns[7].double()
                let id = try columns[0].int()
                let patient_id = try columns[1].int()
                let time_stamp = try columns[8].string()
                var lean = try columns[9].double()
                let height = try columns[13].double()
                let pic_date = try columns[8].string()
                
                
                self.deltaArray += createArray(id: id, prop_C: prop_C, prop_T: prop_T, prop_L: prop_L, dl_C: dl_C, dl_T: dl_T, dl_L: dl_L, time_stamp: time_stamp, lean: lean, height: height, pic_date: pic_date)
            }
            
        } catch {
            print(error)
        }
        
    }
    
    private func sqlQuerySurveyScore(){
        
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            
            let text = "SELECT score FROM survey WHERE id = (SELECT MAX(id) FROM survey WHERE patient_id = \(self.patient_id!))"
            
            defer {db.statment?.close()}
                         let cursor = db.execute(text: text)
            
            defer {cursor.close()}
            
            for (row) in cursor {
                let columns = try row.get().columns
                let score = try columns[0].int()
                self.surveyScore = score
            }
        } catch {
            print(error)
        }
        
    }
    
    private func sqlQueryAvgSurveyScore(){
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            
            let text = "SELECT AVG(score) FROM survey RIGHT JOIN patient ON survey.patient_id = patient.id WHERE patient.provider_id = \(Organization.id!)"
            
            defer {db.statment?.close()}
                         let cursor = db.execute(text: text)
            
            defer {cursor.close()}
            
            for (row) in cursor {
                let columns = try row.get().columns
                let score = try columns[0].int()
                self.avgSurveyScore = score
            }
        } catch {
            print(error)
        }
            }
    
    private func sqlQueryAvgDelta(){
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            
            let text = "SELECT AVG(proportion_c), AVG(proportion_t), AVG(proportion_l), AVG(dl_c), AVG(dl_t), AVG(dl_l), AVG(lean) FROM scans WHERE id = (SELECT MAX(id) FROM scans WHERE organization_id = \(Organization.id!) AND lean IS NOT NULL) UNION ALL SELECT AVG(proportion_c), AVG(proportion_t), AVG(proportion_l), AVG(dl_c), AVG(dl_t), AVG(dl_l), AVG(lean)  FROM scans WHERE id = (SELECT MIN(id) FROM scans WHERE organization_id = \(Organization.id!) AND lean IS NOT NULL)"
            
            defer {db.statment?.close()}
            
            let cursor = db.execute(text: text)
            
            defer {cursor.close()}
            
            for (row) in cursor {
                let columns = try row.get().columns
                var prop_C = try columns[0].double()
                var prop_T = try columns[1].double()
                var prop_L = try columns[2].double()
                var dl_C = try columns[3].double()
                var dl_T  = try columns[4].double()
                var dl_L = try columns[5].double()
                let id = 0
                let patient_id = try columns[1].int() ?? 0
                let time_stamp = try columns[8].string() ?? "2022/01/01"
                var lean = try columns[6].double()
                let height = try columns[13].double() ?? 0
                let pic_date = try columns[8].string() ?? ""
                
                
                self.avgDeltaArray += createArray(id: id, prop_C: prop_C, prop_T: prop_T, prop_L: prop_L, dl_C: dl_C, dl_T: dl_T, dl_L: dl_L, time_stamp: time_stamp, lean: lean, height: height, pic_date: pic_date)
            }
        } catch {
            print(error)
        }
        
    }
    
    private func createArray(id: Int, prop_C: Double, prop_T: Double, prop_L: Double, dl_C: Double, dl_T: Double, dl_L: Double, time_stamp: String, lean: Double, height: Double, pic_date: String) -> [PatientScan] {
        var tempList: [PatientScan] = []
        let list = PatientScan(first_name: Patient.first_name!, last_name: Patient.last_name!, id: id, time_stamp: time_stamp, prop_C: prop_C, prop_T: prop_T, prop_L: prop_L, dl_C: dl_C, dl_T: dl_T, dl_L: dl_L, lean: lean, height: height, pic_date: pic_date)
        tempList.append(list)

        return tempList
    }
    
    func getSiScore() -> Int {
        let absProp = absoluteProportion(p_c: self.prop_c!, p_t: self.prop_t!, p_l: self.prop_l!)
        let absNorm = absoluteNormality(n_c: self.norm_c!, n_t: self.norm_t!, n_l: self.norm_l!)
        let lean = self.lean
        return Int(siScore(lean: lean!, sumProportion: absProp, sumNormality: absNorm))
    }
    
    func getUprightlyScore() -> Int {
        let siScore = getSiScore()
        return Int(uprightlyScore(s_i_Score: siScore, surveyScore: surveyScore))
    }
    
    func getDeltaScore() -> Double {
        let currentProp = absoluteProportion(p_c: deltaArray[0].prop_C, p_t: deltaArray[0].prop_T, p_l: deltaArray[0].prop_L)
        let currentNorm = absoluteNormality(n_c: deltaArray[0].dl_C, n_t: deltaArray[0].dl_T, n_l: deltaArray[0].dl_L)
        
        let firstProp = absoluteProportion(p_c: deltaArray[1].prop_C, p_t: deltaArray[1].prop_T, p_l: deltaArray[1].prop_L)
        let firstNorm = absoluteNormality(n_c: deltaArray[1].dl_C, n_t: deltaArray[1].dl_T, n_l: deltaArray[1].dl_L)
        
        let currentSiScore = siScore(lean: deltaArray[0].lean, sumProportion: currentProp, sumNormality: currentNorm)
        let firstSiScore = siScore(lean: deltaArray[1].lean, sumProportion: firstProp, sumNormality: firstNorm)
        
        let surveyScore = self.surveyScore ?? 0
        
        let currentUprightScore = uprightlyScore(s_i_Score: Int(currentSiScore), surveyScore: surveyScore)
        let firstUprightScore = uprightlyScore(s_i_Score: Int(firstSiScore), surveyScore: surveyScore)
        
        return deltaScore(firstScore: Double(firstUprightScore), currentScore: Double(currentUprightScore))
    }
    
    
    
    func getTotalAvgDelta() -> Double{
        let avgCurrentProp = absoluteProportion(p_c: avgDeltaArray[0].prop_C, p_t: avgDeltaArray[0].prop_T, p_l: avgDeltaArray[0].prop_L)
        let avgCurrentNorm = absoluteNormality(n_c: avgDeltaArray[0].dl_C, n_t: avgDeltaArray[0].dl_T, n_l: avgDeltaArray[0].dl_L)
        
        let avgFirstProp = absoluteProportion(p_c: avgDeltaArray[1].prop_C, p_t: avgDeltaArray[1].prop_T, p_l: avgDeltaArray[1].prop_L)
        let avgFirstNorm = absoluteNormality(n_c: avgDeltaArray[1].dl_C, n_t: avgDeltaArray[1].dl_T, n_l: avgDeltaArray[1].dl_L)
        
        let avgCurrentSiScore = siScore(lean: avgDeltaArray[0].lean, sumProportion: avgCurrentProp, sumNormality: avgCurrentNorm)
        let avgFirstSiScore = siScore(lean: avgDeltaArray[1].lean, sumProportion: avgFirstProp, sumNormality: avgFirstNorm)
        
        let avgSurveyScore = self.avgSurveyScore ?? 0
        
        let avgCurrentUprightScore = uprightlyScore(s_i_Score: Int(avgCurrentSiScore), surveyScore: avgSurveyScore)
        let avgFirstUprightScore = uprightlyScore(s_i_Score: Int(avgFirstSiScore), surveyScore: avgSurveyScore)
        
        return deltaScore(firstScore: Double(avgFirstUprightScore), currentScore: Double(avgCurrentUprightScore))    }

}
