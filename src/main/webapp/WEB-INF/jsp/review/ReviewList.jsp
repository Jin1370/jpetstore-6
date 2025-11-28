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
    <stripes:link beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean">
        Return to Main Menu
    </stripes:link>
</div>

<div id="Catalog">

    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 15px; border-bottom: 2px solid #ddd; padding-bottom: 15px;">
        <div>
            <h2>Pet Adoption Reviews</h2>
            <div style="font-size: 1.5em; color: #ff9900; font-weight: bold;">
                ★ ${actionBean.overallRating} <span style="font-size: 0.6em; color: #555;">/ 5.0</span>
            </div>
        </div>
        <stripes:link beanclass="org.mybatis.jpetstore.web.actions.ReviewActionBean" event="newReviewForm"
                      style="display:inline-block; background-color:#006699; color:#fff; padding:10px 20px; border-radius:5px; text-decoration:none; font-weight:bold; box-shadow: 2px 2px 5px rgba(0,0,0,0.2);">
            Write a Review
        </stripes:link>
    </div>

    <div style="background-color: #f9f9f9; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #eee;">
        <stripes:form beanclass="org.mybatis.jpetstore.web.actions.ReviewActionBean" method="get">
            <label style="font-weight: bold; margin-right: 10px;">Select Pet Type:</label>
            <stripes:select name="petType" onchange="this.form.submit()" style="padding: 5px; border-radius: 4px; border: 1px solid #ccc;">
                <stripes:option value="">All Pets</stripes:option>
                <stripes:option value="Cat">Cats</stripes:option>
                <stripes:option value="Dog">Dogs</stripes:option>
                <stripes:option value="Bird">Birds</stripes:option>
                <stripes:option value="Fish">Fish</stripes:option>
                <stripes:option value="Reptile">Reptiles</stripes:option>
            </stripes:select>
            <stripes:submit name="listReviews" value="Filter" style="display:none;"/>
        </stripes:form>

        <div style="margin-top: 15px; padding: 12px; background-color: #eef; border-left: 5px solid #0066cc; line-height: 1.5;">
            <strong style="color:#0066cc;">AI Overall Summary:</strong> ${actionBean.categorySummary}
        </div>

        <div style="margin-top: 15px;">
            <div style="margin-bottom: 8px; font-weight:bold; font-size: 0.95em; color: #555;">Filter by Tags:</div>

            <stripes:link beanclass="org.mybatis.jpetstore.web.actions.ReviewActionBean" event="listReviews"
                          style="display:inline-block; padding: 5px 12px; margin: 3px; border-radius: 20px; text-decoration: none; border: 1px solid #ccc; font-size: 0.9em; transition: 0.2s; background-color: ${empty actionBean.selectedTag ? '#666' : '#fff'}; color: ${empty actionBean.selectedTag ? '#fff' : '#333'};">
                <stripes:param name="petType" value="${actionBean.petType}"/>
                <stripes:param name="selectedTag" value=""/>
                All Tags
            </stripes:link>

            <c:forEach var="tag" items="${actionBean.uniqueTags}">
                <stripes:link beanclass="org.mybatis.jpetstore.web.actions.ReviewActionBean" event="listReviews"
                              style="display:inline-block; padding: 5px 12px; margin: 3px; border-radius: 20px; text-decoration: none; border: 1px solid #ccc; font-size: 0.9em; transition: 0.2s; background-color: ${actionBean.selectedTag == tag ? '#0066cc' : '#fff'}; color: ${actionBean.selectedTag == tag ? '#fff' : '#0066cc'};">
                    <stripes:param name="petType" value="${actionBean.petType}"/>
                    <stripes:param name="selectedTag" value="${tag}"/>
                    ${tag}
                </stripes:link>
            </c:forEach>
        </div>
    </div>

    <table>
        <tr style="background-color: #eee;">
            <th style="padding:10px; width:50px; text-align:center;">No.</th>
            <th style="padding:10px;">Date</th>
            <th style="padding:10px;">User</th>
            <th style="padding:10px;">Pet</th>
            <th style="padding:10px;">Review Content</th>
            <th style="padding:10px; text-align:center; min-width: 100px;">Sentiment</th>
        </tr>

        <c:choose>
            <c:when test="${empty actionBean.reviewList}">
                <tr>
                    <td colspan="6" style="text-align: center; padding: 30px; color: #777;">
                        No reviews found for this selection.
                    </td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="review" items="${actionBean.reviewList}" varStatus="status">
                    <tr style="vertical-align: top; border-bottom: 1px solid #f0f0f0;">

                        <td style="padding:12px 10px; text-align:center; color:#888; font-weight:bold;">
                                ${status.count}
                        </td>

                        <td style="white-space:nowrap; padding:12px 10px; color:#666; font-size:0.9em;">
                            <fmt:formatDate value="${review.createdDate}" pattern="yyyy-MM-dd" />
                        </td>

                        <td style="padding:12px 10px; font-weight:bold; color:#444;">
                            <c:out value="${review.username}" />
                        </td>

                        <td style="padding:12px 10px;">
                            <c:out value="${review.petType}" />
                        </td>

                        <td style="padding:12px 10px;">
                            <c:if test="${not empty review.summary}">
                                <div style="margin-bottom: 6px;">
                                    <span style="font-size: 0.75em; color: #888; border: 1px solid #ddd; padding: 1px 4px; border-radius: 3px; background-color: #fff; margin-right: 4px;">
                                        [Summarized by AI]
                                    </span>
                                    <span style="font-weight: bold; color: #333;">
                                        "<c:out value="${review.summary}" />"
                                    </span>
                                </div>
                            </c:if>

                            <div style="font-size: 1.0em; margin-bottom: 8px; color: #555; line-height: 1.4;">
                                <c:out value="${review.content}" />
                            </div>

                            <c:if test="${not empty review.tags}">
                                <div style="font-size: 0.85em; color: #666;">
                                    <c:forTokens items="${review.tags}" delims="," var="t">
                                        <span style="background:#f0f0f0; padding:2px 8px; border-radius:10px; margin-right:4px; color:#555; border:1px solid #e0e0e0;">${t}</span>
                                    </c:forTokens>
                                </div>
                            </c:if>

                            <c:if test="${not empty sessionScope.accountBean.account.username and sessionScope.accountBean.account.username == review.username}">
                                <div style="margin-top: 10px;">

                                    <stripes:link beanclass="org.mybatis.jpetstore.web.actions.ReviewActionBean" event="editReviewForm"
                                                  style="color: #0066cc; font-size: 0.85em; text-decoration: none; border: 1px solid #0066cc; padding: 2px 6px; border-radius: 3px; margin-right: 5px;">
                                        <stripes:param name="review.reviewId" value="${review.reviewId}"/>
                                        Edit
                                    </stripes:link>

                                    <stripes:link beanclass="org.mybatis.jpetstore.web.actions.ReviewActionBean" event="deleteReview"
                                                  onclick="return confirm('Are you sure you want to delete this review?');"
                                                  style="color: #cc0000; font-size: 0.85em; text-decoration: none; border: 1px solid #cc0000; padding: 2px 6px; border-radius: 3px;">
                                        <stripes:param name="review.reviewId" value="${review.reviewId}"/>
                                        Delete
                                    </stripes:link>
                                </div>
                            </c:if>
                        </td>

                        <td style="text-align:center; padding:12px 10px; vertical-align: middle;">
                            <c:choose>
                                <c:when test="${review.sentiment == 'Positive'}">
                                    <div style="font-weight:bold;">Positive😊</div>
                                </c:when>
                                <c:when test="${review.sentiment == 'Neutral'}">
                                    <div style="font-weight:bold;">Neutral😐</div>
                                </c:when>
                                <c:when test="${review.sentiment == 'Negative'}">
                                    <div style="font-weight:bold;">Negative😟</div>
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