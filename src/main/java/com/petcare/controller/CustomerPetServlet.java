package com.petcare.controller;

import com.petcare.dao.PetDAO;
import com.petcare.model.Pet;
import com.petcare.model.User;
import com.petcare.util.CsrfUtil;
import com.petcare.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet({"/my/pets", "/my/pets/new", "/my/pets/insert", "/my/pets/edit", "/my/pets/update"})
public class CustomerPetServlet extends HttpServlet {
    private PetDAO petDAO;

    @Override
    public void init() {
        petDAO = new PetDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = currentUser(request);
        String path = request.getServletPath();
        CsrfUtil.getToken(request);

        if ("/my/pets/new".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/customer/pet-form.jsp").forward(request, response);
            return;
        }
        if ("/my/pets/edit".equals(path)) {
            int id = parseInt(request.getParameter("id"));
            if (!petDAO.isPetOwnedByCustomer(id, user.getId())) {
                response.sendRedirect(request.getContextPath() + "/my/pets?error=notfound");
                return;
            }
            request.setAttribute("pet", petDAO.getPetById(id));
            request.getRequestDispatcher("/WEB-INF/views/customer/pet-form.jsp").forward(request, response);
            return;
        }

        request.setAttribute("listPets", petDAO.getPetsByCustomerId(user.getId()));
        request.getRequestDispatcher("/WEB-INF/views/customer/pet-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        if (!CsrfUtil.isValid(request)) {
            response.sendRedirect(request.getContextPath() + "/my/pets?error=csrf");
            return;
        }

        User user = currentUser(request);
        Pet pet = buildPet(request, user.getId());
        if (pet == null) {
            response.sendRedirect(request.getContextPath() + "/my/pets?error=invalid");
            return;
        }

        if ("/my/pets/update".equals(request.getServletPath())) {
            int id = parseInt(request.getParameter("id"));
            pet.setId(id);
            petDAO.updatePetForCustomer(pet);
            response.sendRedirect(request.getContextPath() + "/my/pets?success=updated");
        } else {
            petDAO.addPet(pet);
            response.sendRedirect(request.getContextPath() + "/my/pets?success=created");
        }
    }

    private Pet buildPet(HttpServletRequest request, int customerId) {
        String name = request.getParameter("name");
        String species = request.getParameter("species");
        if (ValidationUtil.isEmpty(name) || ValidationUtil.isEmpty(species)) {
            return null;
        }
        Pet pet = new Pet();
        pet.setCustomerId(customerId);
        pet.setName(name.trim());
        pet.setSpecies(species.trim());
        pet.setBreed(trim(request.getParameter("breed")));
        pet.setGender(trim(request.getParameter("gender")));
        pet.setNotes(trim(request.getParameter("notes")));

        String age = request.getParameter("age");
        try {
            if (!ValidationUtil.isEmpty(age)) {
                int parsedAge = parseInt(age);
                if (parsedAge < 0 || parsedAge > 80) {
                    return null;
                }
                pet.setAge(parsedAge);
            }
            String weight = request.getParameter("weight");
            if (!ValidationUtil.isEmpty(weight)) {
                BigDecimal parsedWeight = new BigDecimal(weight);
                if (parsedWeight.compareTo(BigDecimal.ZERO) < 0) {
                    return null;
                }
                pet.setWeight(parsedWeight);
            }
        } catch (NumberFormatException e) {
            return null;
        }
        return pet;
    }

    private User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (User) session.getAttribute("user");
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return -1;
        }
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
