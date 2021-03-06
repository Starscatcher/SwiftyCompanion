import UIKit
import SwiftyJSON

class GetUserInformation: NSObject {
    
    private var userJson = NSDictionary()
    
    static func getStudent(userJson: NSDictionary) -> Student {
        let student = Student()
        
        student.setImageUrl(imageUrl: getImageUrl(userJson: userJson))
        student.setId(id: getId(userJson: userJson))
        student.setLogin(login: getLogin(userJson: userJson))
        student.setEmail(phone: getEmail(userJson: userJson))
        student.setWallet(wallet: getWallet(userJson: userJson))
        student.setCorrectionPoints(correctionPoints: getCorrectionPoints(userJson: userJson))
        student.setLocation(location: getLocation(userJson: userJson))
        student.setLevel(level: getLevel(userJson: userJson))
        student.setSkills(skills: getSkills(userJson: userJson))
        student.setProjects(projects: getProjects(userJson: userJson))
        return student
    }
    
    static func getCoalitionName(coalitionData: [[String:Any]]) -> String {
        var coalitionName = String()
        
        for elem in coalitionData {
            if let name = elem["name"] as? String {
                coalitionName = name
            }
        }
        return coalitionName
    }
    
    static func getCoalitionUrl(coalitionData: [[String:Any]]) -> String {
        var coalitionUrl = String()
        
        for elem in coalitionData {
            if let coverUrl = elem["cover_url"] as? String {
                coalitionUrl = coverUrl
            }
        }
        return coalitionUrl
    }
    
    private static func getImageUrl(userJson: NSDictionary) -> String {
        var imageUrl = String()
        
        if let imgUrl = userJson["image_url"] as? String {
                imageUrl = imgUrl
        }
        return imageUrl
    }
    
    private static func getLogin(userJson: NSDictionary) -> String {
        if let login = userJson["login"] as? String {
            return login
        }
        return ""
    }
    
    private static func getId(userJson: NSDictionary) -> Int {
        if let id = userJson["id"] as? Int {
            return id
        }
        return 0
    }
    
    private static func getEmail(userJson: NSDictionary) -> String {
        if let phone = userJson["email"] as? String {
            return phone
        }
        return ""
    }
    
    private static func getWallet(userJson: NSDictionary) -> Int{
        if let wallet = userJson["wallet"] as? Int {
            return wallet
        }
        return 0
    }
    
    private static func getCorrectionPoints(userJson: NSDictionary) -> Int {
        if let correctionPoints = userJson["correction_point"] as? Int {
            return correctionPoints
        }
        return 0
    }
    
    private static func getLocation(userJson: NSDictionary) -> String {
        if let location = userJson["location"] as? String {
            return location
        } else {
            return "Unavailable"
        }
    }
    
    private static func getLevel(userJson: NSDictionary) -> Double {
        if let cursus = userJson["cursus_users"] as? [[String:Any]] {
            if let level = cursus[0]["level"] as? Double {
                return level
            }
        }
        return 0
    }
    
    private static func getSkills(userJson: NSDictionary) -> [Skill] {
        var skills = [Skill]()
        
        if let cursus = userJson["cursus_users"] as? [[String:Any]] {
            if let skillsArr = cursus[0]["skills"] as? [[String:Any]] {
                for elem in skillsArr {
                    if let name = elem["name"] as? String {
                        if let level = elem["level"] as? Double {
                            skills.append(Skill(name: name, level: level))
                        }
                    }
                }
            }
        }
        return skills
    }
    
    private static func getProjectName(projectDictionary: [String:Any]) -> String? {
        if let projectName = projectDictionary["name"] as? String {
            return projectName
        }
        return nil
    }
    
    private static func getProjectSlug(projectDictionary: [String:Any]) -> String? {
        if let projectSlug = projectDictionary["slug"] as? String {
            return projectSlug
        }
        return nil
    }
    
    private static func getProjectId(projectDictionary: [String:Any]) -> Int? {
        var projectId: Int? = nil
        
        if let id = projectDictionary["id"] as? Int {
            projectId = id
        }
        return projectId
    }
    
    private static func getProjectParentId(projectDictionary: [String:Any]) -> Int? {
        var projectParentId: Int? = nil
        
        if let parentId = projectDictionary["parent_id"] as? Int {
            projectParentId = parentId
        }
        return projectParentId
    }
    
    private static func getProjectStatus(projectDictionary: [String : Any]) -> String? {
        var projectStatus: String? = nil
        
        if let status = projectDictionary["status"] as? String {
            projectStatus = status
        }
        return projectStatus
    }
    
    private static func getProjectValidated(projectDictionary: [String : Any]) -> Bool {
        var isProjectValidated = false
        
        if let validated = projectDictionary["validated?"] as? Bool {
            isProjectValidated = validated
        }
        return isProjectValidated
    }
    
    private static func getProjectFinalMark(projectDictionary: [String : Any]) -> Int {
        var projectFinalMark = Int()
        
        if let finalMark = projectDictionary["final_mark"] as? Int {
            projectFinalMark = finalMark
        }
        return projectFinalMark
    }
    
    private static func getProjectData(projectDictionary: [String : Any]) -> String {
        var projectData = String()
        
        if let markedAt = projectDictionary["marked_at"] as? String {
            projectData = markedAt
        }
        return projectData
    }
    
    private static func initializeProject(projectDictionary: [String : Any]) -> Project {
        var name = String()
        var slug = String()
        var id = Int()
        var parentId: Int?
        let status = getProjectStatus(projectDictionary: projectDictionary)
        let validated = getProjectValidated(projectDictionary: projectDictionary)
        let finalMark = getProjectFinalMark(projectDictionary: projectDictionary)
        let data = getProjectData(projectDictionary: projectDictionary)
        let subprojects = [Project]()
        var cursusIds = Int()
        
        if let projectInf = projectDictionary["project"] as? [String:Any] {
            if let nameCheck = getProjectName(projectDictionary: projectInf) {
                name = nameCheck
            }
            if let slugCheck = getProjectSlug(projectDictionary: projectInf) {
                slug = slugCheck
            }
            if let idCheck = getProjectId(projectDictionary: projectInf) {
                id = idCheck
            }
            if let parentIdCheck = getProjectParentId(projectDictionary: projectInf) {
                parentId = parentIdCheck
            }
        }
        
        if let value = projectDictionary["cursus_ids"] as? [Int] {
            cursusIds = value[0]
            if (cursusIds == 4 && parentId != 167) {
                parentId = 1
            }
        }
        
        return Project(name: name, slug: slug, id: id, parentId: parentId, status: status!, validated: validated, finalMark: finalMark, cursusIds: cursusIds, subprojects: subprojects, data: data, opened: false)
    }
    
    private static func searchParrentIndex(parrentId: Int, projects: [Project]) -> Int? {
        for (index, elem) in projects.enumerated() {
            if elem.id == parrentId {
                return index
            }
        }
        return nil
    }
    
    private static func getCPiscineFinalLevel(userJson: NSDictionary) -> Double {
        var piscineCFinalLevel = Double()
        
        if let cursus = userJson["cursus_users"] as? [[String:Any]] {
            if (cursus.count > 1) {
                if let level = cursus[1]["level"] as? Double {
                    piscineCFinalLevel = level
                }
            }
        }
        return piscineCFinalLevel
    }
    
    private static func createCPoolProject(userJson: NSDictionary) -> Project {
        let name = "Piscine C"
        let slug = String(getCPiscineFinalLevel(userJson: userJson))
        let id = 1
        let parentId: Int? = nil
        let status = "finished"
        let validated = true
        let finalMark = 0
        let cursusIds = 4
        let subprojects = [Project]()
        let data = "0"
        
        return Project(name: name, slug: slug, id: id, parentId: parentId, status: status, validated: validated, finalMark: finalMark, cursusIds: cursusIds, subprojects: subprojects, data: data, opened: false)
    }
    
    private static func checkRestProjects(projects: inout [Project], restProjects: inout [Project]) {
        for elem in restProjects {
            if let parentId = elem.parentId {
                if let parentIndex = searchParrentIndex(parrentId: parentId, projects: projects) {
                    projects[parentIndex].subprojects.append(elem)
                }
            }
        }
        restProjects.removeAll()
    }
    
    private static func sortSubprojects(projects: inout [Project]) {
        for (index, project) in projects.enumerated() {
            if !project.subprojects.isEmpty {
                projects[index].subprojects = project.subprojects.sorted(by: { $0.data < $1.data })
            }
        }
    }
    
    private static func getProjects(userJson: NSDictionary) -> [Project] {
        var projects = [Project]()
        var restProjects = [Project]()
        if let userProjects = userJson["projects_users"] as? [[String:Any]] {
            projects.append(createCPoolProject(userJson: userJson))
            for elem in userProjects {
                let newProject = initializeProject(projectDictionary: elem)
                if (newProject.parentId != 167) {
                    if let parentId = newProject.parentId {
                        if let parentIndex = searchParrentIndex(parrentId: parentId, projects: projects) {
                            projects[parentIndex].subprojects.append(newProject)
                        }
                        else {
                            restProjects.append(newProject)
                        }
                    }
                    else {
                        projects.append(newProject)
                    }
                }
            }
        }
        checkRestProjects(projects: &projects, restProjects: &restProjects)
        sortSubprojects(projects: &projects)
        return projects
    }
}
