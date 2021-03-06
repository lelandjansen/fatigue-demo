import Foundation

class SmartSuggestions {
    init(forQuestionnaireRoot questionnaireRoot: QuestionnaireItem) {
        self.questionnaireRoot = questionnaireRoot
        self.yesterdayResponse = { () -> QuestionnaireResponse? in
            let calendar = NSCalendar.current
            let history = QuestionnaireResponse.loadResponses().reversed()
            for questionnaireResponse in history {
                if calendar.isDateInYesterday(questionnaireResponse.date! as Date) {
                    return questionnaireResponse
                }
                else if (questionnaireResponse.date! as Date) < calendar.date(byAdding: .day, value: -1, to: Date())! {
                    return nil
                }
            }
            return nil
        }()
    }
    
    let yesterdayResponse: QuestionnaireResponse?
    
    fileprivate let questionnaireRoot: QuestionnaireItem
    
    func makeSmartSuggestion(forQuestion question: Question) -> Question {
        switch question.id {
        case .sleepInPast48Hours:
            return suggestSleepInPast48Hours(forQuestion: question)
        case .timeZoneQuantity:
            return suggestTimeZoneQuantity(forQuestion: question)
        default:
            return question
        }
    }
    
    var dirtyQuestionIds = Set<Questionnaire.QuestionId>()
    
    func suggestSleepInPast48Hours(forQuestion question: Question) -> Question {
        let yesterdaySleep = QuestionnaireDefaults.sleepInPast24Hours
        var todaySleep = QuestionnaireDefaults.sleepInPast24Hours
        var smartQuestion = question
        smartQuestion.details = String()
        let yesterdaySleepSelection = 8
        smartQuestion.details += "Yesterday: \(yesterdaySleepSelection) hrs"
        smartQuestion.details += "\n"
        if let todaySleepSelection = selectionForQuestion(withId: .sleepInPast24Hours) {
            smartQuestion.details += "Today: \(todaySleepSelection)"
            if let hours = UInt(todaySleepSelection) {
                todaySleep = hours
                smartQuestion.details += (hours == 1) ? " hr" : " hrs"
                smartQuestion.options = Array(todaySleep...24).map{String($0)}
            }
        }
        if !dirtyQuestionIds.contains(.sleepInPast48Hours) {
            dirtyQuestionIds.insert(.sleepInPast48Hours)
            smartQuestion.selection = String(describing: yesterdaySleep + todaySleep)
        }
        if let selection = UInt(smartQuestion.selection) {
            if selection < todaySleep {
                smartQuestion.selection = String(describing: todaySleep)
            }
        }
        
        return smartQuestion
    }
    
    func suggestTimeZoneQuantity(forQuestion question: Question) -> Question {
        var smartQuestion = question
        smartQuestion.details = String()
        let yesterdaySelection = 3
        smartQuestion.details += "Yesterday: \(yesterdaySelection)"
        if !dirtyQuestionIds.contains(.timeZoneQuantity) {
            dirtyQuestionIds.insert(.timeZoneQuantity)
            smartQuestion.selection = String(describing: yesterdaySelection)
        }
        return smartQuestion
    }
    
    func selectionForQuestion(withId id: Questionnaire.QuestionId) -> String? {
        var question = questionnaireRoot
        while true {
            if question is Question && (question as! Question).id == id {
                return (question as! Question).selection
            }
            if let nextItem = question.nextItem {
                question.nextItem = nextItem
            }
            else {
                return nil
            }
        }
    }
    
    func yesterdaySelectionForQuestion(withId id: Questionnaire.QuestionId) -> String? {
        guard yesterdayResponse != nil else { return nil }
        for response in yesterdayResponse!.questionResponses! {
            if (response as! QuestionResponse).id == id.rawValue {
                return (response as! QuestionResponse).selection
            }
        }
        return nil
    }
}
