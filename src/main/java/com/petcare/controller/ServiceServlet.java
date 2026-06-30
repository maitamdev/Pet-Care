package com.petcare.controller;

import com.petcare.dao.ServiceDAO;
import com.petcare.model.Service;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

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
                deleteService(request, response);
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

        switch (action) {
            case "/admin/services/insert":
                insertService(request, response);
                break;
            case "/admin/services/update":
                updateService(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/services");
                break;
        }
    }

    private void listServices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Service> list = serviceDAO.getAllServices();
        request.setAttribute("listServices", list);
        request.getRequestDispatcher("/WEB-INF/views/dashboard/service-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/dashboard/service-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Service existingService = serviceDAO.getServiceById(id);
        request.setAttribute("service", existingService);
        request.getRequestDispatcher("/WEB-INF/views/dashboard/service-form.jsp").forward(request, response);
    }

    private void insertService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String name = request.getParameter("name");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        String description = request.getParameter("description");

        Service newService = new Service();
        newService.setName(name);
        newService.setPrice(price);
        newService.setDescription(description);

        serviceDAO.addService(newService);
        response.sendRedirect(request.getContextPath() + "/admin/services");
    }

    private void updateService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        String description = request.getParameter("description");

        Service s = new Service();
        s.setId(id);
        s.setName(name);
        s.setPrice(price);
        s.setDescription(description);

        serviceDAO.updateService(s);
        response.sendRedirect(request.getContextPath() + "/admin/services");
    }

    private void deleteService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        serviceDAO.deleteService(id);
        response.sendRedirect(request.getContextPath() + "/admin/services");
    }
}
