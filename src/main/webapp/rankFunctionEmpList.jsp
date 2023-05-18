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
	
	
	
	//페이징
	
	int totalRow = 0;
	String totalRowSql = "select count(*) from employees";
	PreparedStatement totalRowstmt = conn.prepareStatement(totalRowSql);
	ResultSet totalRowRs = totalRowstmt.executeQuery();
		if(totalRowRs.next()){
			
			totalRow = totalRowRs.getInt(1); //=("count(*)") //lastPage 는 rowPerPage로 정해진다
		}
	
	//마지막 행 구하기
	
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage +1;
	int endRow = beginRow + (rowPerPage-1); //endrow는 무엇을 기준으로?
			
		if(endRow > totalRow){
			
			endRow = totalRow;
		}
			
	/*
	SELECT employee_id, last_name, salary, rank() over(order by salary desc) 급여순위
        from employees;
	*/
			
	//쿼리문		
	//where절에 '급여순위' 알리언스를 사용하기 위해 from 절에 서브쿼리를 사용함
	String sql = "select 직원ID, 이름, 연봉, 급여순위 from (select employee_id 직원ID, last_name 이름, salary 연봉, rank() over(order by salary desc) 급여순위 from employees) where 급여순위 between ? and ?";

	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println(stmt + "<-rankFunctionEmpList stmt");
	stmt.setInt(1, beginRow); //페이징을 위한 stmt
	stmt.setInt(2, endRow);

	System.out.println(stmt +"<- rankFunctionEmpList stmt");
	
	ResultSet rs = stmt.executeQuery();

	
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();

	while(rs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("직원ID", rs.getInt("직원ID"));
		m.put("이름", rs.getString("이름"));
		m.put("연봉", rs.getString("연봉"));
		m.put("급여순위", rs.getInt("급여순위"));
		list.add(m);
		
	
		}

	System.out.println(list.size()+"<- rankFunctionEmpList list.size"); //10 확인
	
	
	
	
	
	
%>





<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
		<h1>rankfunctionEmpList</h1>
		
	<table class="container">
	
		<tr>
			<td>직원ID</td>
			<td>이름</td>
			<td>연봉</td>
			<td>급여순위</td>
	
		</tr>
		
		<% 
			for(HashMap<String, Object> m : list) {
		%>		
			
	
				<tr>
						<td><%=(Integer)(m.get("직원ID"))%></td>
						<td><%=(String)(m.get("이름"))%></td>
						<td><%=(String)(m.get("연봉"))%></td>
						<td><%=(Integer)(m.get("급여순위"))%></td>
	
				</tr>
			
		<%		
		}
		%>
		
	</table>
	
	
	<%
		//페이징 1234 네비게이션
	
	
	/*	cp	minpage-maxpage
	
		1		1-10
		2		1-10
		10		1-10
		
		11		11-20
		12		11-20
		20		11-20
		
		(cp-1) / pagePerPage * pagePerPage + 1 --> minPage
		minPage+(pagePerPage-1) --> maxPage
		maxPage < lastPage --> maxPage = lastPage
		
		
		___________________________________________________
		
		ex) 1-10 
			1			(page)
			
			11-20
			1 2
			
			21-30
			3page
		
		
		
		
	*/
	//마지막 페이지가 10으로 떨어지지 않으니까
	
	int lastPage = totalRow / rowPerPage;	//마지막 페이지는 전체 행에서 페이지 당 보이는 행(현재 10)을 나눈다
	if(totalRow % rowPerPage != 0){ 	//나눈 값이 0으로 떨어지지 않을 때
		lastPage = lastPage +1; 	// '나머지 게시글'을 위한 1 페이지 생성
	}
	// '이전'과 '다음' 사이의 항목 번호 개수
	int pagePerPage = 10;//페이징 버튼 수
	
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
		      if(minPage > 1) {	// 1페이지에 해당할 때 이전 버튼은 사라진다
						%>
						   <a href="<%=request.getContextPath()%>/rankFunctionEmpList.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>   
						<%
						}
						
						for(int i = minPage; i<=maxPage; i=i+1) {
						   if(i == currentPage) {
						%>
						      <span><%=i%></span>&nbsp;
						<%         
						   } else {       //마지막 페이지에 해당할 때 다음 버튼은 사라진다
						%>
						      <a href="<%=request.getContextPath()%>/rankFunctionEmpList.jsp?currentPage=<%=i%>"><%=i%></a>&nbsp;   
						<%   
						   }
						}
						
						if(maxPage != lastPage) {
						%>
						   <!--  maxPage + 1 -->
						   <a href="<%=request.getContextPath()%>/rankFunctionEmpList.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
						<%
					 	      }
	
						%>
		</div>				
</body>
</html>