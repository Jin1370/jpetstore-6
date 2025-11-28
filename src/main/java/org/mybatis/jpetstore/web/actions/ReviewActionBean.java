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

import java.util.List;

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

  // -------------------------
  // getters / setters
  // -------------------------
  public List<Review> getReviewList() {
    return reviewList;
  }

  public void setReviewList(List<Review> reviewList) {
    this.reviewList = reviewList;
  }

  public Review getReview() {
    return review;
  }

  public void setReview(Review review) {
    this.review = review;
  }

  // -------------------------
  // Actions
  // -------------------------

  /**
   * 리뷰 목록 페이지
   */
  /** @DefaultHandler **/
  public Resolution listReviews() {
    reviewList = reviewService.getAllReviews();
    return new ForwardResolution(REVIEW_LIST);
  }

  /**
   * 새 리뷰 작성 폼
   */
  public Resolution newReviewForm() {
    return new ForwardResolution(NEW_REVIEW);
  }

  /**
   * 리뷰 등록
   */
  public Resolution addReview() {
    reviewService.addReview(review);
    review = new Review(); // 등록 후 빈 초기화
    return new RedirectResolution(ReviewActionBean.class, "listReviews");
  }
}
