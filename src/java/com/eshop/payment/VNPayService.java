package com.eshop.payment;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import jakarta.servlet.http.HttpServletRequest;

public class VNPayService {
    private static final String VNP_VERSION = "2.1.0";
    private static final String VNP_COMMAND = "pay";
    private static final String VNP_TMN_CODE = "2QXUI4J4"; // Replace with your actual VNPay merchant code
    private static final String VNP_HASH_SECRET = "NYYZTXVDGFWGTVBZDZDRSYJIUWOFHORT"; // Replace with your actual VNPay hash secret
    private static final String VNP_API_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";

    public String createPaymentUrl(HttpServletRequest request, long amount, String orderInfo) throws UnsupportedEncodingException {
        String vnp_TxnRef = generateTransactionRef();
        String vnp_IpAddr = getIpAddress(request);
        
        // Build the return URL dynamically based on the current request
        String baseURL = String.format("%s://%s:%s%s",
                request.getScheme(), request.getServerName(), request.getServerPort(), request.getContextPath());
        String vnp_ReturnUrl = baseURL + "/vnpay-return";
        
        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", VNP_VERSION);
        vnp_Params.put("vnp_Command", VNP_COMMAND);
        vnp_Params.put("vnp_TmnCode", VNP_TMN_CODE);
        vnp_Params.put("vnp_Amount", String.valueOf(amount * 100)); // Convert to VND cents
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_BankCode", ""); // Leave empty for user to select bank
        vnp_Params.put("vnp_CreateDate", generateCreateDate());
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_OrderInfo", orderInfo);
        vnp_Params.put("vnp_OrderType", "other"); // You can customize this
        vnp_Params.put("vnp_ReturnUrl", vnp_ReturnUrl);
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);

        // Sort parameters before signing
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);
        
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if ((fieldValue != null) && (!fieldValue.isEmpty())) {
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }

        String queryUrl = query.toString();
        String vnp_SecureHash = hmacSHA512(VNP_HASH_SECRET, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;

        return VNP_API_URL + "?" + queryUrl;
    }

    public boolean validatePaymentResponse(Map<String, String> response) {
        // Remove hash from parameters
        String vnp_SecureHash = response.get("vnp_SecureHash");
        response.remove("vnp_SecureHash");
        response.remove("vnp_SecureHashType");

        // Sort parameters
        List<String> fieldNames = new ArrayList<>(response.keySet());
        Collections.sort(fieldNames);
        
        // Create hash data
        StringBuilder hashData = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = response.get(fieldName);
            if ((fieldValue != null) && (!fieldValue.isEmpty())) {
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(fieldValue);
                if (itr.hasNext()) {
                    hashData.append('&');
                }
            }
        }

        // Verify secure hash
        String calculatedHash = hmacSHA512(VNP_HASH_SECRET, hashData.toString());
        return calculatedHash.equals(vnp_SecureHash);
    }

    private String generateTransactionRef() {
        return String.valueOf(System.currentTimeMillis());
    }

    private String generateCreateDate() {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        return formatter.format(new Date());
    }

    private String getIpAddress(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-FORWARDED-FOR");
        if (ipAddress == null) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
    }

    private String hmacSHA512(String key, String data) {
        try {
            Mac hmacSha512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(), "HmacSHA512");
            hmacSha512.init(secretKeySpec);
            byte[] result = hmacSha512.doFinal(data.getBytes());
            return bytesToHex(result);
        } catch (Exception ex) {
            return "";
        }
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
