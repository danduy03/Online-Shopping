package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Location;
import utils.DBContext;

@WebServlet(name = "LocationServlet", urlPatterns = {"/api/provinces", "/api/districts", "/api/communes", "/api/villages"})
public class LocationServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String path = request.getServletPath();
        try {
            List<Location> locations = new ArrayList<>();
            
            switch (path) {
                case "/api/provinces":
                    locations = getProvinces();
                    break;
                case "/api/districts":
                    String provinceId = request.getParameter("provinceId");
                    if (provinceId != null && !provinceId.isEmpty()) {
                        locations = getDistricts(Integer.parseInt(provinceId));
                    }
                    break;
                case "/api/communes":
                    String districtId = request.getParameter("districtId");
                    if (districtId != null && !districtId.isEmpty()) {
                        locations = getCommunes(Integer.parseInt(districtId));
                    }
                    break;
                case "/api/villages":
                    String communeId = request.getParameter("communeId");
                    if (communeId != null && !communeId.isEmpty()) {
                        locations = getVillages(Integer.parseInt(communeId));
                    }
                    break;
            }
            
            String jsonResponse = gson.toJson(locations);
            response.getWriter().write(jsonResponse);
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson("Error: " + e.getMessage()));
        }
    }

    private List<Location> getProvinces() throws Exception {
        List<Location> provinces = new ArrayList<>();
        String sql = "SELECT id, name FROM provinces ORDER BY name";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                provinces.add(new Location(
                    rs.getInt("id"),
                    rs.getString("name")
                ));
            }
        }
        return provinces;
    }

    private List<Location> getDistricts(int provinceId) throws Exception {
        List<Location> districts = new ArrayList<>();
        String sql = "SELECT id, name, province_id FROM districts WHERE province_id = ? ORDER BY name";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, provinceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    districts.add(new Location(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getInt("province_id")
                    ));
                }
            }
        }
        return districts;
    }

    private List<Location> getCommunes(int districtId) throws Exception {
        List<Location> communes = new ArrayList<>();
        String sql = "SELECT id, name, district_id FROM communes WHERE district_id = ? ORDER BY name";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, districtId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    communes.add(new Location(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getInt("district_id")
                    ));
                }
            }
        }
        return communes;
    }

    private List<Location> getVillages(int communeId) throws Exception {
        List<Location> villages = new ArrayList<>();
        String sql = "SELECT id, name, commune_id FROM villages WHERE commune_id = ? ORDER BY name";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, communeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    villages.add(new Location(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getInt("commune_id")
                    ));
                }
            }
        }
        return villages;
    }
}
