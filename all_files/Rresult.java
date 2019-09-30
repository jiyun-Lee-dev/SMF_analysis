package test3;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class Rresult {
	
	private String filename;
	public String filePath;
	
	public Rresult(String filename) {
		this.filename = filename;
		filePath = "/home/R_result/" + filename + ".txt";
	}
	
	// ���� �а� string���� ����
	public String getRresult() throws IOException {
		String data = "";
		try {
			// ���� ���� ����
			File file = new File(filePath);
			//BufferedReader ������ file �ֱ�
			BufferedReader reader = new BufferedReader(new FileReader(file));
			String line = null;
			while((line=reader.readLine())!=null) {
				data += line;
			}
			reader.close();
		} catch (Exception e) {
			e.getStackTrace();
		}
		return data;
	}

}
