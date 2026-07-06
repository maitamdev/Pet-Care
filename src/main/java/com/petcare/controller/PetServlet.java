package com.petcare.controller;

import com.petcare.dao.PetDAO;
import com.petcare.dao.UserDAO;
import com.petcare.model.Pet;
import com.petcare.model.User;
import com.petcare.util.CsrfUtil;
import com.petcare.util.FileUploadUtil;
import com.petcare.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet({"/admin/pets", "/admin/pets/new", "/admin/pets/insert", 
             "/admin/pets/delete", "/admin/pets/edit", "/admin/pets/update"})
@MultipartConfig(maxFileSize = 2 * 1024 * 1024, maxRequestSize = 3 * 1024 * 1024)
public class PetServlet extends HttpServlet {

    private PetDAO petDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        petDAO = new PetDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/admin/pets/new":
                showNewForm(request, response);
                break;
            case "/admin/pets/edit":
                showEditForm(request, response);
                break;
            case "/admin/pets/delete":
                response.sendRedirect(request.getContextPath() + "/admin/pets");
                break;
            default:
                listPets(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        if (!CsrfUtil.isValid(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/pets?error=csrf");
            return;
        }

        switch (action) {
            case "/admin/pets/insert":
                insertPet(request, response);
                break;
            case "/admin/pets/update":
                updatePet(request, response);
                break;
            case "/admin/pets/delete":
                deletePet(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/pets");
                break;
        }
    }

    private void listPets(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Pet> list = petDAO.getAllPets();
        request.setAttribute("listPets", list);
        CsrfUtil.getToken(request);
        request.getRequestDispatcher("/WEB-INF/views/dashboard/pet-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> customers = userDAO.getAllCustomers();
        request.setAttribute("listCustomers", customers);
        CsrfUtil.getToken(request);
        request.getRequestDispatcher("/WEB-INF/views/dashboard/pet-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = ValidationUtil.parseIntOrDefault(request.getParameter("id"), -1);
        Pet existingPet = petDAO.getPetById(id);
        if (existingPet == null) {
            response.sendRedirect(request.getContextPath() + "/admin/pets?error=notfound");
            return;
        }
        request.setAttribute("pet", existingPet);
        
        List<User> customers = userDAO.getAllCustomers();
        request.setAttribute("listCustomers", customers);
        CsrfUtil.getToken(request);
        
        request.getRequestDispatcher("/WEB-INF/views/dashboard/pet-form.jsp").forward(request, response);
    }

    private void insertPet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int customerId = ValidationUtil.parseIntOrDefault(request.getParameter("customerId"), -1);
        if (customerId <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/pets/new?error=invalid");
            return;
        }
        String name = request.getParameter("name");
        String species = request.getParameter("species");

        if (ValidationUtil.isEmpty(name) || ValidationUtil.isEmpty(species)) {
            response.sendRedirect(request.getContextPath() + "/admin/pets/new?error=invalid");
            return;
        }
        
        Pet p = buildPetFromRequest(request, customerId, -1);
        if (p == null) {
            response.sendRedirect(request.getContextPath() + "/admin/pets/new?error=invalid");
            return;
        }
        petDAO.addPet(p);
        response.sendRedirect(request.getContextPath() + "/admin/pets");
    }

    private void updatePet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id = ValidationUtil.parseIntOrDefault(request.getParameter("id"), -1);
        int customerId = ValidationUtil.parseIntOrDefault(request.getParameter("customerId"), -1);
        if (id <= 0 || customerId <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/pets?error=invalid");
            return;
        }
        String name = request.getParameter("name");
        String species = request.getParameter("species");

        if (ValidationUtil.isEmpty(name) || ValidationUtil.isEmpty(species)) {
            response.sendRedirect(request.getContextPath() + "/admin/pets/edit?id=" + id + "&error=invalid");
            return;
        }
        
        Pet p = buildPetFromRequest(request, customerId, id);
        if (p == null) {
            response.sendRedirect(request.getContextPath() + "/admin/pets/edit?id=" + id + "&error=invalid");
            return;
        }
        petDAO.updatePet(p);
        response.sendRedirect(request.getContextPath() + "/admin/pets");
    }

    private void deletePet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = ValidationUtil.parseIntOrDefault(request.getParameter("id"), -1);
        petDAO.deletePet(id);
        response.sendRedirect(request.getContextPath() + "/admin/pets");
    }

    private Pet buildPetFromRequest(HttpServletRequest request, int customerId, int id)
            throws IOException, ServletException {
        String name = request.getParameter("name");
        String species = request.getParameter("species");
        String breed = request.getParameter("breed");
        if (ValidationUtil.isEmpty(name) || ValidationUtil.isEmpty(species)) {
            return null;
        }

        Pet p = new Pet();
        if (id > 0) {
            p.setId(id);
        }
        p.setCustomerId(customerId);
        p.setName(name);
        p.setSpecies(species);
        p.setBreed(breed);

        try {
            String ageStr = request.getParameter("age");
            if (ageStr != null && !ageStr.trim().isEmpty()) {
                p.setAge(ValidationUtil.parseIntOrDefault(ageStr, -1));
            }
            String weightStr = request.getParameter("weight");
            if (weightStr != null && !weightStr.trim().isEmpty()) {
                p.setWeight(new BigDecimal(weightStr));
            }
        } catch (NumberFormatException e) {
            return null;
        }

        p.setGender(request.getParameter("gender"));
        String imageUrl = FileUploadUtil.saveImage(request.getPart("image"), getUploadRoot());
        if (imageUrl == null && id > 0) {
            Pet existing = petDAO.getPetById(id);
            imageUrl = existing == null ? null : existing.getImageUrl();
        }
        p.setImageUrl(imageUrl);
        p.setNotes(request.getParameter("notes"));
        return p;
    }

    private String getUploadRoot() {
        return getServletContext().getRealPath("/uploads");
    }
}
