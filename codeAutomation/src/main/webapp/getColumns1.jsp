<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String table = request.getParameter("table");
    StringBuilder json = new StringBuilder("[");
    boolean first = true;

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
            if (!first) json.append(",");
            first = false;

            String colName = rs.getString("COLUMN_NAME");
            String colType = rs.getString("DATA_TYPE");

            json.append("{\"name\":\"").append(colName)
                .append("\",\"type\":\"").append(colType).append("\"}");
        }

        conn.close();
    } catch (Exception e) {
        response.setStatus(500);
        out.print("[]");
        return;
    }

    json.append("]");
    out.print(json.toString());
%>
