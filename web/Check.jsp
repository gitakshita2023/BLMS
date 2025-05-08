<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Structure Check</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #333; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .error { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <h1>Database Structure Check</h1>
    
    <%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    try {
        // Load the JDBC driver
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        
        // Establish connection
        String url = "jdbc:derby://localhost:1527/blms;create=true";
        String dbUser = "akshita";
        String dbPassword = "akshita";
        
        conn = DriverManager.getConnection(url, dbUser, dbPassword);
        DatabaseMetaData dbmd = conn.getMetaData();
        
        // Get all tables
        out.println("<h2>Tables in Database</h2>");
        out.println("<table>");
        out.println("<tr><th>Table Name</th></tr>");
        
        rs = dbmd.getTables(null, "AKSHITA", "%", new String[]{"TABLE"});
        while (rs.next()) {
            String tableName = rs.getString("TABLE_NAME");
            out.println("<tr><td>" + tableName + "</td></tr>");
        }
        out.println("</table>");
        
        // Get columns for each table
        rs = dbmd.getTables(null, "AKSHITA", "%", new String[]{"TABLE"});
        while (rs.next()) {
            String tableName = rs.getString("TABLE_NAME");
            out.println("<h3>Columns in " + tableName + "</h3>");
            out.println("<table>");
            out.println("<tr><th>Column Name</th><th>Type</th><th>Size</th><th>Nullable</th></tr>");
            
            ResultSet columns = dbmd.getColumns(null, "AKSHITA", tableName, null);
            while (columns.next()) {
                String columnName = columns.getString("COLUMN_NAME");
                String dataType = columns.getString("TYPE_NAME");
                int columnSize = columns.getInt("COLUMN_SIZE");
                boolean nullable = columns.getInt("NULLABLE") == DatabaseMetaData.columnNullable;
                
                out.println("<tr>");
                out.println("<td>" + columnName + "</td>");
                out.println("<td>" + dataType + "</td>");
                out.println("<td>" + columnSize + "</td>");
                out.println("<td>" + (nullable ? "Yes" : "No") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        }
        
        // Test a simple query on AUTHORIZED_USERS
        out.println("<h2>Test Query on AUTHORIZED_USERS</h2>");
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT * FROM AUTHORIZED_USERS");
            
            out.println("<table>");
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnCount = rsmd.getColumnCount();
            
            // Print column headers
            out.println("<tr>");
            for (int i = 1; i <= columnCount; i++) {
                out.println("<th>" + rsmd.getColumnName(i) + "</th>");
            }
            out.println("</tr>");
            
            // Print data rows
          while (rs.next()) {
                out.println("<tr>");
                for (int i = 1; i <= columnCount; i++) {
                    out.println("<td>" + rs.getString(i) + "</td>");
                }
                out.println("</tr>");
            }
            out.println("</table>");
        } catch (SQLException e) {
            out.println("<p class='error'>Error querying AUTHORIZED_USERS: " + e.getMessage() + "</p>");
        }
        
    } catch (Exception e) {
        out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.println("<p class='error'>Error closing resources: " + e.getMessage() + "</p>");
        }
    }
    %>
</body>
</html>
