package hk.edu.hkmu.comp3800.controller;

import hk.edu.hkmu.comp3800.model.Lecture;
import hk.edu.hkmu.comp3800.repository.LectureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.Optional;

@Controller
public class LectureController {

    @Autowired
    private LectureRepository lectureRepository;

    @GetMapping("/lecture/{id}")
    public String viewLecturePage(@PathVariable Long id, Model model) {
        Optional<Lecture> lectureOpt = lectureRepository.findById(id);
        
        if (lectureOpt.isPresent()) {
            Lecture lecture = lectureOpt.get();
            model.addAttribute("lecture", lecture);
            // The materials and comments lists are attached to the Lecture entity
            model.addAttribute("materials", lecture.getMaterials());
            model.addAttribute("comments", lecture.getComments());
            return "lecture"; // Resolves to /WEB-INF/jsp/lecture.jsp
        } else {
            return "redirect:/index"; // If lecture doesn't exist, send back to home
        }
    }
}