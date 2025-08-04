<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*,java.time.*,java.time.temporal.ChronoUnit"%>
<%@ page language="java" import="jakarta.servlet.*,jakarta.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Model Creation</title>
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class = "flex justify-center items-center min-h-screen  bg-gray-200">

 
       
        <div class="mt-20 w-full">
        <div class="flex-auto mr-2 text-center">
        <!-- <a href="users.jsp" class="text-white bg-green-500 w-1/2 p-2 text-lg rounded hover:bg-green-700"  >Close</a> -->
        <div  class="flex justify-center items-center " >
        <form method="POST" action="modelCreation"  class="bg-gray-100 border-4 border-blue-800 w-1/2 p-5 rounded-md flex flex-col h-auto max-h-[450px] m-5 md:max-w-[375px]">
        <h1 class="text-blue-800 text-center text-3xl mb-4">Model Creation</h1>
           
        <%-- <div class="flex items-center mb-2">
        <label class="flex-1 text-lg mr-2 text-left font-semibold" For="country"> Table   : </label>
        <div class="flex-auto">
        <select name="country_id" id="country" class="w-full p-1 border border-gray-300 rounded" >
        <option value="">Select Table</option>
        <%
        try { 
        	Class.forName("org.postgresql.Driver");
        	String url = "jdbc:postgresql://localhost:5432/prefix_dev";
            String user = "postgres";
            String password = "";
        	Connection conn = DriverManager.getConnection(url, user, password);
        	if(conn != null){
        	 Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("select * from information_schema.tables where table_schema = 'public'");
             if(rs != null){
             /* out.println("<option >"+rs+"</option>"); */
             while (rs.next()) {
                 out.println("<option value=\""+rs.getString("table_name")+"\">"+rs.getString("table_name")+"</option>");
             }
             }else{
         		out.println("<option >No Records</option>");
         	}
        	}else{
        		out.println("<option >Connection Failed</option>");
        	}
             conn.close();
        } catch (Exception e) {
          //  e.printStackTrace(out);
        }
        
        %>
        </select></div></div> --%>
        
        <div class="flex items-center mb-2">
    <label class="flex-1 text-lg mr-2 text-left font-semibold" for="table_name">Table:</label>
    <div class="flex-auto">
        <select name="table_name" id="table_name" class="w-full p-1 border border-gray-300 rounded">
            <option value="">Select Table</option>
            <%
                try {
                    Class.forName("org.postgresql.Driver");
                    String url = "jdbc:postgresql://localhost:5432/perfix_dev";
                    String user = "postgres";
                    String password = "";  // Make sure password is not empty if the user has one

                    Connection conn = DriverManager.getConnection(url, user, password);

                    if (conn != null) {
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT * FROM information_schema.tables WHERE table_schema = 'public'");

                        boolean hasData = false;
                        while (rs.next()) {
                            hasData = true;
                            String tableName = rs.getString("table_name");
                            out.println("<option value=\"" + tableName + "\">" + tableName + "</option>");
                        }

                        if (!hasData) {
                            out.println("<option>No Tables Found</option>");
                        }

                        conn.close();
                    } else {
                        out.println("<option>Connection Failed</option>");
                    }
                } catch (Exception e) {
                    out.println("<option>Error: " + e.getMessage() + "</option>");
                }
            %>
        </select>
    </div>
</div>
        
        

        <div id="btn" class="flex items-center mb-2">
        <button type="submit" class="text-white bg-green-500 w-full py-2 text-lg rounded hover:bg-green-700"  >Create Model</button>
        </div> </form> </div></div></div>


</body>
</html>