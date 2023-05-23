<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%
	/*
	level() : 해당 차수를 표시한다
	lpad() : 공백 추가
	SYS_CONNECT_BY_PATH : 루트 찾아가기
	
	*/

	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		
	}
	
	
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	
	
	
	//쿼리문		
	/*
	SELECT level, lpad(' ', level-1)||  first_name, manager_id, SYS_CONNECT_BY_PATH(first_name,'->'), 
    CONNECT_BY_ROOT(first_name)
    FROM employees 
    start with manager_id is null CONNECT BY PRIOR employee_id = manager_id ;
	*/
	String sql = "SELECT level, lpad(' ', level-1)||  first_name 이름, manager_id, SYS_CONNECT_BY_PATH(first_name,'->') PATH, CONNECT_BY_ROOT(first_name) MANAGER FROM employees start with manager_id is null CONNECT BY PRIOR employee_id = manager_id";
	
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println(stmt + "<-start_with_cunnect_by_prior_list stmt");
	
	ResultSet rs = stmt.executeQuery();
	
	System.out.println(stmt);
	
	//vo 대신 해시맵을 이용
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	
	while(rs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("이름", rs.getString("이름"));
		//lpad(' ', level-1)||  first_name의 알리언스를 이름으로 설정
		m.put("manager_id", rs.getInt("manager_id"));
		m.put("PATH", rs.getString("PATH"));
		m.put("MANAGER", rs.getString("MANAGER"));

		list.add(m);
		
	
		}
	
	System.out.println(list.size()+"<-list.size");
	


%>




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>start_with_cunnect_by_prior_list</title>
</head>
<body>
	<h1>start_with_cunnect_by_prior_list</h1>
	<table class="container">
	
	<tr>

		<td>이름</td>
		<td>매니저id</td>
		<td>계층도</td>
		<td>상사</td>

	</tr>
	
	<% 
		for(HashMap<String, Object> m : list) {
	%>		
		

			<tr>
					<!-- Stirng과 Int를 잘 구분해야 한다 //틀릴 시 sql 부적합한 열 에러 발생 -->
					<td><%=(String)(m.get("이름"))%></td>
					<td><%=(Integer)(m.get("manager_id"))%></td>
					<td><%=(String)(m.get("PATH"))%></td>
					<td><%=(String)(m.get("MANAGER"))%></td>

			</tr>
		
	<%		
	}
	%>
	</table>
	
</body>
</html>