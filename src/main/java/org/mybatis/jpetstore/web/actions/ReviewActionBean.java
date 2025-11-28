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
  private static final String EDIT_REVIEW = "/WEB-INF/jsp/review/EditReviewForm.jsp";

  @SpringBean
  private transient ReviewService reviewService;

  private List<Review> reviewList;
  private Review review = new Review();

  // 필터 및 통계 데이터
  private String petType;
  private String selectedTag;

  private double overallRating;
  private String categorySummary;
  private Set<String> uniqueTags;

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

  // 인증 헬퍼 메서드
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

  @DefaultHandler
  public Resolution listReviews() {
    List<Review> allReviews = reviewService.getAllReviews();

    // 1차 필터링 (펫 종류)
    List<Review> filteredByPet = new ArrayList<>();
    for (Review r : allReviews) {
      if (petType == null || petType.isEmpty() || r.getPetType().equalsIgnoreCase(petType)) {
        filteredByPet.add(r);
      }
    }

    // 통계(평점, AI 요약) 및 태그 추출 수행
    calculateStatistics(filteredByPet);
    extractTags(filteredByPet);

    // 2차 필터링 (태그 선택 시)
    if (selectedTag != null && !selectedTag.isEmpty()) {
      this.reviewList = filteredByPet.stream().filter(r -> r.getTags() != null && r.getTags().contains(selectedTag))
          .collect(Collectors.toList());
    } else {
      this.reviewList = filteredByPet;
    }

    return new ForwardResolution(REVIEW_LIST);
  }

  private void calculateStatistics(List<Review> reviews) {
    if (reviews.isEmpty()) {
      this.overallRating = 0.0;
      this.categorySummary = "No reviews available.";
      return;
    }

    // 감정 분석 결과(Positive=5, Neutral=3, Negative=1)를 기반으로 평점 계산
    double totalScore = 0;
    for (Review r : reviews) {
      String sentiment = r.getSentiment();
      if ("Positive".equalsIgnoreCase(sentiment)) {
        totalScore += 5.0;
      } else if ("Neutral".equalsIgnoreCase(sentiment)) {
        totalScore += 3.0;
      } else {
        totalScore += 1.0;
      }
    }

    this.overallRating = Math.round((totalScore / reviews.size()) * 10.0) / 10.0;

    // AI 요약 서비스 호출
    String currentPetType = (petType == null || petType.isEmpty()) ? "All Pets" : petType;
    this.categorySummary = reviewService.getAiSummaryForCategory(currentPetType, reviews);
  }

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

  public Resolution addReview() {
    if (!isLoggedIn()) {
      return new RedirectResolution(AccountActionBean.class, "signonForm");
    }

    // 보안을 위해 세션의 사용자 ID를 강제로 주입
    review.setUsername(getLoggedInUsername());

    reviewService.addReview(review);
    review = new Review();
    return new RedirectResolution(ReviewActionBean.class, "listReviews");
  }

  public Resolution deleteReview() {
    if (!isLoggedIn()) {
      setMessage("You must be signed in to delete a review.");
      return new RedirectResolution(AccountActionBean.class, "signonForm");
    }

    Review targetReview = reviewService.getReview(review.getReviewId());

    // 본인 작성글인지 권한 확인
    String currentUser = getLoggedInUsername();
    if (targetReview != null && currentUser.equals(targetReview.getUsername())) {
      reviewService.deleteReview(review.getReviewId());
    } else {
      setMessage("You can only delete your own reviews.");
    }

    return new RedirectResolution(ReviewActionBean.class, "listReviews");
  }

  public Resolution editReviewForm() {
    if (!isLoggedIn())
      return new RedirectResolution(AccountActionBean.class, "signonForm");

    review = reviewService.getReview(review.getReviewId());

    // 본인 작성글인지 권한 확인
    String currentUser = getLoggedInUsername();
    if (review == null || !currentUser.equals(review.getUsername())) {
      setMessage("You can only edit your own reviews.");
      return new RedirectResolution(ReviewActionBean.class, "listReviews");
    }

    return new ForwardResolution(EDIT_REVIEW);
  }

  public Resolution updateReview() {
    if (!isLoggedIn())
      return new RedirectResolution(AccountActionBean.class, "signonForm");

    Review original = reviewService.getReview(review.getReviewId());

    // 본인 확인 후 수정 실행 (작성자 ID 보존)
    if (original != null && getLoggedInUsername().equals(original.getUsername())) {
      review.setUsername(getLoggedInUsername());
      reviewService.updateReview(review);
    }

    return new RedirectResolution(ReviewActionBean.class, "listReviews");
  }
}