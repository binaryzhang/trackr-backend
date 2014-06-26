<%@ page import="org.springframework.security.core.AuthenticationException"%>
<%@ page import="org.springframework.security.oauth2.common.exceptions.UnapprovedClientAuthenticationException"%>
<%@ page import="org.springframework.security.web.WebAttributes" %>
<%@ taglib prefix="authz" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>TODO changeme</title>
    <link type="text/css" rel="stylesheet" href="/${proxyPath}/webjars/bootstrap/3.1.1/css/bootstrap.min.css" />
</head>

<body>
<div class="container">
    <%
        if (session.getAttribute(WebAttributes.AUTHENTICATION_EXCEPTION) != null
                && !(session
                .getAttribute(WebAttributes.AUTHENTICATION_EXCEPTION) instanceof UnapprovedClientAuthenticationException)) {
    %>
    <div class="error">
        <h2>Woops!</h2>

        <p>
            Access could not be granted. (<%=((AuthenticationException) session
                .getAttribute(WebAttributes.AUTHENTICATION_EXCEPTION))
                .getMessage()%>)
        </p>
    </div>
    <%
        }
    %>
    <c:remove scope="session" var="SPRING_SECURITY_LAST_EXCEPTION" />

    <authz:authorize ifAnyGranted="ROLE_EMPLOYEE,ROLE_SUPERVISOR,ROLE_ADMIN">
        <h2>Please Confirm</h2>
        <p>
            You hereby authorize "
            <c:out value="${client.clientId}" />
            " to access your protected resources.
        </p>

        <form class="form-horizontal" id="confirmationForm" name="confirmationForm" action="/${proxyPath}/oauth/authorize" method="post">
            <input name="user_oauth_approval" value="true" type="hidden" />
            <c:forEach items="${scopes}" var="scope">
                <c:set var="approved">
                    <c:if test="${scope.value}"> checked</c:if>
                </c:set>
                <c:set var="denied">
                    <c:if test="${!scope.value}"> checked</c:if>
                </c:set>
                <div class="form-group">
                    <label class="col-sm-2 control-label">${scope.key}:</label>
                    <div class="col-sm-10">
                        <label class="radio-inline">
                            <input type="radio" name="${scope.key}" value="true" ${approved}>Approve</input>
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="${scope.key}" value="false" ${denied}>Deny</input>
                        </label>
                    </div>
                </div>
            </c:forEach>
            <button class="btn btn-primary" type="submit">Submit</button>
        </form>

    </authz:authorize>
</div>

</body>
</html>
