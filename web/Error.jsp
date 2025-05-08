<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Error Page</title>
    </head>
    <body>
        <p>
            <%
                String message = request.getParameter("message");
                if(message != null) {
                    out.print(message);
                } else {
                    out.print("An unknown error occurred.");
                }
            %>
        </p>
        <a href="LoginPage.jsp">Go back to login page</a>
    </body>
</html>
