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
package org.mybatis.jpetstore.web.actions;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.SessionScope;
import net.sourceforge.stripes.integration.spring.SpringBean;

import org.mybatis.jpetstore.domain.Review;
import org.mybatis.jpetstore.service.ReviewService;

@SessionScope
public class ReviewActionBean extends AbstractActionBean {

  private static final long serialVersionUID = 1L;
  private static final String REVIEW_LIST = "/WEB-INF/jsp/review/ReviewList.jsp";
  private static final String NEW_REVIEW = "/WEB-INF/jsp/review/NewReviewForm.jsp";

  @SpringBean
  private transient ReviewService reviewService;

  private List<Review> reviewList;
  private Review review = new Review();

  // 필터링 및 화면 표시를 위한 변수들
  private String petType; // 사용자가 선택한 펫 종류
  private String selectedTag; // 사용자가 클릭한 태그

  private double overallRating; // 5점 만점 평점
  private String categorySummary; // 펫 종류별 요약 텍스트
  private Set<String> uniqueTags; // 해당 펫 종류에 포함된 모든 태그 목록 (중복 제거)

  // -------------------------
  // Getters / Setters
  // -------------------------
  public List<Review> getReviewList() {
    return reviewList;
  }

  public Review getReview() {
    return review;
  }

  public void setReview(Review review) {
    this.review = review;
  }

  public String getPetType() {
    return petType;
  }

  public void setPetType(String petType) {
    this.petType = petType;
  }

  public String getSelectedTag() {
    return selectedTag;
  }

  public void setSelectedTag(String selectedTag) {
    this.selectedTag = selectedTag;
  }

  public double getOverallRating() {
    return overallRating;
  }

  public String getCategorySummary() {
    return categorySummary;
  }

  public Set<String> getUniqueTags() {
    return uniqueTags;
  }

  // 로그인 체크
  private AccountActionBean getAccountBean() {
    HttpSession session = context.getRequest().getSession();
    return (AccountActionBean) session.getAttribute("accountBean");
  }

  private boolean isLoggedIn() {
    AccountActionBean accountBean = getAccountBean();
    return accountBean != null && accountBean.isAuthenticated();
  }

  private String getLoggedInUsername() {
    return isLoggedIn() ? getAccountBean().getAccount().getUsername() : null;
  }

  // -------------------------
  // Actions
  // -------------------------

  @DefaultHandler
  public Resolution listReviews() {
    // 1. 전체 리뷰 가져오기
    List<Review> allReviews = reviewService.getAllReviews();

    // 2. 1차 필터링 (펫 종류만 고려) -> 통계 및 태그 추출의 기준 데이터
    List<Review> filteredByPet = new ArrayList<>();
    for (Review r : allReviews) {
      // 펫 타입이 선택되지 않았거나(전체), 일치하는 경우만 추가
      if (petType == null || petType.isEmpty() || r.getPetType().equalsIgnoreCase(petType)) {
        filteredByPet.add(r);
      }
    }

    // 3. 통계 계산 (평점) & 요약 생성
    calculateStatistics(filteredByPet);

    // 4. 태그 추출 (현재 필터된 리뷰들 내에서 등장하는 태그만 수집)
    extractTags(filteredByPet);

    // 5. 2차 필터링 (태그 버튼 클릭 시) -> 실제 리스트에 뿌려질 데이터
    if (selectedTag != null && !selectedTag.isEmpty()) {
      this.reviewList = filteredByPet.stream().filter(r -> r.getTags() != null && r.getTags().contains(selectedTag))
          .collect(Collectors.toList());
    } else {
      this.reviewList = filteredByPet;
    }

    return new ForwardResolution(REVIEW_LIST);
  }

  // 평점 계산 및 요약 로직
  private void calculateStatistics(List<Review> reviews) {
    if (reviews.isEmpty()) {
      this.overallRating = 0.0;
      this.categorySummary = "No reviews available.";
      return;
    }

    double totalScore = 0;
    int positiveCount = 0;

    for (Review r : reviews) {
      String sentiment = r.getSentiment();
      if ("Positive".equalsIgnoreCase(sentiment)) {
        totalScore += 5.0;
        positiveCount++;
      } else if ("Neutral".equalsIgnoreCase(sentiment)) {
        totalScore += 3.0;
      } else { // Negative
        totalScore += 1.0;
      }
    }

    // 소수점 한자리까지 반올림
    this.overallRating = Math.round((totalScore / reviews.size()) * 10.0) / 10.0;

    // AI 요약 생성 호출
    String currentPetType = (petType == null || petType.isEmpty()) ? "All Pets" : petType;
    this.categorySummary = reviewService.getAiSummaryForCategory(currentPetType, reviews);
  }

  // 태그 추출 로직
  private void extractTags(List<Review> reviews) {
    this.uniqueTags = new HashSet<>();
    for (Review r : reviews) {
      if (r.getTags() != null && !r.getTags().isEmpty()) {
        String[] tags = r.getTags().split(",");
        for (String t : tags) {
          this.uniqueTags.add(t.trim());
        }
      }
    }
  }

  public Resolution newReviewForm() {
    if (!isLoggedIn()) {
      setMessage("Please sign in to write a review.");
      return new RedirectResolution(AccountActionBean.class, "signonForm");
    }
    return new ForwardResolution(NEW_REVIEW);
  }

  /**
   * 리뷰 등록 (작성자 강제 주입)
   */
  public Resolution addReview() {
    if (!isLoggedIn()) {
      return new RedirectResolution(AccountActionBean.class, "signonForm");
    }

    // 폼에서 넘어온 데이터 대신, 세션의 ID를 사용 (보안 강화)
    review.setUsername(getLoggedInUsername());

    reviewService.addReview(review);
    review = new Review(); // 초기화
    return new RedirectResolution(ReviewActionBean.class, "listReviews");
  }

  /**
   * 리뷰 삭제 (본인 확인 추가)
   */
  public Resolution deleteReview() {
    // 1. 로그인 체크
    if (!isLoggedIn()) {
      setMessage("You must be signed in to delete a review.");
      return new RedirectResolution(AccountActionBean.class, "signonForm");
    }

    // 2. 삭제하려는 리뷰 정보 가져오기 (DB 조회)
    Review targetReview = reviewService.getReview(review.getReviewId());

    // 3. 권한 체크 (내 글인지 확인)
    String currentUser = getLoggedInUsername();
    if (targetReview != null && currentUser.equals(targetReview.getUsername())) {
      reviewService.deleteReview(review.getReviewId());
      setMessage("Review deleted successfully.");
    } else {
      setMessage("You can only delete your own reviews.");
    }

    return new RedirectResolution(ReviewActionBean.class, "listReviews");
  }
}
