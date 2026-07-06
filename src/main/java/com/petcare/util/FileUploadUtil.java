package com.petcare.util;

import javax.servlet.ServletException;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Locale;
import java.util.UUID;

public class FileUploadUtil {
    private static final long MAX_IMAGE_SIZE = 2L * 1024L * 1024L;

    private FileUploadUtil() {
    }

    public static String saveImage(Part part, String uploadRoot) throws IOException, ServletException {
        if (part == null || part.getSize() == 0) {
            return null;
        }
        if (part.getSize() > MAX_IMAGE_SIZE) {
            throw new ServletException("Kich thuoc anh toi da la 2MB.");
        }

        String submittedName = getSubmittedFileName(part);
        String extension = extensionOf(submittedName);
        if (!isAllowedImageExtension(extension)) {
            throw new ServletException("Chi ho tro anh JPG, JPEG, PNG hoac GIF.");
        }
        if (!hasValidImageSignature(part, extension)) {
            throw new ServletException("Noi dung file khong phai la anh hop le.");
        }

        File uploadDir = new File(uploadRoot);
        if (!uploadDir.exists() && !uploadDir.mkdirs()) {
            throw new IOException("Khong the tao thu muc upload.");
        }

        String fileName = UUID.randomUUID().toString().replace("-", "") + extension;
        part.write(new File(uploadDir, fileName).getAbsolutePath());
        return "/uploads/" + fileName;
    }

    private static boolean hasValidImageSignature(Part part, String extension) throws IOException {
        byte[] header = new byte[12];
        int read;
        try (InputStream inputStream = part.getInputStream()) {
            read = inputStream.read(header);
        }
        if (read < 3) {
            return false;
        }
        if (".jpg".equals(extension) || ".jpeg".equals(extension)) {
            return header[0] == (byte) 0xFF && header[1] == (byte) 0xD8 && header[2] == (byte) 0xFF;
        }
        if (".png".equals(extension)) {
            return read >= 8
                    && header[0] == (byte) 0x89
                    && header[1] == 0x50
                    && header[2] == 0x4E
                    && header[3] == 0x47;
        }
        if (".gif".equals(extension)) {
            return header[0] == 0x47 && header[1] == 0x49 && header[2] == 0x46;
        }
        return false;
    }

    private static String getSubmittedFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) {
            return "";
        }
        for (String token : contentDisposition.split(";")) {
            String trimmed = token.trim();
            if (trimmed.startsWith("filename=")) {
                return trimmed.substring(trimmed.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "";
    }

    private static String extensionOf(String fileName) {
        int dot = fileName == null ? -1 : fileName.lastIndexOf('.');
        if (dot < 0) {
            return "";
        }
        return fileName.substring(dot).toLowerCase(Locale.ROOT);
    }

    private static boolean isAllowedImageExtension(String extension) {
        return ".jpg".equals(extension) || ".jpeg".equals(extension) ||
                ".png".equals(extension) || ".gif".equals(extension);
    }
}