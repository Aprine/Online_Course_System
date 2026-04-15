package hk.edu.hkmu.comp3800.controller;

import hk.edu.hkmu.comp3800.model.CourseMaterial;
import hk.edu.hkmu.comp3800.model.Lecture;
import hk.edu.hkmu.comp3800.model.Poll;
import hk.edu.hkmu.comp3800.model.PollOption;
import hk.edu.hkmu.comp3800.model.User;
import hk.edu.hkmu.comp3800.model.Vote;
import hk.edu.hkmu.comp3800.repository.CommentRepository;
import hk.edu.hkmu.comp3800.repository.CourseMaterialRepository;
import hk.edu.hkmu.comp3800.repository.LectureRepository;
import hk.edu.hkmu.comp3800.repository.PollRepository;
import hk.edu.hkmu.comp3800.repository.UserRepository;
import hk.edu.hkmu.comp3800.repository.VoteRepository;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/teacher")
@Transactional
public class AdminController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private LectureRepository lectureRepository;

    @Autowired
    private PollRepository pollRepository;

    @Autowired
    private CommentRepository commentRepository;

    @Autowired
    private CourseMaterialRepository courseMaterialRepository;

    @Autowired
    private VoteRepository voteRepository;

    @GetMapping("/dashboard")
    public String viewDashboard(Model model, @RequestParam(required = false) String success, @RequestParam(required = false) String error) {
        model.addAttribute("users", userRepository.findAll());
        model.addAttribute("lectures", lectureRepository.findAll());
        model.addAttribute("polls", pollRepository.findAll());
        model.addAttribute("comments", commentRepository.findAll());

        if (success != null) {
            model.addAttribute("successMessage", success);
        }
        if (error != null) {
            model.addAttribute("errorMessage", error);
        }

        return "teacher-dashboard";
    }

    @PostMapping("/user/delete")
    public String deleteUser(@RequestParam Long userId, Authentication authentication, HttpServletRequest request) {
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return "redirect:/teacher/dashboard?error=UserNotFound";
        }

        boolean deletingCurrentUser = authentication != null
                && authentication.getName() != null
                && authentication.getName().equals(user.getUsername());

        List<Vote> votes = voteRepository.findByUser(user);
        for (Vote vote : votes) {
            if (vote.getSelectedOption() != null) {
                vote.getSelectedOption().setVoteCount(Math.max(0, vote.getSelectedOption().getVoteCount() - 1));
                voteRepository.save(vote);
            }
            voteRepository.delete(vote);
        }

        commentRepository.findByAuthor(user).forEach(commentRepository::delete);
        userRepository.delete(user);

        if (deletingCurrentUser) {
            if (request.getSession(false) != null) {
                request.getSession(false).invalidate();
            }
            SecurityContextHolder.clearContext();
            return "redirect:/login?accountDeleted=true";
        }

        return "redirect:/teacher/dashboard?success=UserDeleted";
    }

    @PostMapping("/user/update")
    public String updateUser(
            @RequestParam Long userId,
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String phoneNumber,
            @RequestParam String role) {

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return "redirect:/teacher/dashboard?error=UserNotFound";
        }

        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhoneNumber(phoneNumber);
        user.setRole("ROLE_TEACHER".equalsIgnoreCase(role) ? "ROLE_TEACHER" : "ROLE_STUDENT");
        userRepository.save(user);

        return "redirect:/teacher/dashboard?success=UserUpdated";
    }

    @PostMapping("/comment/delete")
    public String deleteComment(@RequestParam Long commentId) {
        commentRepository.deleteById(commentId);
        return "redirect:/teacher/dashboard?success=CommentDeleted";
    }

    @PostMapping("/lecture/add")
    public String addLecture(
            @RequestParam String title,
            @RequestParam String summary,
            @RequestParam(required = false) String materialFileName,
            @RequestParam(required = false) String materialFilePath,
            @RequestParam(required = false) MultipartFile materialFile) {

        try {
            Lecture lecture = new Lecture();
            lecture.setTitle(title);
            lecture.setSummary(summary);

            CourseMaterial material = new CourseMaterial();
            if (materialFile != null && !materialFile.isEmpty()) {
                material.setFileName(isBlank(materialFileName) ? materialFile.getOriginalFilename() : materialFileName);
                material.setFilePath(storeUploadedMaterial(materialFile));
            } else {
                material.setFileName(isBlank(materialFileName) ? "Lecture Notes" : materialFileName);
                material.setFilePath(isBlank(materialFilePath) ? "/uploads/placeholder.txt" : materialFilePath);
            }
            material.setLecture(lecture);
            lecture.setMaterials(new ArrayList<>(List.of(material)));

            lectureRepository.save(lecture);
            return "redirect:/teacher/dashboard?success=LectureAdded";
        } catch (IOException ex) {
            return "redirect:/teacher/dashboard?error=UploadFailed";
        }
    }

    @PostMapping("/lecture/update")
    public String updateLecture(
            @RequestParam Long lectureId,
            @RequestParam String title,
            @RequestParam String summary,
            @RequestParam(required = false) String materialFileName,
            @RequestParam(required = false) String materialFilePath,
            @RequestParam(required = false) MultipartFile materialFile) {

        try {
            Lecture lecture = lectureRepository.findById(lectureId).orElse(null);
            if (lecture == null) {
                return "redirect:/teacher/dashboard?error=LectureNotFound";
            }

            lecture.setTitle(title);
            lecture.setSummary(summary);

            List<CourseMaterial> materials = lecture.getMaterials();
            CourseMaterial material = (materials != null && !materials.isEmpty())
                    ? materials.get(0)
                    : new CourseMaterial();
            boolean hasExistingMaterial = materials != null && !materials.isEmpty();
            if (materialFile != null && !materialFile.isEmpty()) {
                deleteStoredMaterial(material.getFilePath());
                material.setFileName(isBlank(materialFileName) ? materialFile.getOriginalFilename() : materialFileName);
                material.setFilePath(storeUploadedMaterial(materialFile));
            } else {
                if (!isBlank(materialFileName)) {
                    material.setFileName(materialFileName);
                } else if (material.getFileName() == null) {
                    material.setFileName("Lecture Notes");
                }
                if (!isBlank(materialFilePath)) {
                    material.setFilePath(materialFilePath);
                }
                if (!hasExistingMaterial && isBlank(material.getFilePath())) {
                    return "redirect:/teacher/dashboard?error=MaterialRequired";
                }
            }
            material.setLecture(lecture);
            if (materials == null) {
                materials = new ArrayList<>();
                lecture.setMaterials(materials);
            }
            if (materials.isEmpty()) {
                materials.add(material);
            }

            lectureRepository.save(lecture);
            return "redirect:/teacher/dashboard?success=LectureUpdated";
        } catch (IOException ex) {
            return "redirect:/teacher/dashboard?error=UploadFailed";
        }
    }

    @PostMapping("/lecture/delete")
    public String deleteLecture(@RequestParam Long lectureId) {
        Lecture lecture = lectureRepository.findById(lectureId).orElse(null);
        if (lecture != null && lecture.getMaterials() != null) {
            for (CourseMaterial material : lecture.getMaterials()) {
                deleteStoredMaterial(material.getFilePath());
            }
        }
        lectureRepository.deleteById(lectureId);
        return "redirect:/teacher/dashboard?success=LectureDeleted";
    }

    @PostMapping("/material/delete")
    public String deleteMaterial(@RequestParam Long materialId) {
        CourseMaterial material = courseMaterialRepository.findById(materialId).orElse(null);
        if (material == null) {
            return "redirect:/teacher/dashboard?error=MaterialNotFound";
        }

        Lecture lecture = material.getLecture();
        deleteStoredMaterial(material.getFilePath());

        if (lecture != null && lecture.getMaterials() != null) {
            lecture.getMaterials().removeIf(existing -> materialId.equals(existing.getId()));
            lectureRepository.save(lecture);
        }

        courseMaterialRepository.delete(material);
        return "redirect:/teacher/dashboard?success=MaterialDeleted";
    }

    @PostMapping("/poll/add")
    public String addPoll(
            @RequestParam String question,
            @RequestParam String option1,
            @RequestParam String option2,
            @RequestParam String option3,
            @RequestParam String option4,
            @RequestParam String option5) {

        Poll poll = new Poll();
        poll.setQuestion(question);

        PollOption pollOption1 = new PollOption();
        pollOption1.setOptionText(option1);
        pollOption1.setPoll(poll);
        PollOption pollOption2 = new PollOption();
        pollOption2.setOptionText(option2);
        pollOption2.setPoll(poll);
        PollOption pollOption3 = new PollOption();
        pollOption3.setOptionText(option3);
        pollOption3.setPoll(poll);
        PollOption pollOption4 = new PollOption();
        pollOption4.setOptionText(option4);
        pollOption4.setPoll(poll);
        PollOption pollOption5 = new PollOption();
        pollOption5.setOptionText(option5);
        pollOption5.setPoll(poll);

        poll.setOptions(new ArrayList<>(List.of(pollOption1, pollOption2, pollOption3, pollOption4, pollOption5)));
        pollRepository.save(poll);
        return "redirect:/teacher/dashboard?success=PollAdded";
    }

    @PostMapping("/poll/update")
    public String updatePoll(
            @RequestParam Long pollId,
            @RequestParam String question,
            @RequestParam String option1,
            @RequestParam String option2,
            @RequestParam String option3,
            @RequestParam String option4,
            @RequestParam String option5) {

        Poll poll = pollRepository.findById(pollId).orElse(null);
        if (poll == null) {
            return "redirect:/teacher/dashboard?error=PollNotFound";
        }

        poll.setQuestion(question);

        List<PollOption> options = poll.getOptions();
        if (options == null) {
            options = new ArrayList<>();
        }
        while (options.size() < 5) {
            PollOption option = new PollOption();
            option.setPoll(poll);
            options.add(option);
        }

        String[] texts = new String[]{option1, option2, option3, option4, option5};
        for (int i = 0; i < 5; i++) {
            options.get(i).setPoll(poll);
            options.get(i).setOptionText(texts[i]);
        }

        if (options.size() > 5) {
            options = new ArrayList<>(options.subList(0, 5));
        }

        poll.setOptions(options);
        pollRepository.save(poll);
        return "redirect:/teacher/dashboard?success=PollUpdated";
    }

    @PostMapping("/poll/delete")
    public String deletePoll(@RequestParam Long pollId) {
        pollRepository.deleteById(pollId);
        return "redirect:/teacher/dashboard?success=PollDeleted";
    }

    private String storeUploadedMaterial(MultipartFile file) throws IOException {
        Path uploadDir = Paths.get("data", "uploads").toAbsolutePath().normalize();
        Files.createDirectories(uploadDir);

        String originalName = file.getOriginalFilename() == null ? "upload.bin" : Paths.get(file.getOriginalFilename()).getFileName().toString();
        String storedName = UUID.randomUUID() + "_" + originalName;
        Path target = uploadDir.resolve(storedName);
        file.transferTo(target);
        return "/uploads/" + storedName;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void deleteStoredMaterial(String filePath) {
        if (filePath == null || !filePath.startsWith("/uploads/")) {
            return;
        }

        Path uploadDir = Paths.get("data", "uploads").toAbsolutePath().normalize();
        String fileName = Paths.get(filePath).getFileName().toString();
        Path target = uploadDir.resolve(fileName);
        try {
            Files.deleteIfExists(target);
        } catch (IOException ignored) {
            // Best effort cleanup. The database record is still removed.
        }
    }
}
