package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.CouponActiveVO;

@Mapper
public interface CouponActiveMapper {
	
	/**
	 * 쿠폰 발급
	 * @param couponActiveVO
	 * @return 
	 * INSERT INTO COUPON_ACTIVE
		(COUPON_ACTIVE_ID
		,MEMBER_ID
		,COUPON_ID
		,COUPON_NAME
		,COUPON_ISSUED_DATE
		,COUPON_EXPIRE_DATE
		,COUPON_USE_DATE
		,ITEM_ID
		,ITEM_NAME
		,ORDER_ID
		) VALUES
		(COUPON_ACTIVE_SEQ.NEXTVAL
		,#{memberId}
		,#{couponId}
		,#{couponName}
		,#{couponIssuedDate}
		,#{couponExpireDate}
		,null
		,#{itemId }
		,#{itemName }
		,null
		)
	 */
	int insertCouponActive(CouponActiveVO couponActiveVO);
	
	
	/**
	 * SELECT 	 COUPON_ACTIVE.COUPON_ACTIVE_ID
				,COUPON_ACTIVE.MEMBER_ID
				,COUPON_ACTIVE.COUPON_ID
				,COUPON_ACTIVE.COUPON_NAME
				,COUPON_ACTIVE.COUPON_ISSUED_DATE
				,COUPON_ACTIVE.COUPON_EXPIRE_DATE
				,COUPON_ACTIVE.COUPON_USE_DATE
				,COUPON_ACTIVE.ITEM_ID
				,COUPON_ACTIVE.ITEM_NAME
				,DISCOUNT_COUPON.COUPON_PRICE
				,DISCOUNT_COUPON.COUPON_USE_CONDITION
		FROM COUPON_ACTIVE
		LEFT JOIN DISCOUNT_COUPON
		ON COUPON_ACTIVE.COUPON_ID = DISCOUNT_COUPON.COUPON_ID
		WHERE 1=1
		<if test="memberId != null and memberId != ''">
			AND COUPON_ACTIVE.MEMBER_ID = #{memberId}
		</if>
		<if test="itemId != 0 and itemId != ''">
			AND (COUPON_ACTIVE.ITEM_ID = #{itemId} OR COUPON_ACTIVE.ITEM_ID = 0)
		</if>
	 */
	List<CouponActiveVO> selectCouponActive(
			 @Param("memberId") String memberId
			,@Param("itemId") int itemId
			);
	
	
	/**
	 * UPDATE COUPON_ACTIVE
		SET COUPON_USE_DATE = #{couponUseDate}
		,ITEM_ID = #{itemId}
		,ORDER_ID = #{orderId}
		WHERE COUPON_ACTIVE_ID = #{couponActiveId}
	 */
	int updateCouponActiveByCouponActiveId(CouponActiveVO couponActiveVO);
	
	
	/**
	 * UPDATE COUPON_ACTIVE
		SET COUPON_USE_DATE = NULL
		,ITEM_ID = CASE
					WHEN ITEM_NAME IS NOT NULL THEN ITEM_ID
					ELSE 0
					END
		,ORDER_ID = #{orderId}
		WHERE ORDER_ID = #{orderId}
		AND COUPON_USE_DATE IS NOT NULL
		AND COUPON_EXPIRE_DATE >= NOW();
	 */
	int updateCouponActiveByOrderId(String orderId);

}
