package com.cropknowledge.model;

public class User {
    private final long id;
    private final String username;
    private final String passwordHash;
    private final String role;
    private final boolean active;

    public User(long id, String username, String passwordHash, String role, boolean active) {
        this.id = id;
        this.username = username;
        this.passwordHash = passwordHash;
        this.role = role;
        this.active = active;
    }

    public long getId() { return id; }
    public String getUsername() { return username; }
    public String getPasswordHash() { return passwordHash; }
    public String getRole() { return role; }
    public boolean isActive() { return active; }
}
