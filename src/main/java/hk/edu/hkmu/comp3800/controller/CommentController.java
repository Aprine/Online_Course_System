package hk.edu.hkmu.comp3800.controller;

import hk.edu.hkmu.comp3800.model.Comment;
import hk.edu.hkmu.comp3800.model.User;
import hk.edu.hkmu.comp3800.repository.CommentRepository;
import hk.edu.hkmu.comp3800.repository.LectureRepository;
import hk.edu.hkmu.comp3800.repository.PollRepository;
import hk.edu.hkmu.comp3800.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;

@Controller
public class CommentController {

    @Autowired
    private CommentRepository commentRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private LectureRepository lectureRepository;

    @Autowired
    private PollRepository pollRepository;

    @PostMapping("/comment/add")
    public String addComment(
            @RequestParam String content,
            @RequestParam(required = false) Long lectureId,
            @RequestParam(required = false) Long pollId,
            Authentication authentication) {

        // Get the currently logged-in user
        String username = authentication.getName();
        User author = userRepository.findByUsername(username);

        Comment comment = new Comment();
        comment.setContent(content);
        comment.setAuthor(author);
        comment.setCreatedAt(LocalDateTime.now());

        // Attach comment to either a Lecture or a Poll
        String redirectUrl = "/index";
        if (lectureId != null) {
            lectureRepository.findById(lectureId).ifPresent(comment::setLecture);
            redirectUrl = "/lecture/" + lectureId;
        } else if (pollId != null) {
            pollRepository.findById(pollId).ifPresent(comment::setPoll);
            redirectUrl = "/poll/" + pollId;
        }

        commentRepository.save(comment);

        // Redirect back to the page they commented on
        return "redirect:" + redirectUrl;
    }
}