package com.app.main;

import java.util.ArrayList;
import java.util.List;

public class SonarDemo {
	
	int id=10;
	public SonarDemo() {
		System.out.println("constructor");
	}

	void testMethod() {
		//String s = "";
		List<Integer> list = new ArrayList<Integer>();
		list.add(1);
		Object obj = getData();
		System.out.println(obj.toString());
	}

	public Object getData() {
		return null;
	}

	public static void main(String[] args) {
		SonarDemo sd=new SonarDemo();
		//sd.testMethod();
		System.out.println("Hello World");
	}

}
