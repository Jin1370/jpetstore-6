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
package org.mybatis.jpetstore.mapper;

import java.util.List;

import org.mybatis.jpetstore.domain.Review;

public interface ReviewMapper {

  // 전체 리뷰 목록 조회
  List<Review> getAllReviews();

  // 특정 리뷰 조회
  Review getReview(int reviewId);

  // 리뷰 등록
  void addReview(Review review);

  // 리뷰 삭제
  void deleteReview(int reviewId);
}
