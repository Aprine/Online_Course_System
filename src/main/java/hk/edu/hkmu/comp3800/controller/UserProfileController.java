package hk.edu.hkmu.comp3800.controller;

import hk.edu.hkmu.comp3800.model.User;
import hk.edu.hkmu.comp3800.repository.CommentRepository;
import hk.edu.hkmu.comp3800.repository.UserRepository;
import hk.edu.hkmu.comp3800.repository.VoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class UserProfileController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private VoteRepository voteRepository;

    @Autowired
    private CommentRepository commentRepository;

    // Display the user profile and their history
    @GetMapping("/profile")
    public String viewProfile(Authentication authentication, Model model, @RequestParam(required = false) String success) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }

        String username = authentication.getName();
        User currentUser = userRepository.findByUsername(username);

        model.addAttribute("user", currentUser);
        model.addAttribute("votingHistory", voteRepository.findByUser(currentUser));
        model.addAttribute("commentHistory", commentRepository.findByAuthor(currentUser));
        
        if (success != null) {
            model.addAttribute("successMessage", "Profile updated successfully!");
        }

        return "profile"; // Resolves to /WEB-INF/jsp/profile.jsp
    }

    // Handle profile updates (Requirement 1.d.iii)
    @PostMapping("/profile/update")
    public String updateProfile(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String phoneNumber,
            Authentication authentication) {
        
        String username = authentication.getName();
        User currentUser = userRepository.findByUsername(username);
        
        // Update everything EXCEPT the username (which is restricted) and password
        currentUser.setFullName(fullName);
        currentUser.setEmail(email);
        currentUser.setPhoneNumber(phoneNumber);
        
        userRepository.save(currentUser);
        
        return "redirect:/profile?success=updated";
    }
}