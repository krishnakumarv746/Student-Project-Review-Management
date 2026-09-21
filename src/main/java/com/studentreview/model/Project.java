package com.studentreview.model;

import java.sql.Date;

public class Project {
    private int id;
    private String title;
    private String description;
    private int studentId;
    private int trainerId;
    private String status;
    private String feedback;
    private String grade;
    private String studentName;
    private String studentReply;

    // ⭐ NEW fields
    private Date dueDate;
    private String projectFile;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public int getTrainerId() { return trainerId; }
    public void setTrainerId(int trainerId) { this.trainerId = trainerId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }
    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public String getStudentReply() { return studentReply; }
    public void setStudentReply(String studentReply) { this.studentReply = studentReply; }

    // ⭐ NEW
    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }
    public String getProjectFile() { return projectFile; }
    public void setProjectFile(String projectFile) { this.projectFile = projectFile; }

    public boolean isOverdue() {
        if (dueDate == null) return false;
        if ("COMPLETED".equals(status)) return false;
        return dueDate.before(new java.util.Date());
    }
}