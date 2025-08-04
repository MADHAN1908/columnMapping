<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,org.json.*" %>
<%
    String table = request.getParameter("table");
    String mappingTable = request.getParameter("mappingTable");
    JSONArray cols = new JSONArray();

    try {
        Class.forName("org.postgresql.Driver");
        String url = "jdbc:postgresql://localhost:5432/perfix_dev";
        String user = "postgres";
        String password = "";
        /* out.println("start"); */

        Connection conn = DriverManager.getConnection(url, user, password);
        /* out.println("con"); */
        String sql = "select m.*,c.character_maximum_length , c.udt_name from public.mapping_table m join information_schema.columns c on c.column_name = m.column_name where m.table_name = ? and c.table_name = ? and m.mapping_name = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, table);
        stmt.setString(2, table);
        stmt.setString(3,mappingTable);
        ResultSet rs = stmt.executeQuery();
        /* out.println("rs"); */
        

        while (rs.next()) {
        	/* out.println("row");
        	out.println(rs.getString("column_name"));
        	out.println(rs.getString("udt_name"));
        	out.println(rs.getInt("character_maximum_length"));
        	out.println(rs.getString("user_defined_name"));
        	out.println(rs.getString("visibilty"));
        	out.println(rs.getInt("column_position"));
        	
        	out.println("error"); */
            JSONObject col = new JSONObject();
        	col.put("id", rs.getString("mt_KeyId"));
            col.put("name", rs.getString("column_name"));
            col.put("type", rs.getString("udt_name"));
            col.put("length", rs.getInt("character_maximum_length"));
            col.put("user_defined_name", rs.getString("user_defined_name"));
            col.put("visibility", rs.getString("visibility"));
            col.put("position", rs.getInt("column_position"));
            col.put("mapping_table_name", rs.getString("mapping_name"));
            cols.put(col);
        }

        conn.close();
    } catch (Exception e) {
        response.setStatus(500);
/*         out.println("error"); */
    }

    out.print(cols.toString());
%>
