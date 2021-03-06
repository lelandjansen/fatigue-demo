import CoreData
import UIKit

extension QuestionnaireResponse {
    static let entityName = "QuestionnaireResponse"
    
    static func saveResponse(forQuestionnaireItems questionnaireItems: [QuestionnaireItem]) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let questionnaireResponse = NSEntityDescription.insertNewObject(forEntityName: QuestionnaireResponse.entityName, into: context) as! QuestionnaireResponse
        questionnaireResponse.date = NSDate()
        
        var riskScore: Int32 = 0
        for questionnaireItem in questionnaireItems {
            if questionnaireItem is Question {
                let question = questionnaireItem as! Question
                let questionResponse = NSEntityDescription.insertNewObject(forEntityName: QuestionResponse.entityName, into: context) as! QuestionResponse
                questionResponse.id = question.id.rawValue
                questionResponse.questionDescription = question.description
                questionResponse.riskScoreContribution = question.riskScoreContribution(question.selection)
                questionResponse.selection = question.selection
                questionnaireResponse.addToQuestionResponses(questionResponse)
                riskScore += question.riskScoreContribution(question.selection)
            }
        }
        questionnaireResponse.riskScore = riskScore
        do {
            try context.save()
        }
        catch let error {
            fatalError("Failed to save questionnaire response: \(error)")
        }
    }
    
    static func loadResponses() -> [QuestionnaireResponse] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<QuestionnaireResponse> = QuestionnaireResponse.fetchRequest()
        do {
            return try context.fetch(request)
        }
        catch let error {
            fatalError("Failed to load questionnaire response: \(error)")
        }
        
    }
    
    static func delete(response: QuestionnaireResponse) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(response)
        do {
            try context.save()
        }
        catch let error {
            fatalError("Failed to save questionnaire response: \(error)")
        }
    }
}
