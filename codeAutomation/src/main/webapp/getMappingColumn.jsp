<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,org.json.*" %>
<%
    String table = request.getParameter("table");
    JSONArray cols = new JSONArray();

    try {
        Class.forName("org.postgresql.Driver");
        String url = "jdbc:postgresql://localhost:5432/perfix_dev";
        String user = "postgres";
        String password = "";

        Connection conn = DriverManager.getConnection(url, user, password);
        String sql = "select distinct mapping_name from public.mapping_table where table_name = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, table);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            JSONObject col = new JSONObject();
            col.put("name", rs.getString("mapping_name"));
            cols.put(col);
        }

        conn.close();
    } catch (Exception e) {
        response.setStatus(500);
    }

    out.print(cols.toString());
%>
