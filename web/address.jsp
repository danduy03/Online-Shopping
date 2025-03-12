<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Địa chỉ giao hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .form-select:disabled {
                background-color: #e9ecef;
                cursor: not-allowed;
            }
            .required-label::after {
                content: " *";
                color: red;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <div class="row">
                <div class="col-md-6 offset-md-3">
                    <h2 class="mb-4">Địa chỉ giao hàng</h2>
                    <form id="addressForm">
                        <div class="mb-3">
                            <label for="fullName" class="form-label required-label">Họ và tên</label>
                            <input type="text" class="form-control" id="fullName" required>
                        </div>

                        <div class="mb-3">
                            <label for="phone" class="form-label required-label">Số điện thoại</label>
                            <input type="tel" class="form-control" id="phone" required>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email (không bắt buộc)</label>
                            <input type="email" class="form-control" id="email">
                        </div>

                        <div class="mb-3">
                            <label for="province" class="form-label required-label">Tỉnh/Thành phố</label>
                            <select class="form-select" id="province" required>
                                <option value="">--Chọn Tỉnh/Thành phố--</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="district" class="form-label required-label">Quận/Huyện</label>
                            <select class="form-select" id="district" required disabled>
                                <option value="">--Chọn Quận/Huyện--</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="commune" class="form-label required-label">Phường/Xã</label>
                            <select class="form-select" id="commune" required disabled>
                                <option value="">--Chọn Phường/Xã--</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="village" class="form-label">Thôn/Xóm/Làng</label>
                            <select class="form-select" id="village" disabled>
                                <option value="">--Chọn Thôn/Xóm/Làng--</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="address" class="form-label required-label">Số nhà, tên đường</label>
                            <input type="text" class="form-control" id="address" required>
                        </div>

                        <div class="mb-3">
                            <label for="notes" class="form-label">Ghi chú (không bắt buộc)</label>
                            <textarea class="form-control" id="notes" rows="3"></textarea>
                        </div>

                        <button type="submit" class="btn btn-primary">Lưu địa chỉ</button>
                    </form>
                </div>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/location.js"></script>
    </body>
</html>
