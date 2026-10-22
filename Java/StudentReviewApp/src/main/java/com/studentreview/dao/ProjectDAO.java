package com.studentreview.dao;

import com.studentreview.model.Project;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProjectDAO {

    // ─── 1. REGISTER USER ───
    public boolean registerUser(String username, String hashedPassword, String role) {
        String query = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ps.setString(3, role);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── 2. AUTHENTICATE TRAINER/ADMIN ───
    public String authenticateUser(String username, String hashedPassword, String expectedRole) {
        String query = "SELECT role FROM users WHERE username = ? AND password = ? AND role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ps.setString(3, expectedRole);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("role");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ─── 3. AUTHENTICATE STUDENT WITH ID ───
    public int authenticateStudent(String username, String hashedPassword, int studentId) {
        String query = "SELECT id FROM users WHERE username = ? AND password = ? AND role = 'STUDENT' AND id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ps.setInt(3, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public int getUserId(String username) {
        String query = "SELECT id FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public String getUsernameById(int userId) {
        String query = "SELECT username FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("username");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getRoleById(int userId) {
        String query = "SELECT role FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("role");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean resetPasswordByRole(int userId, String username, String role, String newHashedPassword) {
        String query = "UPDATE users SET password = ? WHERE id = ? AND username = ? AND role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);
            ps.setString(3, username);
            ps.setString(4, role);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Project> getAllStudents() {
        List<Project> list = new ArrayList<>();
        String query = "SELECT id, username FROM users WHERE role = 'STUDENT' ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Project p = new Project();
                p.setStudentId(rs.getInt("id"));
                p.setStudentName(rs.getString("username"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── FEATURE 3: ASSIGN PROJECT WITH DEADLINE ───
    public boolean assignProjectWithDeadline(Project project, String dueDate) {
        String query = "INSERT INTO projects (title, description, student_id, trainer_id, status, due_date) " +
                       "VALUES (?, ?, ?, ?, 'ASSIGNED', ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, project.getTitle());
            ps.setString(2, project.getDescription());
            ps.setInt(3, project.getStudentId());
            ps.setInt(4, project.getTrainerId());
            if (dueDate == null || dueDate.trim().isEmpty()) {
                ps.setNull(5, Types.DATE);
            } else {
                ps.setDate(5, Date.valueOf(dueDate));
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Legacy assign (no deadline) — keep for compatibility
    public boolean assignProject(Project project) {
        return assignProjectWithDeadline(project, null);
    }

    // ─── FEATURE 1: GET DASHBOARD STATS ───
    public Map<String, Integer> getStats(int userId, String role) {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("total", 0);
        stats.put("assigned", 0);
        stats.put("underReview", 0);
        stats.put("completed", 0);
        stats.put("rejected", 0);

        String idCol = "STUDENT".equals(role) ? "student_id" : "trainer_id";
        String query = "SELECT status, COUNT(*) AS cnt FROM projects WHERE " + idCol + " = ? GROUP BY status";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                int total = 0;
                while (rs.next()) {
                    String status = rs.getString("status");
                    int cnt = rs.getInt("cnt");
                    total += cnt;
                    if ("ASSIGNED".equals(status)) stats.put("assigned", cnt);
                    else if ("UNDER_REVIEW".equals(status)) stats.put("underReview", cnt);
                    else if ("COMPLETED".equals(status)) stats.put("completed", cnt);
                    else if ("REJECTED".equals(status)) stats.put("rejected", cnt);
                }
                stats.put("total", total);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    // ─── FEATURE 2: SEARCH + FILTER ───
    public List<Project> searchProjects(int userId, String role, String keyword, String status) {
        List<Project> list = new ArrayList<>();
        String idCol = "STUDENT".equals(role) ? "p.student_id" : "p.trainer_id";

        StringBuilder sql = new StringBuilder(
            "SELECT p.*, u.username as student_name FROM projects p " +
            "JOIN users u ON p.student_id = u.id WHERE " + idCol + " = ?"
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.title LIKE ? OR p.description LIKE ?)");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND p.status = ?");
        }
        sql.append(" ORDER BY p.id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, userId);
            if (keyword != null && !keyword.trim().isEmpty()) {
                String pattern = "%" + keyword.trim() + "%";
                ps.setString(idx++, pattern);
                ps.setString(idx++, pattern);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(idx++, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(extractProject(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── FEATURE 4: NOTIFICATIONS ───
    public boolean addNotification(int userId, String title, String message) {
        String query = "INSERT INTO notifications (user_id, title, message) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, message);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getUnreadCount(int userId) {
        String query = "SELECT COUNT(*) AS cnt FROM notifications WHERE user_id = ? AND is_read = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Map<String, Object>> getNotifications(int userId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String query = "SELECT id, title, message, is_read, created_at FROM notifications " +
                       "WHERE user_id = ? ORDER BY id DESC LIMIT 50";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> n = new HashMap<>();
                    n.put("id", rs.getInt("id"));
                    n.put("title", rs.getString("title"));
                    n.put("message", rs.getString("message"));
                    n.put("isRead", rs.getInt("is_read") == 1);
                    n.put("createdAt", rs.getTimestamp("created_at"));
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean markAllNotificationsRead(int userId) {
        String query = "UPDATE notifications SET is_read = 1 WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── FEATURE 5: FILE UPLOAD ───
    public boolean updateProjectFile(int projectId, String filePath) {
        String query = "UPDATE projects SET project_file = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, filePath);
            ps.setInt(2, projectId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── GET PROJECTS BY STUDENT ───
    public List<Project> getProjectsByStudent(int studentId) {
        List<Project> list = new ArrayList<>();
        String query = "SELECT p.*, u.username as student_name FROM projects p " +
                       "JOIN users u ON p.student_id = u.id WHERE p.student_id = ? ORDER BY p.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(extractProject(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── GET PROJECTS BY TRAINER ───
    public List<Project> getProjectsByTrainer(int trainerId) {
        List<Project> list = new ArrayList<>();
        String query = "SELECT p.*, u.username as student_name FROM projects p " +
                       "JOIN users u ON p.student_id = u.id WHERE p.trainer_id = ? ORDER BY p.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, trainerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(extractProject(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Project getProjectById(int id) {
        String query = "SELECT p.*, u.username as student_name FROM projects p " +
                       "JOIN users u ON p.student_id = u.id WHERE p.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return extractProject(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateReview(int projectId, String feedback, String grade, String status) {
        String query = "UPDATE projects SET feedback = ?, grade = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, feedback);
            ps.setString(2, grade);
            ps.setString(3, status);
            ps.setInt(4, projectId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStudentReply(int projectId, String reply) {
        String query = "UPDATE projects SET student_reply = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, reply);
            ps.setInt(2, projectId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteProject(int projectId) {
        String query = "DELETE FROM projects WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, projectId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteUser(int userId) {
        String deleteProjects = "DELETE FROM projects WHERE student_id = ? OR trainer_id = ?";
        String deleteUser = "DELETE FROM users WHERE id = ? AND role <> 'ADMIN'";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(deleteProjects);
                 PreparedStatement ps2 = conn.prepareStatement(deleteUser)) {
                ps1.setInt(1, userId);
                ps1.setInt(2, userId);
                ps1.executeUpdate();
                ps2.setInt(1, userId);
                int rows = ps2.executeUpdate();
                conn.commit();
                return rows > 0;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Project extractProject(ResultSet rs) throws SQLException {
        Project p = new Project();
        p.setId(rs.getInt("id"));
        p.setTitle(rs.getString("title"));
        p.setDescription(rs.getString("description"));
        p.setStudentId(rs.getInt("student_id"));
        p.setTrainerId(rs.getInt("trainer_id"));
        p.setStatus(rs.getString("status"));
        p.setFeedback(rs.getString("feedback"));
        p.setGrade(rs.getString("grade"));
        p.setStudentName(rs.getString("student_name"));
        p.setStudentReply(rs.getString("student_reply"));

        try { p.setDueDate(rs.getDate("due_date")); } catch (Exception e) {}
        try { p.setProjectFile(rs.getString("project_file")); } catch (Exception e) {}

        return p;
    }
}