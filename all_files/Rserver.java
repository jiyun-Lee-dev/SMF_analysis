package test3;

import java.io.*;
import java.util.*;
import org.rosuda.REngine.*;
import org.rosuda.REngine.Rserve.*;

public class Rserver {
	// html���� �޾ƿ� ����� �Է°��� ���������� ����(�ϴ��� html���� �޾ƿԴٰ� ����)
	public String pname = "";
	public String psex = "";
	public String style = "";
	public String distance = "";
	public String newFileName = "";
	
	// R�� �����ϴ� �κ�
	public RConnection c = null;
	public Rserver(String pname, String psex, String style, String distance) throws RserveException {
		this.pname = pname;
		this.psex = psex;
		this.style = style;
		this.distance = distance;
		c = new RConnection();
	}
	
	// ��� ���� R�� ���� Ȯ���ϱ�
	public String getRVersion() throws RserveException, REXPMismatchException {
		REXP x = c.eval("R.version.string");
		return ("R version : " + x.asString());
	}
	
	// ������� ���Ϸ� �����ϱ�
	public void save_file(String fileName, List<String[]> list) {
		String path = "/home/R_result";
		String fname = fileName + ".txt";
		//String fname = "C:"+File.separator+"User"+File.separator+"Desktop"+File.separator+"R_Result" + "_" + fileName + ".txt";
		File f = new File(path, fname);
		BufferedWriter writer = null;
		try {
			f.createNewFile();
			writer = new BufferedWriter(new FileWriter(f, false)); // ���� ���� ���ְ� ���� ����
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
	
	// txt/csv ���� �б�, �����ϱ�
	public void read_file() throws RserveException, REXPMismatchException {
		// ���� ���� ��θ� R�� �°� ����
		String srcPath = "/usr/local/apache-tomcat-8.5.39/webapps/individual_game_result_2.csv";
		srcPath = srcPath.replaceAll("\\\\", "/");
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
		c.voidEval("realData <- realData[c(\"pname\", \"psex\", \"style\", \"distance\", \"record\")]");
	}
	
	
	// ���ڷ� ���� record ������(���ڿ�)�� �� ���� �Ǽ��� �ٲٰ� ����� ����
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
	
	// ���ڷ� ���� ���� ���� �� �������� ��� �� ���ϱ�
	public void calAVG(String style_prediction, String distance_prediction) throws RserveException, REXPMismatchException{
		c.voidEval("resultBase <- subset(realData, realData$style=='"+ style_prediction +"' & realData$distance == '" + distance_prediction + "')");
		// pname, psex�� �������� �� ����� ������ ����
		c.voidEval("resultPeople <- merge(resultBase, resultBase, by=c(\"pname\", \"psex\", \"style\", \"distance\", \"record\"), all = TRUE )");
		// �� ����� ������ ��հ� ���ϱ�
		c.voidEval("recordAVG <- numeric()");
		c.voidEval("recordPerson <- character()");
		c.voidEval("index <- 1");
		int dataLength = c.eval("nrow(resultPeople)").asInteger(); // ��� ����
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
	// ����ȸ�ͺм� �� ��� ����
	public void linearModel() throws RserveException, REXPMismatchException{
		// ������, ��������-�����Ÿ�
		calAVG(this.style, this.distance);
		c.voidEval("Distance_y <<- resultAVG");
		if (this.distance.equals("50")) {
			opposite_distance = "100";
		} else {
			opposite_distance = "50";
		}
		// ��������, ��������-�ٸ��Ÿ�
		calAVG(this.style, opposite_distance);
		c.voidEval("Distance_x <<- resultAVG");
		c.voidEval("finalDataSet <<- merge(Distance_x, Distance_y, by='recordPerson')");
		c.voidEval("m1 <<- lm(finalDataSet$recordAVG.y ~ finalDataSet$recordAVG.x)");
		// finalDataSet�� ����Ʈ�� ��ȯ
		List<String[]> resultList = new ArrayList<String[]>();
		RList l = c.eval("finalDataSet").asList();
		String[] xValue = l.at("recordAVG.x").asStrings();
		String[] yValue = l.at("recordAVG.y").asStrings();
		for(int i=0; i<xValue.length; i++) {
			resultList.add(new String[] {xValue[i], yValue[i]});
		}
		// ����ȸ�ͺм� �׷����� ����� ���⵵ ����Ʈ�� ����
		double plus = c.eval("coef(m1)[2]").asDouble();
		resultList.add(new String[] {"������������", plus+""});
		plus = c.eval("coef(m1)[1]").asDouble();
		resultList.add(new String[] {"y����", plus+""});
		// ����ȸ�ͺм� �׷����� �ŷڱ����� ���� ������ ����Ʈ�� ����
		c.voidEval("errorRange <- confint.default(m1)");
		plus = c.eval("abs(errorRange[4]-errorRange[2])").asDouble();
		resultList.add(new String[] {"��������", plus+""});
		// ���� �����ͼ� �� ����ȸ�� �м� ��� ���� ������ ����
		String filename = this.style + this.distance + "-" + this.style + opposite_distance;
		this.newFileName = filename;
		save_file(filename, resultList);
	}
	
}
