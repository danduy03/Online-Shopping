package model;

import java.math.BigDecimal;
import java.util.Date;

public class Discount {
    private Long id;
    private String code;
    private String description;
    private String discountType; // PERCENTAGE or FIXED
    private BigDecimal discountValue;
    private BigDecimal minPurchaseAmount;
    private BigDecimal maxDiscountAmount;
    private Date startDate;
    private Date endDate;
    private int maxUses;
    private int usedCount;
    private boolean active;
    private Date createdAt;
    private Date updatedAt;

    public Discount() {
        this.createdAt = new Date();
        this.updatedAt = new Date();
        this.usedCount = 0;
        this.active = true;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public BigDecimal getMinPurchaseAmount() {
        return minPurchaseAmount;
    }

    public void setMinPurchaseAmount(BigDecimal minPurchaseAmount) {
        this.minPurchaseAmount = minPurchaseAmount;
    }

    public BigDecimal getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(BigDecimal maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public int getMaxUses() {
        return maxUses;
    }

    public void setMaxUses(int maxUses) {
        this.maxUses = maxUses;
    }

    public int getUsedCount() {
        return usedCount;
    }

    public void setUsedCount(int usedCount) {
        this.usedCount = usedCount;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Helper methods
    public boolean isValid() {
        Date now = new Date();
        return active && 
               now.after(startDate) && 
               now.before(endDate) && 
               usedCount < maxUses;
    }

    public BigDecimal calculateDiscount(BigDecimal purchaseAmount) {
        if (!isValid() || purchaseAmount.compareTo(minPurchaseAmount) < 0) {
            return BigDecimal.ZERO;
        }

        BigDecimal calculatedDiscount;
        if ("PERCENTAGE".equals(discountType)) {
            calculatedDiscount = purchaseAmount.multiply(discountValue.divide(new BigDecimal(100)));
        } else {
            calculatedDiscount = discountValue;
        }

        return calculatedDiscount.min(maxDiscountAmount);
    }
}
