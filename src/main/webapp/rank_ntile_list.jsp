<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%
	/*분석함수 중
		집계분석함수
		순위분석함수(rank() over() / dense_rank() over() / row_number() over() )
		순서분석
		비율분석함수(sum() over() ntile()//그룹을 n개로 나누어 어떤 그룹에 속하는지 over())
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
	
	
	//!!!!!!!!!!!!!!!!!!!!!!!!!!! 집계분석함수 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	//쿼리문		
	/*
	>전체 직원의 평균 연봉 구하기
	
	select first_name, salary, round( avg(salary) over()) 전체평균연봉
	from employees; 

	*/
	
	//※sql 스트링에 세미콜론을 넣지 않도록 주의
		String avgSql = "SELECT first_name 이름, salary 연봉, round( avg(salary) over()) 전체평균연봉 FROM employees";
		
		PreparedStatement avgStmt = conn.prepareStatement(avgSql);
		System.out.println(avgStmt + "<-start_with_cunnect_by_prior_list stmt");
		
		ResultSet rs = avgStmt.executeQuery();
		
		System.out.println(avgStmt);
		
		//vo 대신 해시맵을 이용
		ArrayList<HashMap<String, Object>> avgList = new ArrayList<HashMap<String, Object>>();
		
		while(rs.next()) {
			HashMap<String, Object> m1 = new HashMap<String, Object>();
			m1.put("이름", rs.getString("이름"));
			m1.put("연봉", rs.getInt("연봉"));
			m1.put("전체평균연봉", rs.getInt("전체평균연봉"));
	
			avgList.add(m1);
			
		
			}
		
		System.out.println(avgList.size()+"<-avgList.size");
	
	//!!!!!!!!!!!!!!!!!!!!!!!!!!! 순위분석함수 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//쿼리문		
		/*
		>전체 직원의 연봉 순위 높은 순으로 구하기
		
		select first_name 이름, salary 연봉, rank() over(order by salary desc) 연봉순위
		from employees;
	
		*/
		
		//※sql 스트링에 세미콜론을 넣지 않도록 주의
	
		
		String rankSql = "SELECT first_name 이름, salary 연봉, rank() over(order by salary ) as 연봉순위 FROM employees";
		
		PreparedStatement rankStmt = conn.prepareStatement(rankSql);
	
		ResultSet rankRs = rankStmt.executeQuery();
		
		System.out.println(rankStmt + "<-start_with_cunnect_by_prior_list stmt");
		
		//vo 대신 해시맵을 이용
		ArrayList<HashMap<String, Object>> rankList = new ArrayList<HashMap<String, Object>>();
			//쿼리문이 여러개인 경우, while 문 안의 rs 이름을 틀리지 않게 주의
			//rs매칭이 안됐을 때 나오는 에러: java.sql.SQLException: 결과 집합을 모두 소모했음
			while(rankRs.next()) {
				HashMap<String, Object> m2 = new HashMap<String, Object>();
				m2.put("이름", rankRs.getString("이름"));
				m2.put("연봉", rankRs.getInt("연봉"));
				m2.put("연봉순위", rankRs.getInt("연봉순위"));
		
				rankList.add(m2);
				
			
				}
			
		System.out.println(rankList.size()+"<-rankList.size");
		
	
	
	//!!!!!!!!!!!!!!!!!!!!!!!!!!! 순서분석함수 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//쿼리문		
		/*
		>부서별 연봉 순위 사람 높은 순으로 출력
		
		select first_name 이름, salary 연봉, department_id 부서번호, first_value(first_name) over(partition by department_id order by salary desc)부서별최고연봉자
		from employees;

		*/

		
		String firstSql = "select first_name 이름, salary 연봉, department_id 부서번호, first_value(first_name) over(partition by department_id order by salary desc) as 최고연봉자 from employees";
		
		PreparedStatement firstStmt = conn.prepareStatement(firstSql);

		ResultSet firstRs = firstStmt.executeQuery();
		
		System.out.println(firstStmt + "<-start_with_cunnect_by_prior_list firstStmt");
		
		//vo 대신 해시맵을 이용
		ArrayList<HashMap<String, Object>> firstList = new ArrayList<HashMap<String, Object>>();
		
			while(firstRs.next()) {
				HashMap<String, Object> m3 = new HashMap<String, Object>();
				m3.put("이름", firstRs.getString("이름"));
				m3.put("연봉", firstRs.getInt("연봉"));
				m3.put("부서번호", firstRs.getInt("부서번호"));
				m3.put("최고연봉자", firstRs.getString("최고연봉자"));
		
				firstList.add(m3);
				
			
				}
			
		System.out.println(firstList.size()+"<-fisrtList.size");
		
		
		
	//!!!!!!!!!!!!!!!!!!!!!!!!!!! 비율분석함수 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			//쿼리문		
			/*
			급여를 높은 순으로 12등급으로 나눔
			
			
			select first_name 이름, salary 연봉, ntile(12)over(order by salary desc) as 그룹
			from employees;

			*/

			
			String sumSql = "select first_name 이름, salary 연봉, ntile(12) over(order by salary desc) as 그룹 from employees";
			
			PreparedStatement sumStmt = conn.prepareStatement(sumSql);

			ResultSet sumRs = sumStmt.executeQuery();
			
			System.out.println(sumStmt + "<-start_with_cunnect_by_prior_list firstStmt");
			
			//vo 대신 해시맵을 이용
			ArrayList<HashMap<String, Object>> sumList = new ArrayList<HashMap<String, Object>>();
			
				while(sumRs.next()) {
					HashMap<String, Object> m4 = new HashMap<String, Object>();
					m4.put("이름", sumRs.getString("이름"));
					m4.put("연봉", sumRs.getInt("연봉"));
					m4.put("그룹", sumRs.getInt("그룹"));

					sumList.add(m4);
					
				
					}
				
			System.out.println(sumList.size()+"<-sumList.size");


%>




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>start_with_cunnect_by_prior_list</title>
</head>
<body>

	<h1>집계분석함수</h1>
	
		<table>
	
				<tr>
					<td>이름</td>
					<td>연봉</td>
					<td>전체평균연봉</td>
					
				</tr>
				<% 
					for(HashMap<String, Object> m1 : avgList) {
				%>		
					
			
						<tr>
								<td><%=(String)(m1.get("이름"))%></td>
								<td><%=(Integer)(m1.get("연봉"))%></td>
								<td><%=(Integer)(m1.get("전체평균연봉"))%></td>
			
						</tr>
					
					
					
					
				<%		
					}
				%>
		</table>

	
	<h1>순위분석함수</h1>
		
		<table>
		
			<tr>
				<td>이름</td>
				<td>연봉</td>
				<td>연봉순위</td>
				
			</tr>
			<% 
				for(HashMap<String, Object> m2 : rankList) {
			%>		
				
		
					<tr>
							<td><%=(String)(m2.get("이름"))%></td>
							<td><%=(Integer)(m2.get("연봉"))%></td>
							<td><%=(Integer)(m2.get("연봉순위"))%></td>
		
					</tr>
				
				
				
				
			<%		
				}
			%>
		</table>
	
	<h1>순서분석함수</h1>
		
		<table>
		
			<tr>
				<td>이름</td>
				<td>연봉</td>
				<td>부서번호</td>
				<td>부서별최고연봉자</td>
				
			</tr>
			<% 
				for(HashMap<String, Object> m3 : firstList) {
			%>		
				
		
					<tr>
							<td><%=(String)(m3.get("이름"))%></td>
							<td><%=(Integer)(m3.get("연봉"))%></td>
							<td><%=(Integer)(m3.get("부서번호"))%></td>
							<td><%=(String)(m3.get("최고연봉자"))%></td>
		
					</tr>
				
				
				
				
			<%		
				}
			%>
		</table>
	
	
	
	<h1>비율분석함수</h1>
		
		<table>
		
			<tr>
				<td>이름</td>
				<td>연봉</td>
				<td>그룹</td>
				
			</tr>
			<% 
				for(HashMap<String, Object> m4 : sumList) {
			%>		
				
		
					<tr>
							<td><%=(String)(m4.get("이름"))%></td>
							<td><%=(Integer)(m4.get("연봉"))%></td>
							<td><%=(Integer)(m4.get("그룹"))%></td>
		
					</tr>
				
				
				
				
			<%		
				}
			%>
		</table>
</body>
</html>