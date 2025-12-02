<%--

       Copyright 2010-2025 the original author or authors.

       Licensed under the Apache License, Version 2.0 (the "License");
       you may not use this file except in compliance with the License.
       You may obtain a copy of the License at

          https://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.

--%>
<%@ include file="../common/IncludeTop.jsp"%>

<div id="Catalog"><stripes:form
    beanclass="org.mybatis.jpetstore.web.actions.AccountActionBean"
    focus="" onsubmit="return validateEditForm();">

    <stripes:hidden name="username" value="${actionBean.username}" />

    <h3>User Information</h3>

    <table>
       <tr>
          <td>User ID:</td>
          <td>${actionBean.username}</td>
       </tr>
       <tr>
          <td>New password:</td>
          <td><stripes:text name="password" /></td>
       </tr>
       <tr>
          <td>Repeat password:</td>
          <td><stripes:text name="repeatedPassword" /></td>
       </tr>
    </table>
    <%@ include file="IncludeAccountFields.jsp"%>

    <stripes:submit name="editAccount" value="Save Account Information" />

    <script>
    function validateEditForm() {
        var password = document.getElementsByName('password')[0].value.trim();
        var repeatedPassword = document.getElementsByName('repeatedPassword')[0].value.trim();
        var firstName = document.getElementsByName('account.firstName')[0].value.trim();
        var lastName = document.getElementsByName('account.lastName')[0].value.trim();
        var email = document.getElementsByName('account.email')[0].value.trim();
        var phone = document.getElementsByName('account.phone')[0].value.trim();
        var address1 = document.getElementsByName('account.address1')[0].value.trim();
        var city = document.getElementsByName('account.city')[0].value.trim();
        var state = document.getElementsByName('account.state')[0].value.trim();
        var zip = document.getElementsByName('account.zip')[0].value.trim();
        var country = document.getElementsByName('account.country')[0].value.trim();

        if (!password || !repeatedPassword || !firstName || !lastName ||
            !email || !phone || !address1 || !city || !state || !zip || !country) {
            alert('Please fill in all required fields.');
            return false;
        }
        if (password !== repeatedPassword) {
            alert('Passwords do not match.');
            return false;
        }
        return true;
    }
    </script>

</stripes:form> <stripes:link
    beanclass="org.mybatis.jpetstore.web.actions.OrderActionBean"
    event="listOrders">My Orders</stripes:link></div>

<%@ include file="../common/IncludeBottom.jsp"%>
