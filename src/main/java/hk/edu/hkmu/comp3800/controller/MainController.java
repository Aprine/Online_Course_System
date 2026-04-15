package hk.edu.hkmu.comp3800.controller;

import hk.edu.hkmu.comp3800.repository.LectureRepository;
import hk.edu.hkmu.comp3800.repository.PollRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    @Autowired
    private LectureRepository lectureRepository;

    @Autowired
    private PollRepository pollRepository;

    @GetMapping({"/", "/index"})
    public String viewIndexPage(Model model) {
        // Pass system data to the JSP file
        model.addAttribute("courseName", "COMP 3800SEF Web Applications");
        model.addAttribute("courseDescription", "Design and Development of Enterprise Web Applications.");
        model.addAttribute("lectures", lectureRepository.findAll());
        model.addAttribute("polls", pollRepository.findAll());
        
        return "index"; // Resolves to /WEB-INF/jsp/index.jsp
    }

    @GetMapping("/login")
    public String viewLoginPage() {
        return "login"; // Resolves to /WEB-INF/jsp/login.jsp
    }

    @GetMapping("/register")
    public String viewRegisterPage() {
        return "register"; // Resolves to /WEB-INF/jsp/register.jsp
    }
}