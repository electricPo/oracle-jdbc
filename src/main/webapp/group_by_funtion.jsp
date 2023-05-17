<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- Hash Map -->


<%	


	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	
	/*
	쿼리문
	--rollup함수의 매개값이 두 개 이상일 때
	
	select department_id, job_id, count(*) from employees
	group by department_id, job_id;

	select department_id, job_id, count(*) from employees
	group by rollup(department_id, job_id);

	select department_id, job_id, count(*) from employees
	group by cube(department_id, job_id);
	
	*/
	
	String sql1 = "select department_id 부서ID, job_id 직무ID, count(*) 부서인원 from employees group by department_id, job_id";

	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	System.out.println(stmt1 + "<-groupbyfunction stmt1");
	ResultSet rs = stmt1.executeQuery();
	
	System.out.println(stmt1);
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
			//while 문 안의 rs 이름을 틀리지 않게 주의
			//rs매칭이 안됐을 때 나오는 에러: java.sql.SQLException: 결과 집합을 모두 소모했음
			while(rs.next()) {
				HashMap<String, Object> m1 = new HashMap<String, Object>();
				m1.put("부서ID", rs.getInt("부서ID"));
				m1.put("직무ID", rs.getString("직무ID"));
				m1.put("부서인원", rs.getInt("부서인원"));
				list.add(m1);
	
			
				}
			System.out.println(list + "<-groupbyfunction list");

	
	
	//group by rollup

	
	
	String sql2 = "select department_id 부서ID, job_id 직무ID, count(*) 부서인원 from employees group by rollup(department_id, job_id)";

	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	System.out.println(stmt2 + "<-groupbyfunction stmt2");
	ResultSet rs2 = stmt2.executeQuery();
	
	System.out.println(stmt2);
	
	ArrayList<HashMap<String, Object>> list2 = new ArrayList<HashMap<String, Object>>();
			
			while(rs2.next()) {
				HashMap<String, Object> m2 = new HashMap<String, Object>();
				m2.put("부서ID", rs2.getInt("부서ID"));
				m2.put("직무ID", rs2.getString("직무ID"));
				m2.put("부서인원", rs2.getInt("부서인원"));
				list2.add(m2);
	
			
				}
			System.out.println(list2 + "<-groupbyfunction list2");
		
			
	//group by cube		
		 //cube: 모든 경우의 수의 값이 나온다
	String sql3 = "select department_id 부서ID, job_id 직무ID, count(*) 부서인원 from employees group by cube(department_id, job_id)";

	PreparedStatement stmt3 = conn.prepareStatement(sql3);
	System.out.println(stmt3 + "<-groupbyfunction stmt3");
	ResultSet rs3 = stmt3.executeQuery();
	
	System.out.println(stmt3 + "<-groupbyfunction stmt2");
	
	ArrayList<HashMap<String, Object>> list3 = new ArrayList<HashMap<String, Object>>();
			
			while(rs3.next()) {
				HashMap<String, Object> m3 = new HashMap<String, Object>();
				m3.put("부서ID", rs3.getInt("부서ID"));
				m3.put("직무ID", rs3.getString("직무ID"));
				m3.put("부서인원", rs3.getInt("부서인원"));
				list3.add(m3);
	
			
				}
			System.out.println(list3 + "<-groupbyfunction list3");
					


%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>





	<table border="1">
	<h1>group by를 사용한 테이블</h1>
		<tr>
			<td>부서ID</td>
			<td>직무ID</td>
			<td>부서인원ID</td>
			
	
		</tr>
		<% 
			for(HashMap<String, Object> m1 : list) {
		%>		
			
	
				<tr>
						<td><%=(Integer)(m1.get("부서ID"))%></td>
						<td><%=(String)(m1.get("직무ID"))%></td>
						<td><%=(Integer)(m1.get("부서인원"))%></td>
	
				</tr>
			
			
			
			
		<%		
			}
		%>
	</table>
	
	
	
	<table border="1">
	<h1>group by rollup을 사용한 테이블</h1>
		<tr>
			<td>부서ID</td>
			<td>직무ID</td>
			<td>부서인원ID</td>
	
		</tr>
		<% 
			for(HashMap<String, Object> m2 : list2) {
		%>		
			
	
				<tr>
						<td><%=(Integer)(m2.get("부서ID"))%></td>
						<td><%=(String)(m2.get("직무ID"))%></td>
						<td><%=(Integer)(m2.get("부서인원"))%></td>
	
				</tr>
			
			
			
			
		<%		
			}
		%>
	</table>
	
	
	<table border="1">
		<h1>group by cube를 사용한 테이블</h1>
		<tr>
			<td>부서ID</td>
			<td>직무ID</td>
			<td>부서인원ID</td>
	
		</tr>
		<% 
			for(HashMap<String, Object> m3 : list3) {
		%>		
			
	
				<tr>
						<td><%=(Integer)(m3.get("부서ID"))%></td>
						<td><%=(String)(m3.get("직무ID"))%></td>
						<td><%=(Integer)(m3.get("부서인원"))%></td>
	
				</tr>
			
			
			
			
		<%		
			}
		%>
	</table>
	
	
</body>
</html>