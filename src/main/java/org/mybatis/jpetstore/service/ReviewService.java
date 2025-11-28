/*
 *    Copyright 2010-2025 the original author or authors.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *       https://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */
package org.mybatis.jpetstore.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.List;

import org.mybatis.jpetstore.domain.Review;
import org.mybatis.jpetstore.mapper.ReviewMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ReviewService {

  private final ReviewMapper reviewMapper;
  private final ObjectMapper objectMapper; // JSON 파싱용
  private final HttpClient httpClient; // HTTP 요청용

  // application.properties에서 값 주입
  @Value("${openai.api.key}")
  private String apiKey;

  @Value("${openai.model:gpt-3.5-turbo}")
  private String model;

  public ReviewService(ReviewMapper reviewMapper) {
    this.reviewMapper = reviewMapper;
    this.objectMapper = new ObjectMapper();
    this.httpClient = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(10)).build();
  }

  /**
   * 모든 리뷰 조회
   */
  public List<Review> getAllReviews() {
    return reviewMapper.getAllReviews();
  }

  /**
   * 특정 리뷰 조회
   */
  public Review getReview(int reviewId) {
    return reviewMapper.getReview(reviewId);
  }

  /**
   * 리뷰 추가 (OpenAI 분석 포함)
   */
  @Transactional
  public void addReview(Review review) {
    try {
      // 1. OpenAI API를 호출하여 분석 데이터 가져오기
      analyzeReviewWithAI(review);
    } catch (Exception e) {
      // AI 분석 실패 시 로그를 남기고 기본값 설정 (저장은 막지 않음)
      e.printStackTrace();
      review.setSummary("Summary unavailable (AI Error)");
      review.setSentiment("Neutral");
      review.setTags("");
    }

    // 2. 데이터베이스에 저장
    // 주의: Mapper 인터페이스에 정의된 이름은 보통 insertReview입니다.
    reviewMapper.addReview(review);
  }

  /**
   * OpenAI API 호출 로직
   */
  private void analyzeReviewWithAI(Review review) throws Exception {
    String apiUrl = "https://api.openai.com/v1/chat/completions";

    // 프롬프트 작성
    String prompt = String.format(
            "Analyze the following pet store review for a '%s'. " +
                    "Return a JSON object with strictly these three keys: " +
                    "'summary' (a brief summary in English, max 15 words), " +
                    "'sentiment' (choose strictly one: 'Positive', 'Neutral', 'Negative'), " +
                    "and 'tags' (3-5 comma-separated keywords in English, EACH starting with '#', like '#Cute,#Active'). " +
                    "IMPORTANT: Do NOT include the pet type ('%s') itself as a tag. " +
                    "Do not include Markdown formatting (```json). " +
                    "\n\nReview Content: \"%s\"",
            review.getPetType(), // 첫 번째 %s: 문맥 제공
            review.getPetType(), // 두 번째 %s: 태그 제외 대상 지정
            review.getContent()  // 세 번째 %s: 리뷰 본문
    );

    // 요청 바디 생성 (JSON)
    ObjectNode rootNode = objectMapper.createObjectNode(); // [1] 첫 번째 rootNode (요청용)
    rootNode.put("model", model);

    // "messages" 배열 노드 생성
    ArrayNode messagesArray = rootNode.putArray("messages");

    // 배열 안에 객체 추가
    ObjectNode messageNode = messagesArray.addObject();
    messageNode.put("role", "user");
    messageNode.put("content", prompt);

    // 최종 JSON 문자열 변환
    String requestBody = rootNode.toString();

    // HTTP 요청 생성
    HttpRequest request = HttpRequest.newBuilder().uri(URI.create(apiUrl)).header("Content-Type", "application/json")
        .header("Authorization", "Bearer " + apiKey).POST(HttpRequest.BodyPublishers.ofString(requestBody)).build();

    // API 전송 및 응답 수신
    HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

    if (response.statusCode() == 200) {
      // 응답 파싱: 여기서 변수명을 responseNode로 변경하여 충돌 해결
      JsonNode responseNode = objectMapper.readTree(response.body()); // [2] 이름 변경됨

      String contentJson = responseNode.path("choices").get(0).path("message").path("content").asText();

      // AI가 가끔 ```json ... ``` 형태로 줄 수 있으므로 제거 처리
      contentJson = contentJson.replace("```json", "").replace("```", "").trim();

      // 결과 JSON 파싱하여 Review 객체에 세팅
      JsonNode resultNode = objectMapper.readTree(contentJson);

      if (resultNode.has("summary"))
        review.setSummary(resultNode.get("summary").asText());
      if (resultNode.has("sentiment"))
        review.setSentiment(resultNode.get("sentiment").asText());
      if (resultNode.has("tags"))
        review.setTags(resultNode.get("tags").asText());

    } else {
      throw new RuntimeException("OpenAI API call failed: " + response.statusCode() + " " + response.body());
    }
  }

  @Transactional
  public void deleteReview(int reviewId) {
    reviewMapper.deleteReview(reviewId);
  }
}
