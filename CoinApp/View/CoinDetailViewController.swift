//
// CoinDetailViewController.swift
// CoinApp
//
// Created by SeongKook on 6/19/24.
//

import UIKit
import DGCharts

class CoinDetailViewController: UIViewController {
    
    private var coinViewModel = CoinViewModel()
    var coindata: CoinModel
    
    // Title Label
    private let coinTitleLabel: UILabel = {
        let coinTitleLabel = UILabel()
        coinTitleLabel.font = .systemFont(ofSize: 23, weight: .semibold)
        coinTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return coinTitleLabel
    }()
    
    // yesterday Label
    private let yesterdayLabel: UILabel = {
        let yesterdayLabel = UILabel()
        yesterdayLabel.font = .systemFont(ofSize: 18, weight: .medium)
        yesterdayLabel.text = "어제보다"
        yesterdayLabel.textColor = UIColor.systemGray
        yesterdayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return yesterdayLabel
    }()
    
    private let yesterdayColorLabel: UILabel = {
        let yesterdayColorLabel = UILabel()
        yesterdayColorLabel.font = .systemFont(ofSize: 18, weight: .medium)
        yesterdayColorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return yesterdayColorLabel
    }()
    
    // Chart View
    private let myBarChartView: BarChartView = {
        var myBarChartView = BarChartView()
        myBarChartView.translatesAutoresizingMaskIntoConstraints = false
        
        return myBarChartView
    }()
    
    // CurrentPriceLabel
    private let currentPriceLabel: UILabel = {
        let currentPriceLabel = UILabel()
        currentPriceLabel.font = .systemFont(ofSize: 24, weight: .bold)
        currentPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return currentPriceLabel
    }()
    
    
    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.text = "* 바 클릭시 가격이 나타납니다."
        priceLabel.font = .systemFont(ofSize: 18, weight: .regular)
        priceLabel.textColor = .systemRed
        priceLabel.textAlignment = .left
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return priceLabel
    }()
    
    
    // 구분값
    var dayData: [String] = ["1일", "12시간", "6시간", "1시간", "30분", "15분", "현재"]
    // 데이터
    var priceData: [Double] = []
    
    
    // 초기화
    init(coindata: CoinModel) {
        self.coindata = coindata
        super.init(nibName: nil, bundle: nil)
        
        // priceData 계산
        calculatePriceData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpChart()
    }
    
    // UI Upadate
    func setUpUI() {
        
        self.view.backgroundColor = .white
        
        coinTitleLabel.text = coindata.name
        currentPriceLabel.text = "\(coindata.quotes.krw.price.priceInt())원"
        
        self.view.addSubview(priceLabel)
        self.view.addSubview(myBarChartView)
        self.view.addSubview(coinTitleLabel)
        self.view.addSubview(currentPriceLabel)
        self.view.addSubview(yesterdayLabel)
        self.view.addSubview(yesterdayColorLabel)

        
        setUpColorLabel()
        
        // BarChartView 레이아웃 설정
        NSLayoutConstraint.activate([
            coinTitleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            coinTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            
            currentPriceLabel.topAnchor.constraint(equalTo: coinTitleLabel.bottomAnchor),
            currentPriceLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            
            yesterdayLabel.topAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor, constant: 10),
            yesterdayLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
    
            yesterdayColorLabel.topAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor, constant: 10),
            yesterdayColorLabel.leadingAnchor.constraint(equalTo: yesterdayLabel.trailingAnchor, constant: 5),
            
            myBarChartView.topAnchor.constraint(equalTo: yesterdayColorLabel.bottomAnchor, constant: 50),
            myBarChartView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            myBarChartView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            myBarChartView.heightAnchor.constraint(equalToConstant: 300),
            
            priceLabel.topAnchor.constraint(equalTo: myBarChartView.bottomAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])
        
    }
    
    // setUp yesterdayLabel
    func setUpColorLabel() {
        // 어제의 가격 계산
        let yesterdayPrice = coindata.quotes.krw.price - coindata.quotes.krw.price / (1 + coindata.quotes.krw.percentChange24h / 100)
        
        // 변동률 각격
        yesterdayColorLabel.text = "\(yesterdayPrice.priceInt())원 (\(coindata.quotes.krw.percentChange24h)%)"
        
        // 변동 색상
        yesterdayColorLabel.textColor = coindata.quotes.krw.percentChange24h >= 0 ? .systemRed : .systemBlue
    }
    
    // Chart Update
    func setUpChart() {
        // 기본 문구
        self.myBarChartView.noDataText = "출력 데이터가 없습니다."
        // 기본 문구 폰트
        self.myBarChartView.noDataFont = .systemFont(ofSize: 26)
        // 기본 문구 색상
        self.myBarChartView.noDataTextColor = .black
        // 차트 기본 뒷 배경색
        self.myBarChartView.backgroundColor = .white
        // 구분값 보이기
        self.myBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dayData)
        // 구분값 모두 보이기
        self.myBarChartView.xAxis.setLabelCount(priceData.count, force: false)
        // X축 레이블 아래로 이동
        self.myBarChartView.xAxis.labelPosition = .bottom
        // Y축 레이블 제거
        self.myBarChartView.leftAxis.enabled = false
        self.myBarChartView.rightAxis.enabled = false
        // "가격" 레이블 위치 설정
        let legend = self.myBarChartView.legend
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = false
        
        self.myBarChartView.delegate = self
        
        // 데이터 적용
        self.setBarData(barChartView: self.myBarChartView, barChartDataEntries: self.entryData(values: self.priceData))
    }
    
    // priceData 계산
    private func calculatePriceData() {
        let currentPrice = coindata.quotes.krw.price
        
        let percentChanges = [
            coindata.quotes.krw.percentChange24h,
            coindata.quotes.krw.percentChange12h,
            coindata.quotes.krw.percentChange6h,
            coindata.quotes.krw.percentChange1h,
            coindata.quotes.krw.percentChange30m,
            coindata.quotes.krw.percentChange15m,
        ]
        
        priceData = percentChanges.map { percentChange in
            return currentPrice / (1 + percentChange / 100)
        }
        
        // 현재 가격 추가
        priceData.append(currentPrice)
    }
    
    // 데이터셋 만들고 차트에 적용하기
    func setBarData(barChartView: BarChartView, barChartDataEntries: [BarChartDataEntry]) {
        // 데이터 셋 만들기
        let barChartdataSet = BarChartDataSet(entries: barChartDataEntries, label: "가격")
        // 막대 색상 설정
        barChartdataSet.colors = [UIColor.systemBlue]
        // 막대 위에 값 숨기기
        barChartdataSet.drawValuesEnabled = false
        // 차트 데이터 만들기
        let barChartData = BarChartData(dataSet: barChartdataSet)
        // 데이터 차트에 적용
        barChartView.data = barChartData
    }
    
    // entry 만들기
    func entryData(values: [Double]) -> [BarChartDataEntry] {
        // 엔트리들 만들기
        var barDataEntries: [BarChartDataEntry] = []
        // 데이터 값 만큼 엔트리 생성
        for i in 0 ..< values.count {
            let barDataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            barDataEntries.append(barDataEntry)
        }
        // 엔트리들 반환
        return barDataEntries
    }
}

// ChartViewDelegate 메서드
extension CoinDetailViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let barEntry = entry as? BarChartDataEntry {
            
            priceLabel.text = "\(barEntry.y.priceInt())원"
            priceLabel.font = .systemFont(ofSize: 20, weight: .bold)
            priceLabel.textColor = .systemBlue
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        priceLabel.text = "* 바 클릭시 가격이 나타납니다."
        priceLabel.font = .systemFont(ofSize: 18, weight: .regular)
        priceLabel.textColor = .systemRed
    }
}
