package com.petcare.util;

import com.petcare.model.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public final class SessionUtil {

    private SessionUtil() {
    }

    public static User requireUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        return user;
    }

    public static void bindUser(HttpServletRequest request, User user) {
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("user", sanitizeForSession(user));
    }

    public static void updateUser(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.setAttribute("user", sanitizeForSession(user));
        }
    }

    public static User sanitizeForSession(User user) {
        if (user == null) {
            return null;
        }
        User copy = new User();
        copy.setId(user.getId());
        copy.setFullName(user.getFullName());
        copy.setUsername(user.getUsername());
        copy.setPhone(user.getPhone());
        copy.setEmail(user.getEmail());
        copy.setImageUrl(user.getImageUrl());
        copy.setSpecialty(user.getSpecialty());
        copy.setRole(user.getRole());
        copy.setStatus(user.getStatus());
        copy.setAddress(user.getAddress());
        return copy;
    }
}