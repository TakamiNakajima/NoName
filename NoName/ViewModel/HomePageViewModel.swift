import Foundation

@MainActor
class HomePageViewModel: ObservableObject {
    @Published var stepCount: Double = 0.0
    @Published var calories: Double = 0.0
    @Published var thisMonthDays: [String] = []
    @Published var selectedDate: String = ""
    
    // 画面表示の初期処理
    func initialize(uid: String) async {
        let stepRepository = StepRepository()
        let steps = await stepRepository.fetchTodaySteps(uid: uid)
        let todayDate = getTodayDate()
        let dateStringsInSeptenber = getDateStringsInMonth(year: 2024, month: 10)
        DispatchQueue.main.async {
            self.stepCount = steps
            self.selectedDate = todayDate
            self.thisMonthDays = dateStringsInSeptenber
            self.calories = self.calculateCalories(steps: Int(self.stepCount), weight: 60.0)
        }
        if stepCount != 0.0 {
            do {
                try await stepRepository.saveSteps(uid: uid, steps: self.stepCount)
            } catch {
                print("歩数保存失敗")
            }
        }
    }
    
    // 選択した日付を更新する
    func onTapCircle(day: String) {
        DispatchQueue.main.async {
            self.selectedDate = day
        }
    }
    
    // 歩数から消費カロリーを計算する
    private func calculateCalories(steps: Int, weight: Double) -> Double {
        let mets = 3.5
        let speed = 4.8
        let strideLength = 0.75

        // 距離を計算 (km)
        let distance = Double(steps) * strideLength / 1000
        
        // 時間を計算 (時間)
        let time = distance / speed
        
        // 消費カロリーを計算
        let calories = mets * weight * time
        
        return calories
    }
    
    // 今日の日付を取得する
    private func getTodayDate() -> String {
        let calendar = Calendar.current
        let today = Date()
        
        // 今日の日にちを取得
        let day = calendar.component(.day, from: today)
        
        // 日を文字列に変換して返す
        return String(day)
    }
    
    // 指定月の日にちをリストて取得する
    private func getDateStringsInMonth(year: Int, month: Int) -> [String] {
        var dateStrings: [String] = []
        let calendar = Calendar.current
        
        // 指定された年と月の開始日を取得
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        // 月の最初の日を作成
        guard let startOfMonth = calendar.date(from: components) else { return dateStrings }
        
        // 月の日数を取得
        guard let range = calendar.range(of: .day, in: .month, for: startOfMonth) else { return dateStrings }
        
        // 日付フォーマッターの設定
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        
        // 各日付をリストに追加
        for day in range {
            components.day = day
            if let date = calendar.date(from: components) {
                let dateString = formatter.string(from: date)
                dateStrings.append(dateString)
            }
        }
        
        return dateStrings
    }
}