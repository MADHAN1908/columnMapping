package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import org.json.*;

/**
 * Servlet implementation class GetColumns
 */
@WebServlet("/GetColumns")
public class GetColumns extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetColumns() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		response.getWriter().append("Served at: ").append(request.getContextPath());
		response.setContentType("text/html");
        PrintWriter out = response.getWriter();
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
		    out.flush();

//		   return  cols.toString();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
