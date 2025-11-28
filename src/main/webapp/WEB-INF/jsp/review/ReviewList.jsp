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

    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 10px; border-bottom: 2px solid #ddd; padding-bottom: 10px;">
        <div>
            <h2>Pet Adoption Reviews</h2>
            <div style="font-size: 1.5em; color: #ff9900; font-weight: bold;">
                ★ ${actionBean.overallRating} <span style="font-size: 0.6em; color: #555;">/ 5.0</span>
            </div>
        </div>
        <stripes:link beanclass="org.mybatis.jpetstore.web.actions.ReviewActionBean" event="newReviewForm" style="font-weight:bold; font-size: 1.1em;">
            Write a Review
        </stripes:link>
    </div>

    <div style="background-color: #f9f9f9; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
        <stripes:form beanclass="org.mybatis.jpetstore.web.actions.ReviewActionBean" method="get">
            <label style="font-weight: bold; margin-right: 10px;">Select Pet Type:</label>
            <stripes:select name="petType" onchange="this.form.submit()">
                <stripes:option value="">All Pets</stripes:option>
                <stripes:option value="Cat">Cats</stripes:option>
                <stripes:option value="Dog">Dogs</stripes:option>
                <stripes:option value="Bird">Birds</stripes:option>
                <stripes:option value="Fish">Fish</stripes:option>
                <stripes:option value="Reptile">Reptiles</stripes:option>
            </stripes:select>
            <stripes:submit name="listReviews" value="Filter" style="display:none;"/>
        </stripes:form>

        <div style="margin-top: 15px; padding: 10px; background-color: #eef; border-left: 4px solid #0066cc;">
            <strong>Summary:</strong> ${actionBean.categorySummary}
        </div>

        <div style="margin-top: 15px;">
            <div style="margin-bottom: 5px; font-weight:bold;">Filter by Tags:</div>

            <stripes:link beanclass="org.mybatis.jpetstore.web.actions.ReviewActionBean" event="listReviews"
                          style="display:inline-block; padding: 5px 10px; margin: 3px; border-radius: 15px; text-decoration: none; border: 1px solid #ccc; background-color: ${empty actionBean.selectedTag ? '#666' : '#fff'}; color: ${empty actionBean.selectedTag ? '#fff' : '#333'};">
                <stripes:param name="petType" value="${actionBean.petType}"/>
                <stripes:param name="selectedTag" value=""/>
                All Tags
            </stripes:link>

            <c:forEach var="tag" items="${actionBean.uniqueTags}">
                <stripes:link beanclass="org.mybatis.jpetstore.web.actions.ReviewActionBean" event="listReviews"
                              style="display:inline-block; padding: 5px 10px; margin: 3px; border-radius: 15px; text-decoration: none; border: 1px solid #ccc; background-color: ${actionBean.selectedTag == tag ? '#0066cc' : '#fff'}; color: ${actionBean.selectedTag == tag ? '#fff' : '#0066cc'};">
                    <stripes:param name="petType" value="${actionBean.petType}"/>
                    <stripes:param name="selectedTag" value="${tag}"/>
                    ${tag}
                </stripes:link>
            </c:forEach>
        </div>
    </div>

    <table>
        <tr style="background-color: #eee;">
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
                        No reviews found for this selection.
                    </td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="review" items="${actionBean.reviewList}">
                    <tr style="vertical-align: top;">
                        <td style="white-space:nowrap;">
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
                                <div style="font-weight: bold; margin-bottom: 6px; color: #333;">
                                    "<c:out value="${review.summary}" />"
                                </div>
                            </c:if>

                            <div style="font-size: 1.0em; margin-bottom: 8px; color: #555;">
                                <c:out value="${review.content}" />
                            </div>

                            <c:if test="${not empty review.tags}">
                                <div style="font-size: 0.85em; color: #666;">
                                    <c:forTokens items="${review.tags}" delims="," var="t">
                                        <span style="background:#f0f0f0; padding:2px 6px; border-radius:4px; margin-right:4px;">${t}</span>
                                    </c:forTokens>
                                </div>
                            </c:if>
                        </td>

                        <td style="text-align:center;">
                            <c:choose>
                                <c:when test="${review.sentiment == 'Positive'}">
                                    <span style="color:green; font-weight:bold;">😊 5.0</span>
                                </c:when>
                                <c:when test="${review.sentiment == 'Neutral'}">
                                    <span style="color:gray; font-weight:bold;">😐 3.0</span>
                                </c:when>
                                <c:when test="${review.sentiment == 'Negative'}">
                                    <span style="color:red; font-weight:bold;">😟 1.0</span>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </table>

</div>

<%@ include file="../common/IncludeBottom.jsp"%>