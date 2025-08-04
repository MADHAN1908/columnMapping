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
        String sql = "SELECT * FROM information_schema.columns WHERE table_name = ? Order by ordinal_position";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, table);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            JSONObject col = new JSONObject();
            col.put("name", rs.getString("column_name"));
            col.put("type", rs.getString("udt_name"));
            col.put("length", rs.getString("character_maximum_length"));
            cols.put(col);
        }

        conn.close();
    } catch (Exception e) {
        response.setStatus(500);
    }

    out.print(cols.toString());
%>
