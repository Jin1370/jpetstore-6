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
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

import org.mybatis.jpetstore.domain.Review;
import org.mybatis.jpetstore.mapper.ReviewMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ReviewService {

  private final ReviewMapper reviewMapper;
  private final ObjectMapper objectMapper;
  private final HttpClient httpClient;

  // application.properties에서 API Key와 모델 정보를 주입받음
  @Value("${openai.api.key}")
  private String apiKey;

  @Value("${openai.model:gpt-3.5-turbo}")
  private String model;

  // API 호출 비용 절감을 위한 간단한 인메모리 캐시 (Key: 펫종류, Value: 요약문)
  private final Map<String, String> categorySummaryCache = new ConcurrentHashMap<>();

  public ReviewService(ReviewMapper reviewMapper) {
    this.reviewMapper = reviewMapper;
    this.objectMapper = new ObjectMapper();
    this.httpClient = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(10)).build();
  }

  public List<Review> getAllReviews() {
    return reviewMapper.getAllReviews();
  }

  public Review getReview(int reviewId) {
    return reviewMapper.getReview(reviewId);
  }

  public String getAiSummaryForCategory(String petType, List<Review> reviews) {
    if (reviews == null || reviews.isEmpty()) {
      return "No reviews available for analysis.";
    }

    // 캐시 히트 시 API 호출 없이 리턴
    if (categorySummaryCache.containsKey(petType)) {
      return categorySummaryCache.get(petType);
    }

    try {
      String combinedReviews = reviews.stream().limit(10).map(r -> "- " + r.getContent())
          .collect(Collectors.joining("\n"));

      String prompt = String.format(
          "Here are some reviews for '%s'. Summarize the overall user feedback in 1-2 sentences in English. "
              + "Highlight common pros and cons if any. " + "Do NOT use JSON format, just plain text.\n\nReviews:\n%s",
          petType, combinedReviews);

      String aiSummary = callOpenAiForText(prompt);
      categorySummaryCache.put(petType, aiSummary);
      return aiSummary;

    } catch (Exception e) {
      e.printStackTrace();
      return "AI Summary unavailable due to error.";
    }
  }

  private String callOpenAiForText(String prompt) throws Exception {
    String apiUrl = "https://api.openai.com/v1/chat/completions";

    ObjectNode rootNode = objectMapper.createObjectNode();
    rootNode.put("model", model);

    ArrayNode messagesArray = rootNode.putArray("messages");
    ObjectNode messageNode = messagesArray.addObject();
    messageNode.put("role", "user");
    messageNode.put("content", prompt);

    HttpRequest request = HttpRequest.newBuilder().uri(URI.create(apiUrl)).header("Content-Type", "application/json")
        .header("Authorization", "Bearer " + apiKey).POST(HttpRequest.BodyPublishers.ofString(rootNode.toString()))
        .build();

    HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

    if (response.statusCode() == 200) {
      JsonNode responseNode = objectMapper.readTree(response.body());
      return responseNode.path("choices").get(0).path("message").path("content").asText();
    } else {
      throw new RuntimeException("API Error: " + response.statusCode());
    }
  }

  @Transactional
  public void addReview(Review review) {
    try {
      // DB 저장 전 AI 분석 수행 (요약, 감정, 태그 생성)
      analyzeReviewWithAI(review);
    } catch (Exception e) {
      e.printStackTrace();
      review.setSummary("Summary unavailable (AI Error)");
      review.setSentiment("Neutral");
      review.setTags("");
    }

    reviewMapper.addReview(review);

    // 데이터 변경 시 관련 캐시 초기화
    categorySummaryCache.remove(review.getPetType());
    categorySummaryCache.remove("All Pets");
  }

  private void analyzeReviewWithAI(Review review) throws Exception {
    String apiUrl = "https://api.openai.com/v1/chat/completions";

    String prompt = String.format(
        "Analyze the following pet store review for a '%s'. " + "Return a JSON object with strictly these three keys: "
            + "'summary' (a brief summary in English, max 15 words), "
            + "'sentiment' (choose strictly one: 'Positive', 'Neutral', 'Negative'), "
            + "and 'tags' (max 2 comma-separated keywords in English, EACH starting with '#', like '#Cute,#Active'). "
            + "IMPORTANT: Do NOT include the pet type ('%s') itself as a tag. "
            + "Do not include Markdown formatting (```json). " + "\n\nReview Content: \"%s\"",
        review.getPetType(), review.getPetType(), review.getContent());

    ObjectNode rootNode = objectMapper.createObjectNode();
    rootNode.put("model", model);

    ArrayNode messagesArray = rootNode.putArray("messages");

    ObjectNode messageNode = messagesArray.addObject();
    messageNode.put("role", "user");
    messageNode.put("content", prompt);

    String requestBody = rootNode.toString();

    HttpRequest request = HttpRequest.newBuilder().uri(URI.create(apiUrl)).header("Content-Type", "application/json")
        .header("Authorization", "Bearer " + apiKey).POST(HttpRequest.BodyPublishers.ofString(requestBody)).build();

    HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

    if (response.statusCode() == 200) {
      JsonNode responseNode = objectMapper.readTree(response.body());

      String contentJson = responseNode.path("choices").get(0).path("message").path("content").asText();

      // AI 응답에 포함될 수 있는 마크다운 문법 제거
      contentJson = contentJson.replace("```json", "").replace("```", "").trim();

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
    Review target = reviewMapper.getReview(reviewId);

    if (target != null) {
      reviewMapper.deleteReview(reviewId);

      // 데이터 삭제 시 캐시 초기화
      categorySummaryCache.remove(target.getPetType());
      categorySummaryCache.remove("All Pets");
    }
  }

  @Transactional
  public void updateReview(Review review) {
    try {
      // 내용 수정 시 AI 재분석 수행
      analyzeReviewWithAI(review);
    } catch (Exception e) {
      e.printStackTrace();
    }

    reviewMapper.updateReview(review);

    // 데이터 수정 시 캐시 초기화
    categorySummaryCache.remove(review.getPetType());
    categorySummaryCache.remove("All Pets");
  }
}