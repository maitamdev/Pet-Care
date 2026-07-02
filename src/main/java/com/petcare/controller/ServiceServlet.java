package com.petcare.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.petcare.dao.ServiceDAO;
import com.petcare.model.Service;
import com.petcare.util.CsrfUtil;
@WebServlet({"/admin/services", "/admin/services/new", "/admin/services/insert",
            "/admin/services/delete", "/admin/services/edit", "/admin/services/update"})
public class ServiceServlet extends HttpServlet {

    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/admin/services/new":
                showNewForm(request, response);
                break;
            case "/admin/services/edit":
                showEditForm(request, response);
                break;
            case "/admin/services/delete":
                response.sendRedirect(request.getContextPath() + "/admin/services");
                break;
            default:
                listServices(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getServletPath();

        if (!CsrfUtil.isValid(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/services?error=csrf");
            return;
        }

        switch (action) {
            case "/admin/services/insert":
                insertService(request, response);
                break;
            case "/admin/services/update":
                updateService(request, response);
                break;
            case "/admin/services/delete":
                deleteService(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/services");
                break;
        }
    }

    private void listServices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = fixGetEncoding(request.getParameter("keyword"));

        List<Service> list;

        if (keyword != null && !keyword.trim().isEmpty()) {
            list = serviceDAO.searchServicesByName(keyword.trim());
        } else {
            list = serviceDAO.getAllServices();
        }

        request.setAttribute("listServices", list);
        request.setAttribute("keyword", keyword);
        CsrfUtil.getToken(request);
        request.getRequestDispatcher("/WEB-INF/views/dashboard/service-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CsrfUtil.getToken(request);
        request.getRequestDispatcher("/WEB-INF/views/dashboard/service-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Service existingService = serviceDAO.getServiceById(id);
        request.setAttribute("service", existingService);
        CsrfUtil.getToken(request);
        request.getRequestDispatcher("/WEB-INF/views/dashboard/service-form.jsp").forward(request, response);
    }

    private void insertService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String priceRaw = request.getParameter("price");
        String description = request.getParameter("description");

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Tên dịch vụ không được để trống.");
            request.getRequestDispatcher("/WEB-INF/views/dashboard/service-form.jsp").forward(request, response);
            return;
        }

        if (priceRaw == null || priceRaw.trim().isEmpty()) {
            request.setAttribute("error", "Giá dịch vụ không được để trống.");
            request.getRequestDispatcher("/WEB-INF/views/dashboard/service-form.jsp").forward(request, response);
            return;
        }

        BigDecimal price;
        try {
            price = new BigDecimal(priceRaw.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Giá dịch vụ phải là số hợp lệ.");
            request.getRequestDispatcher("/WEB-INF/views/dashboard/service-form.jsp").forward(request, response);
            return;
        }

        if (price.compareTo(BigDecimal.ZERO) < 0) {
            request.setAttribute("error", "Giá dịch vụ không được nhỏ hơn 0.");
            request.getRequestDispatcher("/WEB-INF/views/dashboard/service-form.jsp").forward(request, response);
            return;
        }

        Service newService = new Service();
        newService.setName(name.trim());
        newService.setPrice(price);
        newService.setDescription(description);

        serviceDAO.addService(newService);
        response.sendRedirect(request.getContextPath() + "/admin/services?success=created");
    }

    private void updateService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String priceRaw = request.getParameter("price");
        String description = request.getParameter("description");

        Service s = new Service();
        s.setId(id);
        s.setName(name);
        s.setDescription(description);

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Tên dịch vụ không được để trống.");
            request.setAttribute("service", s);
            request.getRequestDispatcher("/WEB-INF/views/dashboard/service-form.jsp").forward(request, response);
            return;
        }

        if (priceRaw == null || priceRaw.trim().isEmpty()) {
            request.setAttribute("error", "Giá dịch vụ không được để trống.");
            request.setAttribute("service", s);
            request.getRequestDispatcher("/WEB-INF/views/dashboard/service-form.jsp").forward(request, response);
            return;
        }

        BigDecimal price;
        try {
            price = new BigDecimal(priceRaw.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Giá dịch vụ phải là số hợp lệ.");
            request.setAttribute("service", s);
            request.getRequestDispatcher("/WEB-INF/views/dashboard/service-form.jsp").forward(request, response);
            return;
        }

        if (price.compareTo(BigDecimal.ZERO) < 0) {
            request.setAttribute("error", "Giá dịch vụ không được nhỏ hơn 0.");
            request.setAttribute("service", s);
            request.getRequestDispatcher("/WEB-INF/views/dashboard/service-form.jsp").forward(request, response);
            return;
        }

        s.setName(name.trim());
        s.setPrice(price);
        s.setDescription(description);

        serviceDAO.updateService(s);
        response.sendRedirect(request.getContextPath() + "/admin/services?success=updated");
    }

    private void deleteService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        serviceDAO.deleteService(id);
        response.sendRedirect(request.getContextPath() + "/admin/services?success=deleted");
    }
    private String fixGetEncoding(String value) throws UnsupportedEncodingException {
        if (value == null) {
            return null;
        }
        return new String(value.getBytes("ISO-8859-1"), "UTF-8");
    }
}
