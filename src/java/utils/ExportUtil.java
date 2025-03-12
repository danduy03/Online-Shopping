//package utils;
//
//import com.itextpdf.text.*;
//import com.itextpdf.text.pdf.*;
//import model.DashboardStats;
//import model.Order;
//import model.Product;
//import org.apache.poi.ss.usermodel.*;
//import org.apache.poi.xssf.usermodel.XSSFWorkbook;
//
//import jakarta.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import java.text.SimpleDateFormat;
//import java.util.Date;
//import java.util.List;
//
//public class ExportUtil {
//    
//    public static void exportToPDF(HttpServletResponse response, 
//                                 DashboardStats stats, 
//                                 List<Order> orders, 
//                                 List<Product> topProducts) throws IOException {
//        response.setContentType("application/pdf");
//        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
//        response.setHeader("Content-Disposition", "attachment; filename=dashboard_report_" + timestamp + ".pdf");
//
//        try {
//            Document document = new Document(PageSize.A4);
//            PdfWriter.getInstance(document, response.getOutputStream());
//            document.open();
//
//            // Add title
//            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
//            Paragraph title = new Paragraph("Dashboard Report", titleFont);
//            title.setAlignment(Element.ALIGN_CENTER);
//            title.setSpacingAfter(20);
//            document.add(title);
//
//            // Add statistics
//            Font sectionFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14);
//            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 12);
//
//            document.add(new Paragraph("Statistics", sectionFont));
//            document.add(new Paragraph("Total Orders: " + stats.getTotalOrders(), normalFont));
//            document.add(new Paragraph("Total Revenue: $" + stats.getTotalRevenue(), normalFont));
//            document.add(new Paragraph("Average Order Value: $" + stats.getAverageOrderValue(), normalFont));
//            document.add(new Paragraph("Conversion Rate: " + String.format("%.2f%%", stats.getConversionRate()), normalFont));
//            document.add(Chunk.NEWLINE);
//
//            // Add orders table
//            document.add(new Paragraph("Recent Orders", sectionFont));
//            PdfPTable table = new PdfPTable(5);
//            table.setWidthPercentage(100);
//            table.addCell("Order ID");
//            table.addCell("Customer");
//            table.addCell("Amount");
//            table.addCell("Status");
//            table.addCell("Date");
//
//            for (Order order : orders) {
//                table.addCell(String.valueOf(order.getId()));
//                table.addCell(order.getCustomerName());
//                table.addCell("$" + order.getTotalAmount().toString());
//                table.addCell(order.getStatus());
//                table.addCell(order.getCreatedAt().toString());
//            }
//            document.add(table);
//            document.add(Chunk.NEWLINE);
//
//            // Add top products
//            document.add(new Paragraph("Top Products", sectionFont));
//            PdfPTable productsTable = new PdfPTable(3);
//            productsTable.setWidthPercentage(100);
//            productsTable.addCell("Product");
//            productsTable.addCell("Sales");
//            productsTable.addCell("Revenue");
//
//            for (Product product : topProducts) {
//                productsTable.addCell(product.getName());
//                productsTable.addCell(String.valueOf(product.getTotalSales()));
//                productsTable.addCell("$" + product.getRevenue().toString());
//            }
//            document.add(productsTable);
//
//            document.close();
//        } catch (DocumentException e) {
//            throw new IOException("Error creating PDF", e);
//        }
//    }
//
//    public static void exportToExcel(HttpServletResponse response,
//                                   DashboardStats stats,
//                                   List<Order> orders,
//                                   List<Product> topProducts) throws IOException {
//        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
//        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
//        response.setHeader("Content-Disposition", "attachment; filename=dashboard_report_" + timestamp + ".xlsx");
//
//        try (Workbook workbook = new XSSFWorkbook()) {
//            // Create styles
//            CellStyle headerStyle = workbook.createCellStyle();
//            Font headerFont = workbook.createFont();
//            headerFont.setBold(true);
//            headerStyle.setFont(headerFont);
//
//            // Stats sheet
//            Sheet statsSheet = workbook.createSheet("Statistics");
//            Row statsHeader = statsSheet.createRow(0);
//            statsHeader.createCell(0).setCellValue("Metric");
//            statsHeader.createCell(1).setCellValue("Value");
//            statsHeader.createCell(2).setCellValue("Growth");
//
//            Row totalOrdersRow = statsSheet.createRow(1);
//            totalOrdersRow.createCell(0).setCellValue("Total Orders");
//            totalOrdersRow.createCell(1).setCellValue(stats.getTotalOrders());
//            totalOrdersRow.createCell(2).setCellValue(stats.getOrderGrowth() + "%");
//
//            Row revenueRow = statsSheet.createRow(2);
//            revenueRow.createCell(0).setCellValue("Total Revenue");
//            revenueRow.createCell(1).setCellValue(stats.getTotalRevenue().doubleValue());
//            revenueRow.createCell(2).setCellValue(stats.getRevenueGrowth() + "%");
//
//            Row aovRow = statsSheet.createRow(3);
//            aovRow.createCell(0).setCellValue("Average Order Value");
//            aovRow.createCell(1).setCellValue(stats.getAverageOrderValue().doubleValue());
//            aovRow.createCell(2).setCellValue(stats.getAovGrowth() + "%");
//
//            Row conversionRow = statsSheet.createRow(4);
//            conversionRow.createCell(0).setCellValue("Conversion Rate");
//            conversionRow.createCell(1).setCellValue(stats.getConversionRate() + "%");
//            conversionRow.createCell(2).setCellValue(stats.getConversionGrowth() + "%");
//
//            // Orders sheet
//            Sheet ordersSheet = workbook.createSheet("Orders");
//            Row orderHeader = ordersSheet.createRow(0);
//            orderHeader.createCell(0).setCellValue("Order ID");
//            orderHeader.createCell(1).setCellValue("Customer");
//            orderHeader.createCell(2).setCellValue("Amount");
//            orderHeader.createCell(3).setCellValue("Status");
//            orderHeader.createCell(4).setCellValue("Date");
//
//            int rowNum = 1;
//            for (Order order : orders) {
//                Row row = ordersSheet.createRow(rowNum++);
//                row.createCell(0).setCellValue(order.getId());
//                row.createCell(1).setCellValue(order.getCustomerName());
//                row.createCell(2).setCellValue(order.getTotalAmount().doubleValue());
//                row.createCell(3).setCellValue(order.getStatus());
//                row.createCell(4).setCellValue(order.getCreatedAt().toString());
//            }
//
//            // Products sheet
//            Sheet productsSheet = workbook.createSheet("Top Products");
//            Row productHeader = productsSheet.createRow(0);
//            productHeader.createCell(0).setCellValue("Product");
//            productHeader.createCell(1).setCellValue("Sales");
//            productHeader.createCell(2).setCellValue("Revenue");
//
//            rowNum = 1;
//            for (Product product : topProducts) {
//                Row row = productsSheet.createRow(rowNum++);
//                row.createCell(0).setCellValue(product.getName());
//                row.createCell(1).setCellValue(product.getTotalSales());
//                row.createCell(2).setCellValue(product.getRevenue().doubleValue());
//            }
//
//            // Auto-size columns
//            for (int i = 0; i < workbook.getNumberOfSheets(); i++) {
//                Sheet sheet = workbook.getSheetAt(i);
//                int columnCount = sheet.getRow(0).getPhysicalNumberOfCells();
//                for (int j = 0; j < columnCount; j++) {
//                    sheet.autoSizeColumn(j);
//                }
//            }
//
//            workbook.write(response.getOutputStream());
//        }
//    }
//}
