package test3;

import java.io.*;
import java.util.*;
import org.rosuda.REngine.*;
import org.rosuda.REngine.Rserve.*;

public class RAnalysis {
	// html에서 받아온 사용자 입력값을 전역변수로 저장(일단은 html에서 받아왔다고 가정)
		public String pname = "";
		public String psex = "";
		public String age_from = "";
		public String age_to = "";
		public String teamName = "";
		public static int totalNum = 0;
		public static String forwardRecord = "";
		
		// R과 연결하는 부분
		public RConnection c = null;
		public RAnalysis(String pname, String psex, String age, String teamName) throws RserveException {
			this.pname = pname;
			this.psex = psex;
			String[] ageSection = age.split(",");
			this.age_from = ageSection[0];
			this.age_to = ageSection[1];
			this.teamName = teamName;
			c = new RConnection();
		}
		
		// txt/csv 파일 읽기, 정리하기
		public void read_file() throws RserveException, REXPMismatchException {
			// 읽을 파일 경로명 R에 맞게 정리
			String srcPath = "/usr/local/apache-tomcat-8.5.39/webapps/individual_game_result_2.csv";
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
			c.voidEval("realData <- realData[c(\"pname\", \"psex\", \"age_from\", \"age_to\", \"team\", \"style\", \"distance\", \"record\")]");
		}
		
		// 인자로 받은 record 데이터(문자열)를 초 단위 실수로 바꾸고 결과값 리턴
		public double record_String_to_Number(String record) throws RserveException, REXPMismatchException{
			if ( record.length() < 6 ) {
				for (int i=record.length(); i<6; i++) {
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
		
		// 인자로 받은 record 00:00.00 형식으로 변환해서 결과값 리턴
		public String recordContextChange(String record)throws RserveException, REXPMismatchException {
			if ( record.length() < 6 ) {
				for (int i=record.length(); i<6; i++) {
					record = "0" + record;
				}
			}
			String minutes = record.substring(0,2);
			String seconds = record.substring(2,4);
			String mseconds = record.substring(4,6);
			String changedRecord = "";
			if (minutes != "00") {
				changedRecord += minutes + ":";
			}
			changedRecord += seconds + "." + mseconds;
			
			return changedRecord;
		}
		
		
		// 종목 별 전체 기록에 대해서 순위 매기기 및 사용자 기록 추출
		public List<String[]> getRanking(String style_analysis, String distance_analysis) throws RserveException, REXPMismatchException {
			c.voidEval("resultSet <- subset(realData, style == '" + style_analysis + "' & distance == '" + distance_analysis + "' & psex == '" + psex + "')" );
			c.voidEval("head(resultSet)");
			// 순위를 매기기 위해서 기록을 숫자형으로 변환
			int dataLength = c.eval("nrow(resultSet)").asInteger();
			totalNum = dataLength;
			c.voidEval("firstData <<- as.numeric(resultSet$record[1])");
			c.voidEval("record <- firstData");
			for (int i=2; i<=dataLength; i++) {
				c.voidEval("value <- as.numeric(resultSet$record[" + i + "])");
				c.voidEval("record <- c(record, value)");
			}
			// 종목 별 전체 기록에 대한 순위 매기기
			c.voidEval("resultSet <- resultSet[, -c(8)]");
			c.voidEval("resultSet <- cbind(resultSet, record)");
			c.voidEval("temp <- resultSet[order(record),]");
			c.voidEval("rank <- 1");
			for (int i=2; i<=dataLength; i++) {
				c.voidEval("rank <- c(rank, " + i + ")");
			}
			c.voidEval("temp <- cbind(temp, rank)");
			
			// 기록 부분 제거하고 다시 원래대로 string으로 변환해서 다시 저장
			c.voidEval("first <<- as.character(resultSet$record[1])");
			c.voidEval("record <- first");
			for (int i=2; i<=dataLength; i++) {
				c.voidEval("value <- as.character(resultSet$record[" + i + "])");
				c.voidEval("record <- c(record, value)");
			}
			c.voidEval("resultSet <- resultSet[, -c(8)]");
			c.voidEval("resultSet <- cbind(resultSet, record)");
			
			// 사용자 기록 추출
			c.voidEval("playerDataSet <- subset(temp, pname == '" + pname + "' & team == '" + teamName + "' & ((age_from >= '" + age_from + "' | age_from <= '" + age_to + "') & (age_to >= '" + age_from + "' | age_to <= '" + age_to + "')) )");

			// 종목 별 사용자 순위와 비교해서 바로 앞 사람의 기록 추출
			c.voidEval("tempDataSet <- playerDataSet[order(rank),]");
			c.voidEval("forwardSet <- subset(temp, rank == tempDataSet$rank[1]-200)");
			try {
				forwardRecord = c.eval("forwardSet$record").asString();
			} catch(IndexOutOfBoundsException e) {
				forwardRecord = "0";
			}
			
			if (forwardRecord.length() > 1) {
				forwardRecord = forwardRecord.substring(0, forwardRecord.length()-2);
			}
			
			List<String[]> resultList = new ArrayList<String[]>();
			int finalDataLength = c.eval("nrow(playerDataSet)").asInteger();
			if (finalDataLength <= 0) {
				resultList.add(new String[] {"0", "0"});
			} else {
				// 사용자 기록을 리스트로 저장
		         RList l = c.eval("playerDataSet").asList();
		         String[] playerRecords = l.at("record").asStrings();
		         //이게 값이 자꾸 뒤에 .0이 붙어가지고 그거 수정해야함
		         for (int i=0; i<playerRecords.length; i++) {
		        	 String temp = playerRecords[i];
		        	 playerRecords[i] = temp.substring(0, temp.length()-2);
		         }		         
		         String[] playerRank = l.at("rank").asStrings();
		         for (int i=0; i<playerRank.length; i++) {
		        	 String temp = playerRank[i];
		        	 playerRank[i] = temp.substring(0, temp.length()-2);
		         }
		         
		         for(int i=0; i<playerRecords.length; i++) {
		            resultList.add(new String[] { playerRecords[i], playerRank[i]});	
		         }
	         }
			return resultList;
		}
		
		// 종목 별 사용자 평균 기록 값 구하기
		public int calAVG(List<String[]> list) throws RserveException, REXPMismatchException{
			double recordsSUM = 0.0;
			double recordsAVG = 0.0;
			int count = 0;
			if (list.get(0)[0] != "0") {
				for (int i = 0; i < list.size(); i++) {
					recordsSUM += record_String_to_Number(list.get(i)[0]);
					count ++;
				}
				recordsAVG = recordsSUM/count;	
			}
			int result = (int)Math.floor(recordsAVG);
			return result;
		}
		
		// 종목 별 가장 높은 순위에 해당하는 리스트의 인덱스 구하기 (jsp에서 리스트[인덱스].get으로 기록과 순위 다 접근 가능할 것)
		public int getRank(List<String[]> list) throws RserveException, REXPMismatchException{
			int minValueIndex = 0;
			double min = Double.parseDouble(list.get(0)[1]);
			for (int i = 1; i<list.size(); i++) {
				double current = Double.parseDouble(list.get(i)[1]);
				if ( current < min) {
					min = current;
					minValueIndex = i;
				}
			}
			return minValueIndex;
		}
		
		// 기록 초 단위로 바꿔서 list 다시 저장하고 리턴
		public List<Double> getEntireRecords(List<String[]> list) throws RserveException, REXPMismatchException {
			List<Double> recordsList = new ArrayList<Double>();
			if (list.get(0)[0] != "0") {
				for (int i = 0; i < list.size(); i++) {
					double recordsBySeconds = record_String_to_Number(list.get(i)[0]);
					recordsList.add(recordsBySeconds);
				}
			} else {
				recordsList.add(0.0);
			}
			return recordsList;
		}
		
		// 기록 형식을 00:00.00으로 바꿔서  저장한 리스트 리턴
		public List<String[]> getEntireRecords_String(List<String[]> list) throws RserveException, REXPMismatchException {
			List<String[]> recordsList = new ArrayList<String[]>();
			if (list.get(0)[0] != "0") {
				for (int i = 0; i < list.size(); i++) {
					String recordsBySeconds = recordContextChange(list.get(i)[0]);
					recordsList.add(new String[] {recordsBySeconds});
				}
			} else {
				recordsList.add(new String[] {"0"});
			}
			return recordsList;
		}
		
		
}
