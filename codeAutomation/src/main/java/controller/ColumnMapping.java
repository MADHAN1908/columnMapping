package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Servlet implementation class ColumnMapping
 */
@WebServlet("/columnMapping")
public class ColumnMapping extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ColumnMapping() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		doGet(request, response);
		response.setContentType("text/html");
        PrintWriter out = response.getWriter();
		String table = request.getParameter("table_name");
		String mappingTableName = request.getParameter("mapping_table_name");
		out.println("Table :"+ table);
		out.println("Mapping Table :"+ mappingTableName);
		try {
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://localhost:5432/perfix_dev";
            String user = "postgres";
            String password = ""; 

            Connection conn = DriverManager.getConnection(url, user, password);

            if (conn != null) {
            	String sql = "SELECT * FROM information_schema.columns WHERE table_name = ? Order by ordinal_position";
            	PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, table);
                ResultSet rs = stmt.executeQuery();

                boolean hasData = false;
                while (rs.next()) {
                    hasData = true;
                    String id = getNextId(conn);
                    
                    String columnName = rs.getString("column_name");
                    String columnId = request.getParameter(columnName+"_id");
                    String userDefinedName = request.getParameter(columnName);
                    String visibleString = request.getParameter(columnName+"_visibility");
                    String visible = visibleString != null  ? "1" : "0";
                    int position = Integer.parseInt(request.getParameter(columnName+"_position"));
//                   String visible = visibleString == null  visibleString.equals("on") ? "1" : "0";
                    
                    out.println("Column Name :" + columnName +"<br>");
                    out.println("Mapping Name :" + userDefinedName+"<br>");
                    out.println("Visibility :" + visible+"<br>");
                    out.println("Position :" + position+"<br>");
                    
                    if(columnId != null) {
                    	String updateSql = "update mapping_table set mapping_name = ?,user_defined_name = ?,visibility = ?,column_position = ? Where mt_KeyId = ?";
                    	PreparedStatement pstmt = conn.prepareStatement(updateSql);
                    	pstmt.setString(1, mappingTableName);
                        pstmt.setString(2, userDefinedName);
                        pstmt.setString(3, visible);
                        pstmt.setInt(4,position);
                        pstmt.setString(5, columnId);
                        
                        boolean isUpdated = pstmt.executeUpdate() > 0;
                        if(isUpdated) {
                        	out.println("Column :<span class=\"text-green-800\">"+columnName+" Updated "+"</span><br>" );
                        }else {
                        	out.println("Column :<span class=\"text-red-800\">"+columnName+" Update Failed "+"</span><br>" );
                        }
                    }else {
                    	String insertSql = "insert into mapping_table(mt_keyId,table_name,mapping_name,column_name,user_defined_name,visibility,column_position) values(?,?,?,?,?,?,?)";
                    	PreparedStatement pstmt = conn.prepareStatement(insertSql);
                    	pstmt.setString(1, id);
                        pstmt.setString(2, table);
                        pstmt.setString(3,mappingTableName );
                        pstmt.setString(4, columnName);
                        pstmt.setString(5, userDefinedName);
                        pstmt.setString(6, visible);
                        pstmt.setInt(7,position);
                        boolean isInserted = pstmt.executeUpdate() > 0;
                        if(isInserted) {
                        	out.println("Column :<span class=\"text-green-800\">"+columnName+" Inserted "+"<br>" );
                        }else {
                        	out.println("Column :<span class=\"text-red-800\">"+columnName+" Inserte Failed "+"</span><br>" );
                        }	
                    }
                    
                    

                }

                if (!hasData) {
                    out.println("No Tables Found");
                }

                conn.close();
            } else {
                out.println("Connection Failed");
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage() );
        }
		
	}
	
	protected String getNextId(Connection con) throws SQLException {
		
		String sql = "SELECT MAX(mt_keyId) FROM mapping_table WHERE mt_keyId LIKE 'MT%'";
		PreparedStatement stmt = con.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();

		String newId = "MT0001";
		if (rs.next() && rs.getString(1) != null) {
		    String lastId = rs.getString(1); 
		    int num = Integer.parseInt(lastId.substring(4)) + 1;
		    newId = String.format("MT%04d", num);  
		}
		return newId;
		
	}

}
