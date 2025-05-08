<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // Get form data
    String teacherId = request.getParameter("teacherId");
    String userId = request.getParameter("userId");
    String teacherName = request.getParameter("teacherName");
    String designation = request.getParameter("designation");
    String subjectSpecialization = request.getParameter("subjectSpecialization");
    String teacherPhoneNo = request.getParameter("teacherPhoneNo");
    String teacherEmail = request.getParameter("teacherEmail");
    String teacherPassword = request.getParameter("teacherPassword");
    String teacherAddress = request.getParameter("teacherAddress");
    
    // Get the arrays of subject codes and class section IDs
    String[] subjectCodes = request.getParameterValues("subjectCode[]");
    String[] classSectionIds = request.getParameterValues("classSectionId[]");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        // Load the JDBC driver
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        
        // Establish connection
        String url = "jdbc:derby://localhost:1527/blms;create=true";
        String dbUser = "akshita";
        String dbPassword = "akshita";
        
        conn = DriverManager.getConnection(url, dbUser, dbPassword);
        conn.setAutoCommit(false); // Start transaction
        
        // Check if the email is authorized and not already registered
        try {
            pstmt = conn.prepareStatement("SELECT * FROM AUTHORIZED_USERS WHERE EMAIL = ? AND IS_REGISTERED = FALSE");
            pstmt.setString(1, teacherEmail);
            rs = pstmt.executeQuery();
            
            if (!rs.next()) {
                // Email not authorized or already registered
                response.sendRedirect("RegisterTeacher.jsp?error=unauthorized");
                return;
            }
        } catch (SQLException e) {
            System.out.println("Error in authorized users check: " + e.getMessage());
            throw e;
        }
        
        // 1. Insert into Users table
        try {
            // Get the next available Login_id
            Statement stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT COALESCE(MAX(LOGIN_ID), 0) + 1 AS NEXT_ID FROM USERS");
            int nextLoginId = 1; // Default if no records exist
            if (rs.next()) {
                nextLoginId = rs.getInt("NEXT_ID");
            }
            
            pstmt = conn.prepareStatement("INSERT INTO USERS (LOGIN_ID, USER_ID, PASSWORD, USER_ROLE) VALUES (?, ?, ?, ?)");
            pstmt.setInt(1, nextLoginId);
            pstmt.setString(2, userId);
            pstmt.setString(3, teacherPassword);
            pstmt.setString(4, "TEACHER");
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error inserting into USERS: " + e.getMessage());
            throw e;
        }
        
        // 2. Insert into Teacher_Info table
        try {
            pstmt = conn.prepareStatement("INSERT INTO TEACHER_INFO (TEACHER_ID, USER_ID, PASSWORD, TEACHER_NAME, DESIGNATION, SUBJECT_SPECIALIZATION, TEACHER_PHONENO, TEACHER_EMAIL) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
            pstmt.setString(1, teacherId);
            pstmt.setString(2, userId);
            pstmt.setString(3, teacherPassword);
            pstmt.setString(4, teacherName);
            pstmt.setString(5, designation);
            pstmt.setString(6, subjectSpecialization);
            pstmt.setInt(7, Integer.parseInt(teacherPhoneNo));
            pstmt.setString(8, teacherEmail);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error inserting into TEACHER_INFO: " + e.getMessage());
            throw e;
        }
        
        // 3. Insert into Department_Info table - DEPT_ID is auto-generated
        try {
            pstmt = conn.prepareStatement("INSERT INTO DEPARTMENT_INFO (TEACHER_ID, TEACHER_ADDRESS) VALUES (?, ?)");
            pstmt.setString(1, teacherId);
            pstmt.setString(2, teacherAddress);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error inserting into DEPARTMENT_INFO: " + e.getMessage());
            throw e;
        }
        
        // 4. Insert into Teacher_Subject_Mapping table for each subject code and class section ID pair
        if (subjectCodes != null && classSectionIds != null) {
            try {
                pstmt = conn.prepareStatement("INSERT INTO TEACHER_SUBJECT_MAPPING (TEACHER_ID, SUBJECT_CODE, CLASS_SECTION_ID) VALUES (?, ?, ?)");
                
                for (int i = 0; i < subjectCodes.length; i++) {
                    if (subjectCodes[i] != null && !subjectCodes[i].trim().isEmpty() &&
                        classSectionIds[i] != null && !classSectionIds[i].trim().isEmpty()) {
                        
                        pstmt.setString(1, teacherId);
                        pstmt.setString(2, subjectCodes[i].trim());
                        pstmt.setInt(3, Integer.parseInt(classSectionIds[i].trim()));
                        pstmt.executeUpdate();
                    }
                }
            } catch (SQLException e) {
                System.out.println("Error inserting into TEACHER_SUBJECT_MAPPING: " + e.getMessage());
                throw e;
            }
        }
        
        // 5. Update the Authorized_Users table to mark the user as registered
        try {
            pstmt = conn.prepareStatement("UPDATE AUTHORIZED_USERS SET IS_REGISTERED = TRUE WHERE EMAIL = ?");
            pstmt.setString(1, teacherEmail);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error updating AUTHORIZED_USERS: " + e.getMessage());
            throw e;
        }
        
        // Commit the transaction
        conn.commit();
        
        // Redirect to success page
        response.sendRedirect("RoleBasedPage.jsp?success=true");
        
    } catch (Exception e) {
        // Roll back the transaction in case of error
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        
        // Redirect to error page with message
        response.sendRedirect("RegisterTeacher.jsp?error=failed&message=" + e.getMessage());
        e.printStackTrace();
    } finally {
        // Close resources
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
