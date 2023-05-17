<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%

	//오라클 db 접속
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "sqld";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	
	//데이터베이스가 여러개인 경우 user id가 일치하지 않을 수 있으니 주의
	//__________________________________________ // nvl()___________________________________________
	
	//값1이 null이 아니면 값1을 반환, 값1이 null이면 값2를 반환한다

	String sql1 = "SELECT 이름, nvl(일분기, 0) 평가 from 실적";

	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	System.out.println(stmt1 + "<-groupByNull stmt1");
	
	ResultSet rs1 = stmt1.executeQuery();
	System.out.println(stmt1);
	

	ArrayList<HashMap<String, Object>> list1 = new ArrayList<HashMap<String, Object>>();
			//while 문 안의 rs 이름을 틀리지 않게 주의
			//rs매칭이 안됐을 때 나오는 에러: java.sql.SQLException: 결과 집합을 모두 소모했음
			while(rs1.next()) {
				HashMap<String, Object> m1 = new HashMap<String, Object>();
				m1.put("이름", rs1.getString("이름"));
				m1.put("평가", rs1.getString("평가"));
				list1.add(m1);
	
			
				}
			System.out.println(list1.size() + "<-groupByNull list1.size()");
	
	
	//__________________________________________ nvl2()___________________________________________
	//nvl2(값1, 값2, 값3) : 값1이 null아니면 값2반환, 값1이 null이면 값3을 반환
	String sql2 = "SELECT 이름, nvl2(일분기, 'success', 'fail') 평가 from 실적";

	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	System.out.println(stmt2 + "<-groupByNull stmt2");
	
	ResultSet rs2 = stmt2.executeQuery();
	System.out.println(stmt2);
	

	ArrayList<HashMap<String, Object>> list2 = new ArrayList<HashMap<String, Object>>();

			while(rs2.next()) {
				HashMap<String, Object> m2 = new HashMap<String, Object>();
				m2.put("이름", rs2.getString("이름"));
				m2.put("평가", rs2.getString("평가"));
				list2.add(m2);
	
			
				}
			System.out.println(list2.size() + "<-groupByNull list2.size()");
	
	//__________________________________________nullif()___________________________________________
	//nullif(값1, 값2) : 값1과 값2가 같으면 null을 반환 (null이 아닌값이 null로 치환에 사용)
	String sql3 = "select 이름, nullif(사분기, 100) 분기별 from 실적";

	PreparedStatement stmt3 = conn.prepareStatement(sql3);
	System.out.println(stmt3 + "<-groupByNull stmt3");
	
	ResultSet rs3 = stmt3.executeQuery();
	System.out.println(stmt3);
	

	ArrayList<HashMap<String, Object>> list3 = new ArrayList<HashMap<String, Object>>();

			while(rs3.next()) {
				HashMap<String, Object> m3 = new HashMap<String, Object>();
				m3.put("이름", rs3.getString("이름"));
				m3.put("분기별", rs3.getInt("분기별")); //getString으로 넣었을 땐 0이 아니고 null값으로 출력된다
				list3.add(m3);
	
			
				}
			System.out.println(list3.size() + "<-groupByNull list3.size()");
	
	//__________________________________________coalesce()___________________________________________

	//coalesce(값1, 값2, 값3, .....) : 입력값 중 null아닌 첫번째값을 반환

	String sql4 = "select 이름, coalesce(일분기, 이분기, 삼분기, 사분기) 분기별  from 실적";

	PreparedStatement stmt4 = conn.prepareStatement(sql4);
	System.out.println(stmt4 + "<-groupByNull stmt4");
	
	ResultSet rs4 = stmt4.executeQuery();
	System.out.println(stmt4);
	

	ArrayList<HashMap<String, Object>> list4 = new ArrayList<HashMap<String, Object>>();

			while(rs4.next()) {
				HashMap<String, Object> m4 = new HashMap<String, Object>();
				m4.put("이름", rs4.getString("이름"));
				m4.put("분기별", rs4.getString("분기별"));
				list4.add(m4);
	
			
				}
			System.out.println(list4.size() + "<-groupByNull list4.size()");

	
%>			




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>nvl()</h1>
	<table border="1">
	
	<tr>
		<td>이름</td>
		<td>일분기</td>

	</tr>
	
	<% 
		for(HashMap<String, Object> m1 : list1) {
	%>		
		

			<tr>
					<td><%=(String)(m1.get("이름"))%></td>
					<td><%=(String)(m1.get("평가"))%></td>

			</tr>
		
		
		
		
	<%		
		}
	%>
	
		
	</table>
	
	
	<h1>nv2()</h1>
	<table border="1">
	
	<tr>
		<td>이름</td>
		<td>일분기</td>

	</tr>
	
	<% 
		for(HashMap<String, Object> m2 : list2) {
	%>		
		

			<tr>
					<td><%=(String)(m2.get("이름"))%></td>
					<td><%=(String)(m2.get("평가"))%></td>

			</tr>
		
		
	<%		
		}
	%>
	
		
	</table>
	
	
	<h1>nullif()</h1>
	<table border="1">
	
	<tr>
		<td>이름</td>
		<td>분기별</td>

	</tr>
	
	<% 
		for(HashMap<String, Object> m3 : list3) {
	%>		
		

			<tr>
					<td><%=(String)(m3.get("이름"))%></td>
					<td><%=(Integer)(m3.get("분기별"))%></td>

			</tr>
		
		
	<%		
		}
	%>
	
		
	</table>
	
	
	
	<h1>coalesce()</h1>
	<table border="1">
	
	<tr>
		<td>이름</td>
		<td>분기별</td>

	</tr>
	
	<% 
		for(HashMap<String, Object> m4 : list4) {
	%>		
		

			<tr>
					<td><%=(String)(m4.get("이름"))%></td>
					<td><%=(String)(m4.get("분기별"))%></td>

			</tr>
		
		
	<%		
		}
	%>
	
		
	</table>
	
</body>
</html>