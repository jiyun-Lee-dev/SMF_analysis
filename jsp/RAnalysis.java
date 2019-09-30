package test3;

import java.io.*;
import java.util.*;
import org.rosuda.REngine.*;
import org.rosuda.REngine.Rserve.*;

public class RAnalysis {
	// html���� �޾ƿ� ����� �Է°��� ���������� ����(�ϴ��� html���� �޾ƿԴٰ� ����)
		public String pname = "";
		public String psex = "";
		public String age_from = "";
		public String age_to = "";
		public String teamName = "";
		public static int totalNum = 0;
		public static String forwardRecord = "";
		
		// R�� �����ϴ� �κ�
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
		
		// txt/csv ���� �б�, �����ϱ�
		public void read_file() throws RserveException, REXPMismatchException {
			// ���� ���� ��θ� R�� �°� ����
			String srcPath = "/usr/local/apache-tomcat-8.5.39/webapps/individual_game_result_2.csv";
			c.assign("src", srcPath);
			// ������ �б�
			c.voidEval("data <- read.csv(src, stringsAsFactors = FALSE, na=\"-\", fileEncoding = \"CP949\", encoding = \"UTF-8\")");
			// �о� �� ������ �� �ǹ� ���� ������ ����
			c.voidEval("realData <- subset(data, data$rank!='����')");
			c.voidEval("realData <- subset(realData, realData$rank!='�ǰ�')");
			c.voidEval("realData <- subset(realData, realData$rank!='�ߵ�����')");
			c.voidEval("realData <- subset(realData, realData$rank!='DQ')");
			c.voidEval("realData <- subset(realData, realData$remark!='�ǰ�')");
			c.voidEval("realData <- subset(realData, realData$remark!='����')");
			c.voidEval("realData <- subset(realData, realData$remark!='�ǰ� �Ѽ���ġ')");
			c.voidEval("realData <- subset(realData, realData$remark!='�ǰ� �������')");
			c.voidEval("realData <- subset(realData, realData$remark!='�����ǰ�')");
			c.voidEval("realData <- subset(realData, realData$remark!='���')");
			c.voidEval("realData <- subset(realData, realData$remark!='���')");
			c.voidEval("realData <- subset(realData, realData$remark!='DQ')");
			c.voidEval("realData <- subset(realData, realData$record!='1000000')");
			c.voidEval("realData <- subset(realData, realData$record!='100000')");
			c.voidEval("realData <- subset(realData, realData$record!='00:00.00')");
			//������ �����ϰ� �����(�ʿ��� �׸��� �����͸� ���ܵξ���)
			c.voidEval("realData <- realData[c(\"pname\", \"psex\", \"age_from\", \"age_to\", \"team\", \"style\", \"distance\", \"record\")]");
		}
		
		// ���ڷ� ���� record ������(���ڿ�)�� �� ���� �Ǽ��� �ٲٰ� ����� ����
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
		
		// ���ڷ� ���� record 00:00.00 �������� ��ȯ�ؼ� ����� ����
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
		
		
		// ���� �� ��ü ��Ͽ� ���ؼ� ���� �ű�� �� ����� ��� ����
		public List<String[]> getRanking(String style_analysis, String distance_analysis) throws RserveException, REXPMismatchException {
			c.voidEval("resultSet <- subset(realData, style == '" + style_analysis + "' & distance == '" + distance_analysis + "' & psex == '" + psex + "')" );
			c.voidEval("head(resultSet)");
			// ������ �ű�� ���ؼ� ����� ���������� ��ȯ
			int dataLength = c.eval("nrow(resultSet)").asInteger();
			totalNum = dataLength;
			c.voidEval("firstData <<- as.numeric(resultSet$record[1])");
			c.voidEval("record <- firstData");
			for (int i=2; i<=dataLength; i++) {
				c.voidEval("value <- as.numeric(resultSet$record[" + i + "])");
				c.voidEval("record <- c(record, value)");
			}
			// ���� �� ��ü ��Ͽ� ���� ���� �ű��
			c.voidEval("resultSet <- resultSet[, -c(8)]");
			c.voidEval("resultSet <- cbind(resultSet, record)");
			c.voidEval("temp <- resultSet[order(record),]");
			c.voidEval("rank <- 1");
			for (int i=2; i<=dataLength; i++) {
				c.voidEval("rank <- c(rank, " + i + ")");
			}
			c.voidEval("temp <- cbind(temp, rank)");
			
			// ��� �κ� �����ϰ� �ٽ� ������� string���� ��ȯ�ؼ� �ٽ� ����
			c.voidEval("first <<- as.character(resultSet$record[1])");
			c.voidEval("record <- first");
			for (int i=2; i<=dataLength; i++) {
				c.voidEval("value <- as.character(resultSet$record[" + i + "])");
				c.voidEval("record <- c(record, value)");
			}
			c.voidEval("resultSet <- resultSet[, -c(8)]");
			c.voidEval("resultSet <- cbind(resultSet, record)");
			
			// ����� ��� ����
			c.voidEval("playerDataSet <- subset(temp, pname == '" + pname + "' & team == '" + teamName + "' & ((age_from >= '" + age_from + "' | age_from <= '" + age_to + "') & (age_to >= '" + age_from + "' | age_to <= '" + age_to + "')) )");

			// ���� �� ����� ������ ���ؼ� �ٷ� �� ����� ��� ����
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
				// ����� ����� ����Ʈ�� ����
		         RList l = c.eval("playerDataSet").asList();
		         String[] playerRecords = l.at("record").asStrings();
		         //�̰� ���� �ڲ� �ڿ� .0�� �پ���� �װ� �����ؾ���
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
		
		// ���� �� ����� ��� ��� �� ���ϱ�
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
		
		// ���� �� ���� ���� ������ �ش��ϴ� ����Ʈ�� �ε��� ���ϱ� (jsp���� ����Ʈ[�ε���].get���� ��ϰ� ���� �� ���� ������ ��)
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
		
		// ��� �� ������ �ٲ㼭 list �ٽ� �����ϰ� ����
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
		
		// ��� ������ 00:00.00���� �ٲ㼭  ������ ����Ʈ ����
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
