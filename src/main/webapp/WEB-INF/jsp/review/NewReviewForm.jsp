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

<!-- File: NewReviewForm.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>새 후기 작성 - JPetstore</title>
    <link rel="stylesheet" href="/wbapp/css/jpetstore.css" />
    <style>
        .container{max-width:700px;margin:20px auto;padding:10px}
        label{display:block;margin-top:10px}
        textarea{width:100%;height:200px}
    </style>
</head>
<body>
<div class="container">
    <h2>새 후기 작성</h2>
    <form action="/review/new" method="post">
        <label>작성자 (UserId)
            <input type="text" name="userId" required />
        </label>

        <label>반려동물 종류
            <select name="petType" required>
                <option value="고양이">고양이</option>
                <option value="강아지">강아지</option>
                <option value="기타">기타</option>
            </select>
        </label>

        <label>후기 내용
            <textarea name="content" required></textarea>
        </label>

        <div style="margin-top:12px">
            <button type="submit">등록</button>
            <a href="/review/list" style="margin-left:12px">취소</a>
        </div>
    </form>

    <p style="margin-top:18px;font-size:0.9em;color:#666">참고: 리뷰 등록 시 서버에서 AI 요약·감정·태그가 비동기적으로 처리되어 업데이트됩니다. 처리 중에는 요약/태그가 비어있을 수 있습니다.</p>
</div>
</body>
</html>
