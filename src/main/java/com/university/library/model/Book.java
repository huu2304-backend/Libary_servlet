package com.university.library.model;

public class Book {
    private int id;
    private String title;
    private String author;
    private String imagePath;
    private int categoryId;
    private String categoryName;

    public Book() {}

    public Book(int id, String title, String author, String imagePath, int categoryId, String categoryName) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.imagePath = imagePath;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
    }

    public Book(String title, String author, String imagePath, int categoryId) {
        this.title = title;
        this.author = author;
        this.imagePath = imagePath;
        this.categoryId = categoryId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
}