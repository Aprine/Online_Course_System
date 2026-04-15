package hk.edu.hkmu.comp3800.controller;

import hk.edu.hkmu.comp3800.model.User;
import hk.edu.hkmu.comp3800.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Value("${app.teacher.invite-code}")
    private String teacherInviteCode;

    @PostMapping("/register")
    public String processRegistration(
            @RequestParam String username,
            @RequestParam String password,
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String phoneNumber,
            @RequestParam(defaultValue = "STUDENT") String role,
            @RequestParam(required = false) String inviteCode,
            Model model) {

        // Check if username already exists
        if (userRepository.findByUsername(username) != null) {
            model.addAttribute("error", "Username already exists. Please choose another.");
            return "register";
        }

        // Create and save new user
        User newUser = new User();
        newUser.setUsername(username);
        // Passwords must be encoded before saving to the database!
        newUser.setPassword(passwordEncoder.encode(password));
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPhoneNumber(phoneNumber);

        if ("TEACHER".equalsIgnoreCase(role)) {
            if (inviteCode == null || !teacherInviteCode.equals(inviteCode.trim())) {
                model.addAttribute("error", "Invalid teacher invite code.");
                return "register";
            }
            newUser.setRole("ROLE_TEACHER");
        } else {
            newUser.setRole("ROLE_STUDENT");
        }

        userRepository.save(newUser);

        // Redirect to login page after successful registration
        return "redirect:/login?registered=true";
    }
}
