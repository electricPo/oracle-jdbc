<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>


<%	
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
		
		
		int rowPerPage = 10;
		int beginRow = (currentPage-1)*rowPerPage +1;
		int endRow = beginRow + (rowPerPage-1); //endrow는 무엇을 기준으로?
		
		//페이징
		
		int totalRow = 0;
		String totalRowSql = "select count(*) from employees";
		PreparedStatement totalRowstmt = conn.prepareStatement(totalRowSql);
		ResultSet totalRowRs = totalRowstmt.executeQuery();
			if(totalRowRs.next()){
				
				totalRow = totalRowRs.getInt(1); //=("count(*)") //lastPage 는 rowPerPage로 정해진다
			}
		
		//마지막 행 구하기
		
		
			
		if(endRow > totalRow){
			
			endRow = totalRow;
		}
				
						

		
		
		
		
		
		/* 쿼리문
		
		SELECT employee_id, last_name, salary, round (AVG(salary) OVER()) 전체급여평균,
            sum(salary) over() 전체급여합계,
            count(*) over() 전체사원수
        from employees;
		
		*/
		
		String sql = "select 번호, 직원ID, 이름, 연봉, 전체급여평균, 전체급여합계, 전체사원수 from (select rownum 번호, employee_id 직원ID, last_name 이름, salary 연봉, round(avg(salary) over()) 전체급여평균, sum(salary) over() 전체급여합계, count(*) over() 전체사원수 from employees) where 번호 between ? and ?";
		//where절에 '급여순위' 알리언스를 사용하기 위해 from 절에 서브쿼리를 사용함
		PreparedStatement stmt = conn.prepareStatement(sql);
		System.out.println(stmt + "<-groupbyfunction stmt1");
		stmt.setInt(1, beginRow); //페이지 구현을 위한 stmt
		stmt.setInt(2, endRow);
		ResultSet rs = stmt.executeQuery();
		
		System.out.println(stmt + "<-windowFunctionEmpList stmt");
		
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		//while 문 안의 rs 이름을 틀리지 않게 주의
		//rs매칭이 안됐을 때 나오는 에러: java.sql.SQLException: 결과 집합을 모두 소모했음
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("직원ID", rs.getInt("직원ID"));
			m.put("이름", rs.getString("이름"));
			m.put("연봉", rs.getInt("연봉"));
			m.put("전체급여평균", rs.getInt("전체급여평균"));
			m.put("전체급여합계", rs.getInt("전체급여합계"));
			m.put("전체사원수", rs.getInt("전체사원수"));
			list.add(m);

		
			}
		System.out.println(list.size() + "<windowFunctionEmpList list.size()");

		
		
		

		
		
	
%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>


	<h1>windowsFunctionEmpList</h1>
	<table class="container">
		
		<tr>
			<td>직원ID</td>
			<td>이름</td>
			<td>연봉</td>
			<td>전체급여평균</td>
			<td>전체급여합계</td>
			<td>전체사원수</td>
	
		</tr>
		
		<% 
			for(HashMap<String, Object> m : list) {
		%>		
			
	
				<tr>
						<td><%=(Integer)(m.get("직원ID"))%></td>
						<td><%=(String)(m.get("이름"))%></td>
						<td><%=(Integer)(m.get("연봉"))%></td>
						<td><%=(Integer)(m.get("전체급여평균"))%></td>
						<td><%=(Integer)(m.get("전체급여합계"))%></td>
						<td><%=(Integer)(m.get("전체사원수"))%></td>
					</tr>
			
		<%		
		}
		%>
	</table>
		<%
		//마지막 페이지가 10으로 떨어지지 않으니까
		
		int lastPage = totalRow / rowPerPage; //마지막 페이지는 전체 행에서 페이지 당 보이는 행(현재 10)을 나눈다
		if(totalRow % rowPerPage != 0){ //나눈 값이 0으로 떨어지지 않을 때
			lastPage = lastPage +1; // '나머지 게시글'을 위한 1 페이지 생성
		}
		
		// '이전'과 '다음' 사이의 항목 번호 개수
		int pagePerPage = 10; //페이징 버튼 수
		
		int minPage = ((currentPage-1)/pagePerPage) * pagePerPage + 1;
		//1 11 21 31
		
		int maxPage = minPage +(pagePerPage -1);
		//10 20 30 40
		
		if(maxPage > lastPage){ 
			maxPage = lastPage;
		}
		
		 %>
		 
		<div class="container text-center">
		<% 
		      if(minPage > 1) { // 1페이지에 해당할 때 이전 버튼은 사라진다
						%>
						   <a href="<%=request.getContextPath()%>/windowsFunctionEmpList.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>   
						<%
						}
						
						for(int i = minPage; i<=maxPage; i=i+1) {
						   if(i == currentPage) {
						%>
						      <span><%=i%></span>&nbsp;
						<%         
						   } else {      
						%>
						      <a href="<%=request.getContextPath()%>/windowsFunctionEmpList.jsp?currentPage=<%=i%>"><%=i%></a>&nbsp;   
						<%   
						   }
						}
						
						if(maxPage != lastPage) { //마지막 페이지에 해당할 때 다음 버튼은 사라진다
						%>
						   <!--  maxPage + 1 -->
						   <a href="<%=request.getContextPath()%>/windowsFunctionEmpList.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
						<%
					 	      }
	
						%>
		</div>	



</body>
</html>