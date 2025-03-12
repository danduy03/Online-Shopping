package model;

public class Location {
    private int id;
    private String name;
    private int parentId;  // For storing province_id, district_id, or commune_id
    
    public Location() {
    }
    
    public Location(int id, String name) {
        this.id = id;
        this.name = name;
    }
    
    public Location(int id, String name, int parentId) {
        this.id = id;
        this.name = name;
        this.parentId = parentId;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public int getParentId() {
        return parentId;
    }
    
    public void setParentId(int parentId) {
        this.parentId = parentId;
    }
}
