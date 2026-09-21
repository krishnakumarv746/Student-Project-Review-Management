package com.studentreview.controller;

import com.studentreview.dao.ProjectDAO;
import com.studentreview.model.Project;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/uploadFile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 15
)
public class FileUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProjectDAO projectDAO = new ProjectDAO();
    private static final String UPLOAD_DIR = "uploads";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"STUDENT".equals(session.getAttribute("role"))) {
            response.sendRedirect("student-login.jsp");
            return;
        }

        int projectId = Integer.parseInt(request.getParameter("projectId"));
        Part filePart = request.getPart("projectFile");

        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("feedback.jsp?id=" + projectId + "&error=Please select a file.");
            return;
        }

        String originalName = filePart.getSubmittedFileName();
        String ext = "";
        int dotIdx = originalName.lastIndexOf('.');
        if (dotIdx > 0) ext = originalName.substring(dotIdx).toLowerCase();

        if (!ext.equals(".pdf") && !ext.equals(".zip") && !ext.equals(".doc")
                && !ext.equals(".docx") && !ext.equals(".txt")) {
            response.sendRedirect("feedback.jsp?id=" + projectId + "&error=Only PDF, ZIP, DOC, DOCX, TXT allowed.");
            return;
        }

        String appPath = request.getServletContext().getRealPath("");
        String uploadPath = appPath + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String fileName = "project_" + projectId + "_" + System.currentTimeMillis() + ext;
        String filePath = uploadPath + File.separator + fileName;

        filePart.write(filePath);

        String dbPath = UPLOAD_DIR + "/" + fileName;
        projectDAO.updateProjectFile(projectId, dbPath);

        Project p = projectDAO.getProjectById(projectId);
        if (p != null) {
            String studentName = (String) session.getAttribute("username");
            projectDAO.addNotification(
                p.getTrainerId(),
                "File Uploaded by " + studentName,
                studentName + " uploaded a file for: " + p.getTitle()
            );
        }

        response.sendRedirect("feedback.jsp?id=" + projectId + "&success=File uploaded successfully.");
    }
}