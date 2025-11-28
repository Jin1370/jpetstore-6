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
<%-- File: /WEB-INF/jsp/review/ReviewList.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/IncludeTop.jsp"%>

<div id="BackLink">
    <stripes:link beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean">
        Return to Main Menu
    </stripes:link>
</div>

<div id="Catalog">

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
        <h2>Pet Adoption Reviews</h2>
        <stripes:link beanclass="org.mybatis.jpetstore.web.actions.ReviewActionBean" event="newReviewForm" style="font-weight:bold;">
            Write a Review
        </stripes:link>
    </div>

    <div style="margin-bottom: 20px; background-color: #f5f5f5; padding: 10px; border-radius: 5px;">
        <stripes:form beanclass="org.mybatis.jpetstore.web.actions.ReviewActionBean" method="get">
            <b>Filter:</b>
            Pet Type:
            <stripes:select name="petType">
                <stripes:option value="">All</stripes:option>
                <stripes:option value="CATS">Cats</stripes:option>
                <stripes:option value="DOGS">Dogs</stripes:option>
                <stripes:option value="BIRDS">Birds</stripes:option>
                <stripes:option value="FISH">Fish</stripes:option>
                <stripes:option value="REPTILES">Reptiles</stripes:option>
            </stripes:select>

            Keyword:
            <stripes:text name="keyword" size="20"/>

            <stripes:submit name="listReviews" value="Search" />
        </stripes:form>
    </div>

    <table>
        <tr>
            <th>Date</th>
            <th>User</th>
            <th>Pet</th>
            <th>Review Content</th>
            <th>Sentiment</th>
        </tr>

        <c:choose>
            <c:when test="${empty actionBean.reviewList}">
                <tr>
                    <td colspan="5" style="text-align: center; padding: 20px;">
                        No reviews found.
                    </td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="review" items="${actionBean.reviewList}">
                    <tr style="vertical-align: top;">
                        <td>
                            <fmt:formatDate value="${review.createdDate}" pattern="yyyy-MM-dd" />
                        </td>

                        <td>
                            <c:out value="${review.username}" />
                        </td>

                        <td>
                            <c:out value="${review.petType}" />
                        </td>

                        <td>
                            <c:if test="${not empty review.summary}">
                                <strong>"<c:out value="${review.summary}" />"</strong><br/>
                            </c:if>
                            <c:out value="${review.content}" />

                            <c:if test="${not empty review.tags}">
                                <br/><span style="color:#666; font-size:0.9em;">Tags: <c:out value="${review.tags}"/></span>
                            </c:if>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${review.sentiment == 'Positive'}"><font color="green">Positive</font></c:when>
                                <c:when test="${review.sentiment == 'Negative'}"><font color="red">Negative</font></c:when>
                                <c:otherwise>Neutral</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </table>

</div>

<%@ include file="../common/IncludeBottom.jsp"%>