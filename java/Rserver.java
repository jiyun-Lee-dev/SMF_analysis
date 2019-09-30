package test3;

import java.io.*;
import java.util.*;
import org.rosuda.REngine.*;
import org.rosuda.REngine.Rserve.*;

public class Rserver {
	// html에서 받아온 사용자 입력값을 전역변수로 저장(일단은 html에서 받아왔다고 가정)
	public String pname = "";
	public String psex = "";
	public String style = "";
	public String distance = "";
	public String newFileName = "";
	
	// R과 연결하는 부분
	public RConnection c = null;
	public Rserver(String pname, String psex, String style, String distance) throws RserveException {
		this.pname = pname;
		this.psex = psex;
		this.style = style;
		this.distance = distance;
		c = new RConnection();
	}
	
	// 사용 중인 R의 버전 확인하기
	public String getRVersion() throws RserveException, REXPMismatchException {
		REXP x = c.eval("R.version.string");
		return ("R version : " + x.asString());
	}
	
	// 결과값을 파일로 저장하기
	public void save_file(String fileName, List<String[]> list) {
		String path = "/home/R_result";
		String fname = fileName + ".txt";
		//String fname = "C:"+File.separator+"User"+File.separator+"Desktop"+File.separator+"R_Result" + "_" + fileName + ".txt";
		File f = new File(path, fname);
		BufferedWriter writer = null;
		try {
			f.createNewFile();
			writer = new BufferedWriter(new FileWriter(f, false)); // 기존 내용 없애고 새로 쓰기
			for (int i = 0; i < list.size(); i++) {
				writer.write(list.get(i)[0]);
				writer.write(":");
				writer.write(list.get(i)[1]);
				writer.write(":");
				writer.write("/");
				writer.flush();
			}
		} catch(IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (writer != null) writer.close();
			} catch(IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	// txt/csv 파일 읽기, 정리하기
	public void read_file() throws RserveException, REXPMismatchException {
		// 읽을 파일 경로명 R에 맞게 정리
		String srcPath = "/usr/local/apache-tomcat-8.5.39/webapps/individual_game_result_2.csv";
		srcPath = srcPath.replaceAll("\\\\", "/");
		c.assign("src", srcPath);
		// 데이터 읽기
		c.voidEval("data <- read.csv(src, stringsAsFactors = FALSE, na=\"-\", fileEncoding = \"CP949\", encoding = \"UTF-8\")");
		// 읽어 온 데이터 중 의미 없는 데이터 제거
		c.voidEval("realData <- subset(data, data$rank!='불참')");
		c.voidEval("realData <- subset(realData, realData$rank!='실격')");
		c.voidEval("realData <- subset(realData, realData$rank!='중도포기')");
		c.voidEval("realData <- subset(realData, realData$rank!='DQ')");
		c.voidEval("realData <- subset(realData, realData$remark!='실격')");
		c.voidEval("realData <- subset(realData, realData$remark!='불참')");
		c.voidEval("realData <- subset(realData, realData$remark!='실격 한손터치')");
		c.voidEval("realData <- subset(realData, realData$remark!='실격 부정출발')");
		c.voidEval("realData <- subset(realData, realData$remark!='영법실격')");
		c.voidEval("realData <- subset(realData, realData$remark!='비고')");
		c.voidEval("realData <- subset(realData, realData$remark!='기권')");
		c.voidEval("realData <- subset(realData, realData$remark!='DQ')");
		c.voidEval("realData <- subset(realData, realData$record!='1000000')");
		c.voidEval("realData <- subset(realData, realData$record!='100000')");
		c.voidEval("realData <- subset(realData, realData$record!='00:00.00')");
		//데이터 간단하게 만들기(필요한 항목의 데이터만 남겨두었음)
		c.voidEval("realData <- realData[c(\"pname\", \"psex\", \"style\", \"distance\", \"record\")]");
	}
	
	
	// 인자로 받은 record 데이터(문자열)를 초 단위 실수로 바꾸고 결과값 리턴
	public double record_String_to_Number(String record) throws RserveException, REXPMismatchException{
		if ( record.length() < 6 ) {
			for (int i=record.length(); i<=6; i++) {
				record = "0" + record;
			}
		}
		double record_Seconds = 0.0;
		int minutes = 0;
		int seconds = 0;
		double mseconds = 0.0;
		minutes = Integer.parseInt(record.substring(0,2))*60;
		seconds = Integer.parseInt(record.substring(2,4));
		mseconds = Double.parseDouble(record.substring(4,6))/100;
		record_Seconds = minutes + seconds + mseconds;
		
		return record_Seconds;
	}
	
	// 인자로 받은 종목에 대한 각 선수들의 평균 값 구하기
	public void calAVG(String style_prediction, String distance_prediction) throws RserveException, REXPMismatchException{
		c.voidEval("resultBase <- subset(realData, realData$style=='"+ style_prediction +"' & realData$distance == '" + distance_prediction + "')");
		// pname, psex를 기준으로 한 사람당 데이터 묶기
		c.voidEval("resultPeople <- merge(resultBase, resultBase, by=c(\"pname\", \"psex\", \"style\", \"distance\", \"record\"), all = TRUE )");
		// 한 사람당 데이터 평균값 구하기
		c.voidEval("recordAVG <- numeric()");
		c.voidEval("recordPerson <- character()");
		c.voidEval("index <- 1");
		int dataLength = c.eval("nrow(resultPeople)").asInteger(); // 기록 개수
		int recordsNum = 1;
		double recordsSum = record_String_to_Number(c.eval("resultPeople$record[1]").asString());		
		for (int i = 2; i < dataLength; i++) {
			int j = i - 1;
			String pname1 = c.eval("resultPeople$pname[" + i + "]").asString();
			String pname2 = c.eval("resultPeople$pname[" + j + "]").asString();
			if(pname1 == pname2) {
				recordsSum += record_String_to_Number(c.eval("resultPeople$record[" + i + "]").asString());
				recordsNum++;
			}
			else {
				c.voidEval("recordAVG[index] <- round(" + recordsSum + "/" + recordsNum + ", 2)");				
				c.voidEval("recordPerson[index] <- resultPeople$pname[" + j + "]");
				c.voidEval("index <- index + 1");
				recordsNum = 1;
				recordsSum = 0;
				recordsSum = record_String_to_Number(c.eval("resultPeople$record[" + i + "]").asString());
			}
		}
		c.voidEval("resultAVG <<- data.frame(recordPerson, recordAVG)");
	}
	
	String opposite_distance =  "";
	// 선형회귀분석 후 결과 저장
	public void linearModel() throws RserveException, REXPMismatchException{
		// 예측값, 예측종목-예측거리
		calAVG(this.style, this.distance);
		c.voidEval("Distance_y <<- resultAVG");
		if (this.distance.equals("50")) {
			opposite_distance = "100";
		} else {
			opposite_distance = "50";
		}
		// 독립변수, 예측종목-다른거리
		calAVG(this.style, opposite_distance);
		c.voidEval("Distance_x <<- resultAVG");
		c.voidEval("finalDataSet <<- merge(Distance_x, Distance_y, by='recordPerson')");
		c.voidEval("m1 <<- lm(finalDataSet$recordAVG.y ~ finalDataSet$recordAVG.x)");
		// finalDataSet을 리스트로 변환
		List<String[]> resultList = new ArrayList<String[]>();
		RList l = c.eval("finalDataSet").asList();
		String[] xValue = l.at("recordAVG.x").asStrings();
		String[] yValue = l.at("recordAVG.y").asStrings();
		for(int i=0; i<xValue.length; i++) {
			resultList.add(new String[] {xValue[i], yValue[i]});
		}
		// 선형회귀분석 그래프의 절편과 기울기도 리스트에 저장
		double plus = c.eval("coef(m1)[2]").asDouble();
		resultList.add(new String[] {"독립변수기울기", plus+""});
		plus = c.eval("coef(m1)[1]").asDouble();
		resultList.add(new String[] {"y절편", plus+""});
		// 선형회귀분석 그래프의 신뢰구간에 대한 정보도 리스트에 저장
		c.voidEval("errorRange <- confint.default(m1)");
		plus = c.eval("abs(errorRange[4]-errorRange[2])").asDouble();
		resultList.add(new String[] {"오차범위", plus+""});
		// 최종 데이터셋 및 선형회귀 분석 결과 파일 서버에 저장
		String filename = this.style + this.distance + "-" + this.style + opposite_distance;
		this.newFileName = filename;
		save_file(filename, resultList);
	}
	
}
