package model;

import java.math.BigDecimal;

public class DashboardStats {
    private int totalOrders;
    private BigDecimal totalRevenue;
    private BigDecimal averageOrderValue;
    private double conversionRate;
    private double orderGrowth;
    private double revenueGrowth;
    private double aovGrowth;
    private double conversionGrowth;

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public BigDecimal getAverageOrderValue() {
        return averageOrderValue;
    }

    public void setAverageOrderValue(BigDecimal averageOrderValue) {
        this.averageOrderValue = averageOrderValue;
    }

    public double getConversionRate() {
        return conversionRate;
    }

    public void setConversionRate(double conversionRate) {
        this.conversionRate = conversionRate;
    }

    public double getOrderGrowth() {
        return orderGrowth;
    }

    public void setOrderGrowth(double orderGrowth) {
        this.orderGrowth = orderGrowth;
    }

    public double getRevenueGrowth() {
        return revenueGrowth;
    }

    public void setRevenueGrowth(double revenueGrowth) {
        this.revenueGrowth = revenueGrowth;
    }

    public double getAovGrowth() {
        return aovGrowth;
    }

    public void setAovGrowth(double aovGrowth) {
        this.aovGrowth = aovGrowth;
    }

    public double getConversionGrowth() {
        return conversionGrowth;
    }

    public void setConversionGrowth(double conversionGrowth) {
        this.conversionGrowth = conversionGrowth;
    }
}
