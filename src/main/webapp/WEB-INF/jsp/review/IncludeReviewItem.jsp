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
<!-- File: IncludeReviewItem.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    // Expecting a 'review' attribute passed via jsp:param. If framework passes differently
    // adapt accordingly in controller.
    Object reviewObj = request.getAttribute("review");
%>
<c:if test="${not empty review}">
<div class="review-card" id="review-${review.reviewId}">
    <div class="meta">
        <span><strong>작성자:</strong> ${fn:escapeXml(review.userId)}</span>
        <span style="margin-left:12px"><strong>품종/종류:</strong> ${fn:escapeXml(review.petType)}</span>
        <span style="margin-left:12px"><strong>작성일:</strong> <fmt:formatDate value="${review.createdDate}" pattern="yyyy-MM-dd HH:mm"/></span>
        <span style="margin-left:12px"><strong>감정:</strong>
            <c:choose>
                <c:when test="${review.sentiment == 'POSITIVE'}"><span class="sentiment-positive">긍정</span></c:when>
                <c:when test="${review.sentiment == 'NEUTRAL'}"><span class="sentiment-neutral">중립</span></c:when>
                <c:when test="${review.sentiment == 'NEGATIVE'}"><span class="sentiment-negative">부정</span></c:when>
                <c:otherwise><span class="sentiment-neutral">분석없음</span></c:otherwise>
            </c:choose>
        </span>
    </div>

    <div class="summary">요약: ${fn:escapeXml(review.summary)}</div>

    <div class="content">
        <strong>후기 원문</strong>
        <p>${fn:escapeXml(review.content)}</p>
    </div>

    <div class="tags">
        <strong>태그:</strong>
        <c:if test="${not empty review.keywords}">
            <c:forEach var="kw" items="${fn:split(review.keywords, ',')}" varStatus="st">
                <a class="tag" href="/review/list?keyword=${fn:trim(kw)}">#${fn:escapeXml(fn:trim(kw))}</a>
            </c:forEach>
        </c:if>
    </div>
</div>
</c:if>