import Foundation

let featureMap: [String: () -> ()] = [
    "1": addStudent,
    "2": removeStudent,
    "3": updateScore,
    "4": removeScore,
    "5": viewScore,
    "X": exitApp,
]

let scoreMap: [String: Double] = [
    "A+": 4.5, "A": 4, "B+": 3.5, "B": 3, "C+": 2.5, "C": 2, "D+": 1.5, "D": 1, "F": 0,
]

var studentMap = [String: [(subject: String, score: String)]]()

func studentIsExist(_ name: String) -> Bool {
    return studentMap[name] != nil
}

func addStudent()  {
    print("추가할 학생의 이름을 입력해주세요")
    if let name = inputData() {
        if studentIsExist(name) {
            print("\(name)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
        } else {
            studentMap[name] = []
            print("\(name) 학생을 추가했습니다.")
        }
    }
}

func removeStudent() {
    print("삭제할 학생의 이름을 입력해주세요")
    if let name = inputData() {
        if studentIsExist(name) {
            studentMap[name] = nil
            print("\(name) 학생을 삭제하였습니다.")
        } else {
            print("\(name) 학생을 찾지 못했습니다.")
        }
    }
}

func updateScore() {
    print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift A+\n만약에 학생의 설적중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
    if let input = inputData() {
        let data = input.split(separator: " ").map { String($0) }
        if data.count != 3 { return print("입력이 잘못되었습니다. 다시 확인해주세요.") }
        let name = data[0], subject = data[1], score = data[2]
        guard studentIsExist(name) else { return print("\(name) 학생을 찾지 못했습니다.") }
        if let index = studentMap[name]!.firstIndex(where: { $0.subject == subject }) {
            studentMap[name]![index] = (subject, score)
        } else {
            studentMap[name]!.append((subject: subject, score: score))
        }
        print("\(name) 학생의 \(subject) 과목이 \(score)로 추가(변경)되었습니다.")
    }
}

func removeScore() {
    print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift")
    if let input = inputData() {
        let data = input.split(separator: " ").map { String($0) }
        if data.count != 2 { return print("입력이 잘못되었습니다. 다시 확인해주세요.") }
        let name = data[0], subject = data[1]
        guard studentIsExist(name) else { return print("\(name) 학생을 찾지 못했습니다.") }
        if let index = studentMap[name]!.firstIndex(where: { $0.subject == subject }) {
            studentMap[name]!.remove(at: index)
            print("\(name) 학생의 \(subject) 과목의 성적이 삭제되었습니다.")
        } else {
            print("\(subject) 과목이 없습니다.")
        }
    }
}

func viewScore() {
    print("평점을 알고싶은 학생의 이름을 입력해주세요")
    if let name = inputData() {
        guard studentIsExist(name) else { return print("\(name) 학생을 찾지 못했습니다.") }
        if let scores = studentMap[name] {
            var sum: Double = 0
            for s in scores {
                print("\(s.subject): \(s.score)")
                sum += scoreMap[s.score]!
            }
            scores.isEmpty ? print("\(name) 학생의 성적이 존재하지 않습니다.") : print("평점 : \(sum / Double(scores.count))")
        }
    }
}

func exitApp() {
    print("프로그램을 종료합니다...")
    exit(0)
}

func inputData() -> String? {
    guard let name = readLine(), name != "" else { print("입력이 잘못되었습니다. 다시 확인해주세요."); return nil }
    return name
}

func printMenu() {
    print("원하는 기능을 입력해주세요")
    print("1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")
}

func inputCommand(_ input: String?) {
    guard let input else { print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요."); return }
    guard let feature = featureMap[input] else { print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요."); return }
    feature()
}

func run() {
    while true {
        printMenu()
        inputCommand(readLine())
    }
}

run()
