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
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/IncludeTop.jsp"%>

<div id="BackLink">
    <stripes:link beanclass="org.mybatis.jpetstore.web.actions.ReviewActionBean" event="listReviews">
        Return to Review List
    </stripes:link>
</div>

<div id="Catalog">

    <stripes:form beanclass="org.mybatis.jpetstore.web.actions.ReviewActionBean">

        <h3>Write a New Review</h3>

        <table>
            <tr>
                <td>Username:</td>
                <td>
                    ${sessionScope.accountBean.account.username}
                </td>
            </tr>
            <tr>
                <td>Pet Type:</td>
                <td>
                    <stripes:select name="review.petType">
                        <stripes:option value="Cat">Cat</stripes:option>
                        <stripes:option value="Dog">Dog</stripes:option>
                        <stripes:option value="Bird">Bird</stripes:option>
                        <stripes:option value="Fish">Fish</stripes:option>
                        <stripes:option value="Reptile">Reptile</stripes:option>
                    </stripes:select>
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top; padding-top: 5px;">Content:</td>
                <td>
                    <stripes:textarea name="review.content" cols="60" rows="8" />
                </td>
            </tr>
        </table>

        <div style="margin-top: 10px; margin-bottom: 20px;">
            <stripes:submit name="addReview" value="Submit Review" />
        </div>

    </stripes:form>

    <div style="background-color: #ffffcc; padding: 10px; border: 1px solid #e6e6e6; color: #555; font-size: 0.9em;">
        <strong>Note:</strong> AI Summary, Sentiment Analysis, and Tags will be processed asynchronously after submission.
        It may take a moment for them to appear in the list.
    </div>

</div>

<%@ include file="../common/IncludeBottom.jsp"%>